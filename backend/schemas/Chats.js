const mongoose = require('mongoose');

const chatSchema = new mongoose.Schema({
    users:{
        type: [String],
        require: true,
    },
    latest_message:{
        type: String,
        default: ''
    },
    chat_type:{
        type: String,
        default: 'dm' // 'dm' for one to one, 'group' for multiple
    }
    // Add more fields here as needed
    // ...
});

module.exports = mongoose.model('Chat', chatSchema);