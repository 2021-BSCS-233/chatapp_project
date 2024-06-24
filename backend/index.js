const mongoose = require('mongoose')
const { MongoClient, ServerApiVersion } = require('mongodb')
const User = require('./schemas/Users')
const Request = require('./schemas/Requests')
const Chat = require('./schemas/Chats')
const Message = require('./schemas/Messages')
const Friend = require('./schemas/Friends')
const express = require('express')
const app = express()
const http = require('http').createServer(app)
const io = require('socket.io')(http)
const port = 3000;

const uri = "mongodb+srv://nehalmahdi9:kMCqPPv0VH5hjRA5@chatapp.1hgjo7w.mongodb.net/chatapp_data?retryWrites=true&w=majority&appName=chatapp"

mongoose.connect(uri)
    .then(() => console.log("Connected to MongoDB"))
    .catch(error => console.log("Error connecting to MongoDB:", error));

process.on('SIGINT', async () => {
    await User.updateMany({},{socket_id:'', status: 'Offline'})
    await mongoose.connection.close();
    if (mongoose.connection.readyState === 0) {
        console.log('Connection successfully closed');
      } else {
        console.log('Connection may not have closed properly');
      }
    process.exit(0);
});

app.use(express.json())
app.use(express.urlencoded({
    extended: true,
}));

//app.listen(port, () => {
//    console.log(`connected to http://localhost:${port}`)
//});
http.listen(port, () => {
  console.log(`connected to http://localhost:${port}`);
});

io.on('connection', (socket) => {
  socket.on('save_socket_id',async (data) => {
      try{
        await User.updateOne({_id:data.userId},{socket_id:data.socketId})
        console.log(data.userId,data.socketId)
        await updateFriends(data.userId)
      } catch(e){
        console.log(e)
      }
  });
  socket.on('close_socket_id',async (data) => {
      try{
        await User.updateOne({_id:data.userId},{socket_id:'', status: 'Offline'})
//        await updateFriends(data.userId)
        console.log('A client logged out and disconnected');
      } catch(e){
        console.log(e)
      }
  });
  socket.on('disconnect',async () => {
      try{
        await User.updateOne({socket_id:socket.id},{socket_id:'', status: 'Offline'})
//        await updateFriends(data.userId)
        console.log('A client closed the app and disconnected');
      } catch(e){
        console.log(e)
      }
  });
  // (rest of your event handling logic)
});

app.get('/', (req, res) => {
    res.send("connected");
});


app.post('/signin_user', async (req, res) => {
    console.log('signin')
    console.log("received body ", req.body)
    userCheck = await User.findOne({$or:[{username: req.body['username']},{email: req.body['email']}]})
    if (userCheck == null){
        const newUser = new User({
            username: req.body['username'],
            display_name: req.body['display'],
            email: req.body['email'],
            password: req.body['password'], // add function to hash the password
        });

        newUser.save()
            .then(async () => {
                savedUser = await User.findOne({username: req.body['username']})
                const friendList = new Friend({
                            user: savedUser._id,
                        })
                friendList.save()
                console.log("User created successfully!")
                console.log('result', savedUser)
                res.status(200).send(savedUser)
            })
            .catch(error => console.error("Error creating user:", error));
    } else {
        res.status(201).send()
    }

})

app.post('/login_user', async (req, res) =>{
    console.log('login')
    userData = await User.findOne({email: req.body['email']})
    console.log('userdata', req.body)
    if(userData != null){
        if(userData['password'] == req.body['password']){
            console.log('accepted')
            await User.updateOne({_id:userData._id},{status:'Online'})
            userData['status'] = 'Online'
            res.status(200).send(userData)
        } else {
            console.log('rejected')
            res.status(201).send()
        }
    } else {
        console.log('no user')
        res.status(202).send()
    }
})

app.post('/add_request', async (req, res)=>{
    userCheck = await User.findOne({username: req.body['username']})
    console.log('add_request')
    if (userCheck != null){
        friendCheck = await Friend.findOne({user: req.body['sender_id']})
        if (!(userCheck._id in friendCheck.friends)){
            requestCheck = await Request.findOne({sender_id: req.body['sender_id'], receiver_id: userCheck._id})
            if(requestCheck == null){
                const requestData = new Request({
                    sender_id: req.body['sender_id'],
                    receiver_id: userCheck._id
                })
                requestData.save()
                .then(async () => {
                    if (userCheck.socket_id != ''){
                        io.to(userCheck.socket_id).emit('updateRequests', 0);
                        console.log(`send to ${userData.socket_id}`)
                    } else {
                        console.log(`$user not online to send`)
                    }
                    res.status(200).send('success')
                })
                .catch(error => console.error("Error creating user:", error));
            } else {
                console.log('request already exists')
                res.status(203).send()
            }
        } else {
            console.log('already friended')
            res.status(202).send()
        }
    } else {
        console.log(`${req.body['username']} user not found`)
        res.status(201).send()
    }
})

