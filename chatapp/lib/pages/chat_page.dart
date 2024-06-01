import 'package:chatapp/widgets/message_tile.dart';
import 'package:chatapp/widgets/popup_menus.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/widgets/input_field.dart';
import 'package:chatapp/widgets/status_icons.dart';
import 'package:get/get.dart';
import 'dart:core';
import 'package:chatapp/services/api_class.dart';

List chat_content = [];
var lastsender;
var update = 0.obs;
bool initial = true;
var chatPageIdGlobal = null;

class Chat extends StatelessWidget {
  final String chatPageId;
  final clientUserData;
  final otherUserData;

  Chat(
      {required this.chatPageId,
      required this.otherUserData,
      required this.clientUserData}) {
    initial = true;
    chatPageIdGlobal = chatPageId;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _buildContent(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  int messageSelected = 0;
  var showMenu = false.obs;

  void toggleMenu(int index) {
    if (index != -1) {
      messageSelected = index;
    }
    showMenu.value = !showMenu.value;
  }

  var showProfile = false.obs;

  void toggleProfile(int index) {
    if (index != -1) {
      messageSelected = index;
    }
    showProfile.value = !showProfile.value;
  }

  // var count = chat_content.length.obs;
  TextEditingController chat_controller = TextEditingController();
  var field_check = false.obs;

  void changing() {
    field_check.value = (chat_controller.text != '' ? true : false);
  }

  Future<Widget> _buildContent(BuildContext context) async {
    initial ? await getMessages(chatPageId) : null;
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
            // actions: [
            //   Icon(Icons.call),
            //   SizedBox(
            //     width: 30,
            //   ),
            //   Icon(Icons.video_camera_front),
            //   SizedBox(
            //     width: 10,
            //   )
            // ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => Expanded(
                    child: ListView.builder(
                      itemCount: update.value != -1
                          ? chat_content.length
                          : chat_content.length,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) {
                        try {
                          if (chat_content[chat_content.length - 1 - index]
                                  ['user_id'] !=
                              chat_content[chat_content.length - 2 - index]
                                  ['user_id']) {
                            return MessageTileFull(
                              profile_pic:
                                  chat_content[chat_content.length - 1 - index]
                                      ['picture'],
                              display:
                                  chat_content[chat_content.length - 1 - index]
                                      ['display'],
                              chat_message:
                                  chat_content[chat_content.length - 1 - index]
                                      ['message'],
                              chat_time:
                                  chat_content[chat_content.length - 1 - index]
                                      ['time_stamp'],
                              color:
                                  chat_content[chat_content.length - 1 - index]
                                      ['color'],
                              toggleMenu: () {
                                toggleMenu(chat_content.length - 1 - index);
                              },
                              toggleProfile: () {
                                toggleProfile(chat_content.length - 1 - index);
                              },
                            );
                          } else {
                            bool select = true;
                            List<String> time1 =
                                ((chat_content[chat_content.length - 1 - index]
                                            ['time_stamp'])
                                        .split(' '))[1]
                                    .split(':');
                            List<String> time2 =
                                ((chat_content[chat_content.length - 2 - index]
                                            ['time_stamp'])
                                        .split(' '))[1]
                                    .split(':');
                            try {
                              int time1N = int.parse(time1[0]) * 60 +
                                  int.parse(time1[1]);
                              int time2N = int.parse(time2[0]) * 60 +
                                  int.parse(time2[1]);
                              if ((time1N - time2N) > 10 ||
                                  (time1N - time2N) < -10) {
                                select = false;
                              } else {
                                select = true;
                              }
                            } catch (e) {
                              select = true;
                            }
                            if (select) {
                              return MessageTileCompact(
                                  chat_message: chat_content[
                                          chat_content.length - 1 - index]
                                      ['message'],
                                  chat_time: chat_content[chat_content.length -
                                      1 -
                                      index]['time_stamp'],
                                  color: chat_content[
                                      chat_content.length - 1 - index]['color'],
                                  toggleMenu: () {
                                    toggleMenu(chat_content.length - 1 - index);
                                  });
                            } else {
                              return MessageTileFull(
                                profile_pic: chat_content[
                                    chat_content.length - 1 - index]['picture'],
                                display: chat_content[
                                    chat_content.length - 1 - index]['display'],
                                chat_message: chat_content[
                                    chat_content.length - 1 - index]['message'],
                                chat_time: chat_content[chat_content.length -
                                    1 -
                                    index]['time_stamp'],
                                color: chat_content[
                                    chat_content.length - 1 - index]['color'],
                                toggleMenu: () {
                                  toggleMenu(chat_content.length - 1 - index);
                                },
                                toggleProfile: () {
                                  toggleProfile(
                                      chat_content.length - 1 - index);
                                },
                              );
                            }
                          }
                        } catch (e) {
                          return MessageTileFull(
                            profile_pic:
                                chat_content[chat_content.length - 1 - index]
                                    ['picture'],
                            display:
                                chat_content[chat_content.length - 1 - index]
                                    ['display'],
                            chat_message:
                                chat_content[chat_content.length - 1 - index]
                                    ['message'],
                            chat_time:
                                chat_content[chat_content.length - 1 - index]
                                    ['time_stamp'],
                            color: chat_content[chat_content.length - 1 - index]
                                ['color'],
                            toggleMenu: () {
                              toggleMenu(chat_content.length - 1 - index);
                            },
                            toggleProfile: () {
                              toggleProfile(chat_content.length - 1 - index);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: TextButton(
                        onPressed: () {
                          print(field_check.value);
                          logOutDisconnect(clientUserData['_id']);
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
                        field_label: 'Message Lunatic',
                        controller: chat_controller,
                        sufix_icon: Icons.emoji_emotions,
                        field_color: Color(0xFF151520),
                        on_change: changing,
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
                                // chat_content.add(MessageData(
                                //     profile: 'assets/images/temp1.jpg',
                                //     username: 'Lunatic',
                                //     message: chat_controller.text,
                                //     time_stamp: '${DateTime.timestamp()}'));
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
                  showMenu.value
                      ? toggleMenu(-1)
                      : showProfile.value
                          ? toggleProfile(-1)
                          : null;
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
              child: MessagePopup(
                  messageSelected:
                      chat_content[messageSelected]['message_id'] ?? null),
            )),
        Obx(() => AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom:
                  showProfile.value ? 0.0 : -MediaQuery.of(context).size.height,
              left: 0.0,
              right: 0.0,
              child: ProfilePopup(
                  selectedUser:
                      chat_content[messageSelected]['user_id'] ?? null),
            )),
      ],
    );
  }
}

getMessages(chatID) async {
  Map data = {'chat_id': chatID};
  var response = await getMessagesPerform(data);
  // print('chats response $response');
  if (response != 0) {
    chat_content = response;
    // CLength.value = response.length;
    initial = false;
    // return response;
  } else {
    chat_content = [];
    // CLength.value = 0;
  }
}

sendMessage(chatID, message, clientUserData) async {
  Map data = {
    'chat_id': chatID,
    'sender_id': clientUserData['_id'],
    'message': message,
    'time': (DateTime.now()).toString()
  };
  int chatIndex = chat_content.length;
  chat_content.add({
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
  // print('chats response $response');
  if (response != false) {
    chat_content[chatIndex]['message_id'] = response['message_id'];
    chat_content[chatIndex]['color'] = null;
    update.value += 1;
    print('$response update ${update.value}');
    print(chat_content[chatIndex]);
  } else {
    chat_content[chatIndex]['color'] = Colors.red;
    update.value += 1;
    print(response);
  }
}

receiveMessage(messageData) {
  chat_content.add({
    'message_id': messageData['message_id'],
    'message': messageData['message'],
    'time_stamp': messageData['time_stamp'],
    'user_id': messageData['user_id'],
    'display': messageData['display'],
    'picture': messageData['picture']
  });
  update.value += 1;
}
