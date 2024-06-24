import 'package:chatapp/widgets/message_tile.dart';
import 'package:chatapp/widgets/popup_menus.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/widgets/input_field.dart';
import 'package:chatapp/widgets/status_icons.dart';
import 'package:get/get.dart';
import 'dart:core';
import 'package:chatapp/services/api_class.dart';

List chatContent = [];
var lastSender = '';
var update = 0.obs;
bool initial = true;
var chatPageIdGlobal = '';

class Chat extends StatelessWidget {
  final String chatPageId;
  final clientUserData;
  final otherUserData;

  Chat(
      {super.key,
      required this.chatPageId,
      required this.otherUserData,
      required this.clientUserData}) {
    initial = true;
    chatPageIdGlobal = chatPageId;
  }

  int messageSelected = 0;
  var showMenu = false.obs;

  void toggleMenu(int index) {
    if (index != -1) {
      messageSelected = index;
    }
    showMenu.value = true;
  }

  var showProfile = false.obs;

  void toggleProfile(int index) {
    if (index != -1) {
      messageSelected = index;
    }
    showProfile.value = !showProfile.value;
  }

  TextEditingController chat_controller = TextEditingController();
  var field_check = false.obs;

  void changing() {
    field_check.value = (chat_controller.text != '' ? true : false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(otherUserData['picture']),
                      radius: 17,
                      backgroundColor: Colors.transparent,
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: StatusIcon(
                        icon_type: otherUserData['status'] == 'Online'
                            ? otherUserData['status_display']
                            : otherUserData['status'],
                        icon_size: 16.0,
                        icon_border: 3,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  otherUserData['display'],
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FutureBuilder<Widget>(
                  future: gettingChats(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else if (snapshot.hasError) {
                      return Material(
                          color: Colors.transparent,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("We could not access our services"),
                                Text("Check your connection or try again later")
                              ],
                            ),
                          ));
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: TextButton(
                        onPressed: () {
                          print(field_check.value);
                        },
                        child: Icon(
                          Icons.add,
                          size: 30,
                        ),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InputField(
                        field_label: 'Message @${otherUserData['display']}',
                        controller: chat_controller,
                        sufix_icon: Icons.emoji_emotions,
                        field_color: Color(0xFF151515),
                        on_change: changing,
                        maxLines: 4,
                      ),
                    ),
                    Obx(() => Visibility(
                          visible: field_check.value,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent.shade700),
                            width: 40,
                            height: 40,
                            child: TextButton(
                              child: Icon(
                                Icons.send,
                                size: 25,
                              ),
                              onPressed: () {
                                field_check.value = false;
                                sendMessage(chatPageId, chat_controller.text,
                                    clientUserData);
                                chat_controller.text = '';
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0),
                                ),
                              ),
                            ),
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: showMenu.value || showProfile.value,
              child: GestureDetector(
                onTap: () {
                  showMenu.value = false;
                  showProfile.value = false;
                },
                child: Container(
                  color: Color(0xCA1D1D1F),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                ),
              ),
            )),
        Obx(() => AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom:
                  showMenu.value ? 0.0 : -MediaQuery.of(context).size.height,
              left: 0.0,
              right: 0.0,
              child: chatContent.length > 1
                  ? MessagePopup(
                      messageSelected: chatContent[messageSelected],
                      deleteMessage: chatContent[messageSelected]['user_id'] ==
                              clientUserData['_id']
                          ? () {}
                          : null,
                    )
                  : Container(),
            )),
        Obx(() => AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom:
                  showProfile.value ? 0.0 : -MediaQuery.of(context).size.height,
              left: 0.0,
              right: 0.0,
              child: chatContent.length > 1
                  ? ProfilePopup(
                      selectedUser: chatContent[messageSelected]['user_id'])
                  : Container(),
            )),
      ],
    );
  }

  Future<Widget> gettingChats() async {
    initial ? await getMessages(chatPageId) : null;
    return Obx(
      () => update.value == update.value && chatContent.length < 1
          ? Center(child: Text('No Chats Found, Start Chatting'))
          : Expanded(
              child: ListView.builder(
                itemCount: chatContent.length,
                shrinkWrap: true,
                reverse: true,
                itemBuilder: (context, index) {
                  try {
                    if (chatContent[chatContent.length - 1 - index]
                            ['user_id'] !=
                        chatContent[chatContent.length - 2 - index]
                            ['user_id']) {
                      return MessageTileFull(
                        profile_pic: chatContent[chatContent.length - 1 - index]
                            ['picture'],
                        display: chatContent[chatContent.length - 1 - index]
                            ['display'],
                        chat_message:
                            chatContent[chatContent.length - 1 - index]
                                ['message'],
                        chat_time: chatContent[chatContent.length - 1 - index]
                            ['time_stamp'],
                        color: chatContent[chatContent.length - 1 - index]
                            ['color'],
                        toggleMenu: () {
                          toggleMenu(chatContent.length - 1 - index);
                        },
                        toggleProfile: () {
                          toggleProfile(chatContent.length - 1 - index);
                        },
                      );
                    } else {
                      bool select = true;
                      List<String> time1 =
                          ((chatContent[chatContent.length - 1 - index]
                                      ['time_stamp'])
                                  .split(' '))[1]
                              .split(':');
                      List<String> time2 =
                          ((chatContent[chatContent.length - 2 - index]
                                      ['time_stamp'])
                                  .split(' '))[1]
                              .split(':');
                      try {
                        int time1N =
                            int.parse(time1[0]) * 60 + int.parse(time1[1]);
                        int time2N =
                            int.parse(time2[0]) * 60 + int.parse(time2[1]);
                        if ((time1N - time2N) > 10 || (time1N - time2N) < -10) {
                          select = false;
                        } else {
                          select = true;
                        }
                      } catch (e) {
                        select = true;
                      }
                      if (select) {
                        return MessageTileCompact(
                            chat_message:
                                chatContent[chatContent.length - 1 - index]
                                    ['message'],
                            chat_time:
                                chatContent[chatContent.length - 1 - index]
                                    ['time_stamp'],
                            color: chatContent[chatContent.length - 1 - index]
                                ['color'],
                            toggleMenu: () {
                              toggleMenu(chatContent.length - 1 - index);
                            });
                      } else {
                        return MessageTileFull(
                          profile_pic:
                              chatContent[chatContent.length - 1 - index]
                                  ['picture'],
                          display: chatContent[chatContent.length - 1 - index]
                              ['display'],
                          chat_message:
                              chatContent[chatContent.length - 1 - index]
                                  ['message'],
                          chat_time: chatContent[chatContent.length - 1 - index]
                              ['time_stamp'],
                          color: chatContent[chatContent.length - 1 - index]
                              ['color'],
                          toggleMenu: () {
                            toggleMenu(chatContent.length - 1 - index);
                          },
                          toggleProfile: () {
                            toggleProfile(chatContent.length - 1 - index);
                          },
                        );
                      }
                    }
                  } catch (e) {
                    return MessageTileFull(
                      profile_pic: chatContent[chatContent.length - 1 - index]
                          ['picture'],
                      display: chatContent[chatContent.length - 1 - index]
                          ['display'],
                      chat_message: chatContent[chatContent.length - 1 - index]
                          ['message'],
                      chat_time: chatContent[chatContent.length - 1 - index]
                          ['time_stamp'],
                      color: chatContent[chatContent.length - 1 - index]
                          ['color'],
                      toggleMenu: () {
                        toggleMenu(chatContent.length - 1 - index);
                      },
                      toggleProfile: () {
                        toggleProfile(chatContent.length - 1 - index);
                      },
                    );
                  }
                },
              ),
            ),
    );
  }
}

