const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
    chat_id:{
        type: String,
        require: true,
    },
    sender_id:{
        type: String,
        require: true,
    },
    message:{
        type: String,
        require: true,
    },
    time_stamp:{
        type: String,
        require: true,
    }
})

module.exports = mongoose.model('Message',messageSchema);