app.post('/get_incoming_requests', async(req, res)=>{
    console.log('get_incoming_request')
    var requestData = []
    requests = await Request.find({receiver_id:req.body['receiver_id']})
    if(requests != null){
        console.log('requests retried')
        console.log(requests)
        for (request of requests) {
          requestUserData = await User.findOne({_id: request.sender_id})
//          console.log('individual use data', requestUserData)
          requestData.push({
            'request_id': request._id,
            'username': requestUserData.username,
            'display': requestUserData.display_name,
            'profile_pic': requestUserData.profile_picture
          })
        }
        res.status(200).send(requestData)
    } else {
        console.log('no requests found')
        res.status(201).send()
    }
})

app.post('/get_outgoing_requests', async(req, res)=>{
    console.log('get_outgoing_requests')
    var requestData = []
    requests = await Request.find({sender_id:req.body['sender_id']})
    if(requests != null){
        console.log('requests retried')
        console.log(requests)
        for (request of requests) {
          requestUserData = await User.findOne({_id: request.receiver_id})
//          console.log('individual use data', requestUserData)
          requestData.push({
            'request_id': request._id,
            'username': requestUserData.username,
            'display': requestUserData.display_name,
            'profile_pic': requestUserData.profile_picture
          })
        }
        res.status(200).send(requestData)
    } else {
        console.log('no requests found')
        res.status(201).send()
    }
})

app.post('/request_action', async(req, res)=>{
    requestCheck = await Request.findOne({_id: req.body['request_id']})
    console.log('request_action')
    if (requestCheck != null){
        console.log('performing:',req.body['action'])
        if (req.body['action'] == 'deny'){
            await Request.deleteOne({_id: req.body['request_id']})
            senderData = await User.findOne({_id:requestCheck.sender_id})
            if (senderData.socket_id != ''){
                io.to(senderData.socket_id).emit('updateRequests', 0);
                console.log(`send to ${userData.socket_id}`)
            } else {
                console.log(`$user not online to send`)
            }
            receiverData = await User.findOne({_id:requestCheck.sender_id})
            if (receiverData.socket_id != ''){
                io.to(receiverData.socket_id).emit('updateRequests', 0);
                console.log(`send to ${userData.socket_id}`)
            } else {
                console.log(`$user not online to send`)
            }
            res.status(200).send()
        } else if (req.body['action'] == 'accept'){
            await Request.deleteOne({_id: req.body['request_id']})
            await Friend.updateOne({user:requestCheck.sender_id},{$push:{friends:requestCheck.receiver_id}})
            await Friend.updateOne({user:requestCheck.receiver_id},{$push:{friends:requestCheck.sender_id}})
            const newChat = new Chat ({
                users: [requestCheck.sender_id,requestCheck.receiver_id],
                chat_visible: [true,true]
            })
            newChat.save()
                .then(async () => {
                    userData = await User.findOne({_id:requestCheck.sender_id})
                    if (userData.socket_id != ''){
                        io.to(userData.socket_id).emit('updateRequests', 1);
                        console.log(`send to ${userData.socket_id}`)
                    } else {
                        console.log(`$user not online to send`)
                    }
                    console.log("Request sent successfully!")
                    res.status(200).send()
                })
                .catch(error =>{
                    console.error("Error sending request:", error)
                    res.status(203).send()
                });
        } else {
            console.log('action denied')
            res.status(202).send()
        }
    } else {
        res.status(201).send()
    }
})

app.post('/get_chats', async (req, res) =>{
    chatsData = await Chat.find({users: { $in: [req.body['user_id']] }});
    console.log('get_chats')
    if(chatsData != null){
        var chatsPresentData = []
        for(chatData of chatsData){
            var users = []
            var usersData = []
            users = chatData.users
            users = users.filter(user => user !== req.body['user_id'])
            for(user of users){
                userData = await User.findOne({_id: user})
                usersData.push({
                    'user_id': userData._id,
                    'username': userData.username,
                    'display': userData.display_name,
                    'picture': userData.profile_picture,
                    'status': userData.status,
                    'status_display': userData.status_display
                })
            }
            chatsPresentData.push({
                'chat_id': chatData._id,
                'users': usersData,
                'latest_message': chatData.latest_message,
                'chat_type': chatData.chat_type
            })
        }
        res.status(200).send(chatsPresentData)
    } else {
        res.status(201).send()
    }
})

