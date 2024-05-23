const mongoose = require('mongoose');

const requestSchema = new mongoose.Schema({
    sender_id:{
        type: String,
        require: true,
    },
    receiver_id:{
        type: String,
        require: true
    },
    status:{
        type: String,
        default: 'pending'
    }
    // Add more fields here as needed
    // ...
});

module.exports = mongoose.model('Request', requestSchema);