getMessages(chatID) async {
  Map data = {'chat_id': chatID};
  var response = await getMessagesPerform(data);
  if (response != 0) {
    chatContent = response;
    initial = false;
  } else {
    chatContent = [];
  }
}

sendMessage(chatID, message, clientUserData) async {
  Map data = {
    'chat_id': chatID,
    'sender_id': clientUserData['_id'],
    'message': message,
    'time': (DateTime.now()).toString()
  };
  int chatIndex = chatContent.length;
  chatContent.add({
    'message_id': '',
    'message': message,
    'time_stamp': data['time'],
    'user_id': clientUserData['_id'],
    'display': clientUserData['display_name'],
    'picture': clientUserData['profile_picture'],
    'color': Color(0xFF666666)
  });
  update.value += 1;
  var response = await sendMessagePerform(data);
  if (response != false) {
    chatContent[chatIndex]['message_id'] = response['message_id'];
    chatContent[chatIndex]['color'] = null;
    update.value += 1;
    print('$response update ${update.value}');
    print(chatContent[chatIndex]);
  } else {
    chatContent[chatIndex]['color'] = Colors.red;
    update.value += 1;
    print(response);
  }
}

receiveMessage(messageData) {
  try {
    if (chatContent[-1]['message_id'] != messageData['message_id']) {
      chatContent.add({
        'message_id': messageData['message_id'],
        'message': messageData['message'],
        'time_stamp': messageData['time_stamp'],
        'user_id': messageData['user_id'],
        'display': messageData['display'],
        'picture': messageData['picture']
      });
    }
  } catch (e) {
    chatContent.add({
      'message_id': messageData['message_id'],
      'message': messageData['message'],
      'time_stamp': messageData['time_stamp'],
      'user_id': messageData['user_id'],
      'display': messageData['display'],
      'picture': messageData['picture']
    });
  }
  update.value += 1;
}
