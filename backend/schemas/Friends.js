const mongoose = require('mongoose');

const friendSchema = new mongoose.Schema({
    user:{
        type: String,
        require: true,
        unique: true
    },
    friends:{
        type: [String],
        default: []
    }

    // Add more fields here as needed
    // ...
  });

  module.exports = mongoose.model('Friend', friendSchema);