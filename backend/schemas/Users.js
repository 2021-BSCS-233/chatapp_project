const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true,
  },
  display_name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  profile_picture: {
    type: String,
    default: 'assets/images/default.png'
  },
  status: {
    type: String,
    default: 'Offline'
  },
  status_display: {
    type: String,
    default: ''
  },
  pronounce: {
    type: String,
    default: ''
  },
  about_me: {
    type: String,
    default: ''
  },


  // Add more fields here as needed
  // ...
});

module.exports = mongoose.model('User', userSchema);