app.post('/get_friends', async (req, res)=>{
    try {
        console.log('get_friends')
        friendsData = await Friend.findOne({user: req.body['user_id']})
        if (friendsData != null && friendsData.friends != []){
            var friendsPresentData = []
            for (friend of friendsData.friends){
                userData = await User.findOne({_id: friend})
                chatData = await Chat.findOne({$or:[{users: [req.body['user_id'],friend]},{users: [friend,req.body['user_id']]}]})
                friendsPresentData.push({
                    'friend_id': userData._id,
                    'display': userData.display_name,
                    'status': userData.status,
                    'status_display': userData.status_display,
                    'picture': userData.profile_picture,
                    'chat_id': chatData._id,
                })
            }
            res.status(200).send(friendsPresentData)
        } else {
            res.status(201).send()
        }
    } catch(e){
        console.log(`error occurred in friend data processing ${e}`)
    }
})

app.post('/get_chat', async (req, res)=>{
    try {
        console.log('get_chat')
        chatData = await Chat.findOne({_id: req.body['chat_id']})
        if (chatData != null){
            usersData = {}
            for(user of chatData.users){
                userData = await User.findOne({_id: user})
                usersData[user] = {
                    'user_id': userData._id,
                    'display': userData.display_name,
                    'picture': userData.profile_picture
                }
            }
            messagesData = []
            messages = await Message.find({chat_id:req.body['chat_id']})
            for (message of messages){
                userData = usersData[message.sender_id]
                messagesData.push({
                    'message_id': message._id,
                    'message': message.message,
                    'time_stamp': message.time_stamp,
                    'user_id': userData['user_id'],
                    'display': userData['display'],
                    'picture': userData['picture'],
                })
            }
            res.status(200).send(messagesData)
        } else {
            res.status(201).send()
        }
    } catch (e) {
        console.log(`error occurred in message data processing ${e}`)
        res.status(300).send()
    }
})

app.post('/send_message', async (req, res) =>{
    console.log('send_message')
    const newMessage = new Message ({
        chat_id: req.body['chat_id'],
        sender_id: req.body['sender_id'],
        message: req.body['message'],
        time_stamp: req.body['time'],
    })
    newMessage.save()
    .then(async () => {
        await Chat.updateOne({_id:req.body['chat_id']},{latest_message:req.body['message']})
        senderData = await User.findOne({_id:req.body['sender_id']})
        messageData = {
            'message_id':newMessage._id,
            'message': newMessage.message,
            'time_stamp': newMessage.time_stamp,
            'user_id': senderData._id,
            'display': senderData.display_name,
            'picture': senderData.profile_picture,
        }
        try {
            chatData = await Chat.findOne({_id:req.body['chat_id']})
            users = chatData.users.filter(element => element !== req.body['sender_id'])
            for(user of users){
                userData = await User.findOne({_id:user})
                if (userData.socket_id != ''){
                    io.to(userData.socket_id).emit('newMessage', [messageData, req.body['chat_id']]);
                    console.log('send')
                } else {
                    console.log(`$user not online to send`)
                }
            }
        } catch(e) {
            console.log(e)
        }
        res.status(200).send(messageData)
    })
    .catch(error => {
        console.error("Error sending message:", error);
        res.status(201).send()
    })
})

app.post('/get_user_profile', async (req, res) =>{
    try {console.log('get_user_profile')
    userData = await User.findOne({_id:req.body['user_id']})
    if(userData != null){
        var userProfileData = {
            'username': userData.username,
            'display_name': userData.display_name,
            'profile_picture': userData.profile_picture,
            'status': userData.status,
            'status_display': userData.status_display,
            'pronounce': userData.pronounce,
            'about_me': userData.about_me
        }
        res.status(200).send(userProfileData)
    } else {
        res.status(201).send()
    }} catch(e){
        console.log(e)
    }
})

app.post('/update_profile', async (req, res) =>{
    console.log('update_profile')
    var data = req.body
    await User.updateOne({_id:data['user_id']},{profile_picture:data['image'],
    display_name:data['display'], pronounce:data['pronounce'], about_me:data['about']})
    .then(async ()=>{
        updatedUser = await User.findOne({_id:data['user_id']})
        updateFriends(data['user_id'])
        res.status(200).send(updatedUser)
    })
    .catch(error =>{
        console.log(error)
        res.status(201).send()
    })
})

app.post('/update_status_display', async (req, res) =>{
    console.log('update_status_display')
    await User.updateOne({_id:req.body['user_id']},{status_display:req.body['status_display']})
    .then(async ()=>{
        await updateFriends(req.body['user_id'])
        res.status(200).send()
    })
    .catch(error =>{
        console.log(error)
        res.status(201).send()
    })
})

async function updateFriends(userId){
    try {userFriends = await Friend.findOne({user:userId})
    friends = userFriends.friends
    for(user of friends){
        userData = await User.findOne({_id:user})
        if (userData.socket_id != ''){
            io.to(userData.socket_id).emit('updateChatsAndFriends', 1);
            console.log(`send to ${userData.socket_id}`)
        } else {
            console.log(`$user not online to send`)
        }
    }} catch(e){
        console.log(e)
    }
}