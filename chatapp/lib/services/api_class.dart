import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/pages/chats_page.dart';
import 'package:chatapp/pages/requests_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart';

var baseurl = 'http://192.168.181.28:3000/';
var socket1 = null;

void connectSocket(userId) async {
  Socket socket;
  try {
    socket = io('$baseurl', <String, dynamic>{
      'transports': ['websocket'],
    });
    socket.connect();
    @override
    void dispose() {
      socket.disconnect();
      socket.dispose();
    }

    socket.onConnect((_) {
      socket1 = socket;
      socket.emit('save_socket_id', {'userId': userId, 'socketId': socket.id});
      print('Connection established ${socket.id}');
    });
    socket.onDisconnect((_) {
      print('Connection Disconnection');
      dispose();
    });
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));

    socket.on('newMessage', (data) {
      if (chatPageIdGlobal == data[1]) {
        receiveMessage(data[0]);
      } else {
        //TODO: add ping mechanic
        print('ping');
      }
    });
    socket.on('updateChatsAndFriends', (data) {
      getChatsData(userId);
    });
    socket.on('updateRequests', (data) async {
      await getRequestsData(userId);
      if (data == 1) {
        getFriends(userId);
        getChatsData(userId);
      }
    });
  } catch (e) {
    print(e);
  }
}

void logOutDisconnect(userId) {
  if (socket1 != null) {
    socket1.emit('close_socket_id', {'userId': userId});
    socket1.disconnect();
    socket1.dispose();
  }
}

sendSignInPerform(Map data) async {
  var url = Uri.parse('${baseurl}signin_user');
  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('user created');
      return data;
    } else if (response.statusCode == 201) {
      print('username or email already in use');
      return 0;
    }
  } catch (e) {
    print('catch');
    debugPrint('error in post data $e');
    return 0;
  }
}

sendLogInPerform(Map data) async {
  var url = Uri.parse('${baseurl}login_user');
  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 201) {
      print('wrong password');
      return 0;
    } else if (response.statusCode == 202) {
      print('email not found');
      return 0;
    } else {
      print('communication error');
      return 0;
    }
  } catch (e) {
    print('catch1');
    debugPrint('error in post data $e');
    return 0;
  }
}

sendRequestPerform(Map data) async {
  var url = Uri.parse('${baseurl}add_request');

  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 201) {
      print('user doesnt exist');
      return 0;
    } else if (response.statusCode == 202) {
      print('already a friend');
      return 0;
    } else if (response.statusCode == 203) {
      print('request already sent');
      return 0;
    } else {
      print('communication error');
      return 0;
    }
  } catch (e) {
    print('catch2');
    debugPrint('error in post data $e');
    return 0;
  }
}

getIncomingRequestsPerform(Map data) async {
  var url = Uri.parse('${baseurl}get_incoming_requests');

  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 201) {
      print('no requests found');
      return 0;
    } else {
      print('connection error');
      return 0;
    }
  } catch (e) {
    print('catch3');
    debugPrint('error in post data $e');
    return 0;
  }
}

getOutgoingRequestsPerform(Map data) async {
  var url = Uri.parse('${baseurl}get_outgoing_requests');

  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 201) {
      print('no requests found');
      return 0;
    } else {
      print('connection error');
      return 0;
    }
  } catch (e) {
    print('catch3');
    debugPrint('error in post data $e');
    return 0;
  }
}

requestActionPerform(Map data) async {
  var url = Uri.parse('${baseurl}request_action');

  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      print('action successful');
      return true;
    } else if (response.statusCode == 201) {
      print('request not found');
      return 0;
    } else if (response.statusCode == 202) {
      print('action denied');
      return 0;
    } else {
      print('connection error');
      return 0;
    }
  } catch (e) {
    print('catch4');
    debugPrint('error in post data $e');
    return 0;
  }
}

getChatsPerform(Map data) async {
  var url = Uri.parse('${baseurl}get_chats');
  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('chats obtained');
      return data;
    } else if (response.statusCode == 201) {
      print('no chats found');
      return 0;
    } else {
      print('connection error');
      return 0;
    }
  } catch (e) {
    print('catch4');
    debugPrint('error in post data $e');
    return 0;
  }
}

getFriendsPerform(Map data) async {
  var url = Uri.parse('${baseurl}get_friends');
  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('friends obtained');
      return data;
    } else if (response.statusCode == 201) {
      print('no friends found');
      return 0;
    } else {
      print('connection error');
      return 0;
    }
  } catch (e) {
    print('catch5');
    debugPrint('error in post data $e');
    return 0;
  }
}

getMessagesPerform(Map data) async {
  var url = Uri.parse('${baseurl}get_chat');
  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('chat obtained');
      return data;
    } else if (response.statusCode == 201) {
      print('chat not found');
      return 0;
    } else if (response.statusCode == 300) {
      print('Error on server end');
      return 0;
    } else {
      print('connection error');
      return 0;
    }
  } catch (e) {
    print('catch6');
    debugPrint('error in post data $e');
    return 0;
  }
}

sendMessagePerform(Map data) async {
  var url = Uri.parse('${baseurl}send_message');
  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print('message send');
      return data;
    } else if (response.statusCode == 201) {
      print('message not send');
      return false;
    } else {
      print('connection error');
      return false;
    }
  } catch (e) {
    print('catch7');
    debugPrint('error in post data $e');
    return false;
  }
}

getUserProfilePerform(Map data) async {
  var url = Uri.parse('${baseurl}get_user_profile');
  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 201) {
      print('user not found');
      return 0;
    } else {
      print('connection error');
      return 0;
    }
  } catch (e) {
    print('catch8');
    debugPrint('error in post data $e');
    return 0;
  }
}

updateProfilePerform(Map data) async {
  var url = Uri.parse('${baseurl}update_profile');
  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else if (response.statusCode == 201) {
      print('data not saved');
      return 0;
    } else {
      print('connection error');
      return 0;
    }
  } catch (e) {
    print('catch9');
    debugPrint('error in post data $e');
    return false;
  }
}

updateStatusDisplayPerform(Map data) async {
  var url = Uri.parse('${baseurl}update_status_display');
  var response = await http.post(url, body: data);
  try {
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 201) {
      print('data not saved');
      return false;
    } else {
      print('connection error');
      return false;
    }
  } catch (e) {
    print('catch10');
    debugPrint('error in post data $e');
    return false;
  }
}

// updateAccountPerform(Map data) async{
//   var url = Uri.parse('${baseurl}update_account');
// }
