const mongoose = require('mongoose');

const chatSchema = new mongoose.Schema({
    users:{
        type: [String],
        require: true,
    },
    chat_name:{
        type: String,
        default: ''
    },
    chat_visible:{
        type: [Boolean],
        require: []
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