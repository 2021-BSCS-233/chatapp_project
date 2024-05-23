const mongoose = require('mongoose')
const { MongoClient, ServerApiVersion } = require('mongodb')
const User = require('./schemas/Users')
const Request = require('./schemas/Requests')
const Chat = require('./schemas/Chats')
const Message = require('./schemas/Messages')
const Friend = require('./schemas/Friends')
const express = require("express")
const app = express();
const port = 2000;

const uri = "mongodb+srv://nehalmahdi9:kMCqPPv0VH5hjRA5@chatapp.1hgjo7w.mongodb.net/chatapp_data?retryWrites=true&w=majority&appName=chatapp"

mongoose.connect(uri)
    .then(() => console.log("Connected to MongoDB"))
    .catch(error => console.error("Error connecting to MongoDB:", error));

process.on('SIGINT', async () => {
    await mongoose.connection.close();
    if (mongoose.connection.readyState === 0) {
        console.log('Connection successfully closed');
      } else {
        console.error('Connection may not have closed properly');
      }
    process.exit(0);
});

//process.on('unhandledRejection', (error) => {
//  console.error('Unhandled promise rejection:', error);
//  // Implement some recovery logic or logging here (optional)
//  process.exit(1); // Exit with an error code
//});
//
//process.on('exit', async () => {
//  try {
//    await mongoose.connection.close();
//    console.log("Mongoose connection closed");
//    await new Promise(resolve => setTimeout(resolve, 100)); // Short timeout
//  } catch (error) {
//    console.error("Error closing Mongoose connection:", error);
//  } finally {
//    process.exit(0);
//  }
//});


// var database
// // Create a MongoClient with a MongoClientOptions object to set the Stable API version
// const client = new MongoClient(uri, {
//   serverApi: {
//     version: ServerApiVersion.v1,
//     strict: true,
//     deprecationErrors: true,
//   }
// });
// async function run() {
//   try {
//     // Connect the client to the server	(optional starting in v4.7)
//     await client.connect();
//     // Send a ping to confirm a successful connection
//     const database = await client.db("chatapp_data")
//     console.log("Pinged your deployment. You successfully connected to MongoDB!")
//     const collection = database.collection("Users")
//     console.log("collection:"+collection)
//   } finally {
//     // Ensures that the client will close when you finish/error
//     await client.close();
//     console.log('connection closed')
//   }
// }
// run().catch(console.dir)


app.use(express.json())
app.use(express.urlencoded({
    extended: true,
}));

app.listen(port, () => {
    console.log(`connected to http://localhost:${port}`)
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
            password: req.body['password'], // Make sure to hash the password before saving
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
    console.log('userdata', userData)
    if(userData != null){
        if(userData['password'] == req.body['password']){
            console.log('accepted')
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
            res.status(200).send()
        } else if (req.body['action'] == 'accept'){
            await Request.deleteOne({_id: req.body['request_id']})
            await Friend.updateOne({user:requestCheck.sender_id},{$push:{friends:requestCheck.receiver_id}})
            await Friend.updateOne({user:requestCheck.receiver_id},{$push:{friends:requestCheck.sender_id}})
            const newChat = new Chat ({
                users: [[requestCheck.sender_id, true, false],[requestCheck.receiver_id, true, false]]
            })
            newChat.save()
                .then(async () => {
                    console.log("User created successfully!")
                    res.status(200).send()
                })
                .catch(error => console.error("Error creating user:", error));
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
    console.log('get_friends')
    friendsData = await Friend.findOne({user: req.body['user_id']})
    if (friendsData != null && friendsData.friends != []){
        var friendsPresentData = []
        for (friend of friendsData.friends){
            userData = await User.findOne({_id: friend})
            chatData = await Chat.findOne({$or:[{users: [req.body['user_id'],friend]},{users: [friend,req.body['user_id']]}]})
            friendsPresentData.push({
                'friend_id': userData._id,
                'friend_display': userData.display_name,
                'status': userData.status,
                'display_status': userData.status_display,
                'picture': userData.profile_picture,
                'chat_id': chatData._id,
            })
        }
        res.status(200).send(friendsPresentData)
    } else {
        res.status(201).send()
    }
})