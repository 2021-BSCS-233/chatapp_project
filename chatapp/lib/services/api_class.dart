import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

var baseurl = 'http://192.168.10.5:2000/';

signInUser(Map data) async {
  var url = Uri.parse('${baseurl}signin_user');
  print('singin data $data');
  var response = await http.post(url, body: data);
  debugPrint("response ${response.body}");
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      debugPrint("data ${response.body}");
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

logInUser(Map data) async {
  var url = Uri.parse('${baseurl}login_user');
  // print('login data $data');
  var response = await http.post(url, body: data);
  // print('response ${response.body}');
  try {
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // debugPrint("data ${response.body}");
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
      // var data = jsonDecode(response.body);
      // debugPrint("data ${response.body}");
      // print('sent');
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
      // debugPrint("data ${response.body}");
      // print('retried $data');
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
      // debugPrint("data ${response.body}");
      // print('retried $data');
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
      // var data = jsonDecode(response.body);
      // debugPrint("data ${response.body}");
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
      // debugPrint("data ${response.body}");
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
      // debugPrint("data ${response.body}");
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
      // debugPrint("data ${response.body}");
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
      // print('message: $data');
      // debugPrint("data ${response.body}");
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