import 'package:chatapp/widgets/message_tile.dart';
import 'package:chatapp/widgets/popup_menus.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/widgets/input_field.dart';
import 'package:chatapp/widgets/status_icons.dart';
import 'package:chatapp/services/custom_datatypes.dart';
import 'package:get/get.dart';
import 'dart:core';

var temp =
    '''Exposure is simply being introduced to something new.  It's like seeing a travel brochure about a new country. You learn some basic facts and get a general sense of what it's like, but you haven't actually been there.''';

class Chat extends StatelessWidget {
  final chat_page_id;
  final List<MessageData> chat_content = [];

  Chat(this.chat_page_id);

  @override
  Widget build(BuildContext context) {
    int message_selected = 0;
    var showMenu = false.obs;
    void toggleMenu(int index) {
      if (index != -1) {
        message_selected = index;
      }
      showMenu.value = !showMenu.value;
      // print('toggled ${showMenu.value}, chat selected $message_selected');
    }

    var showProfile = false.obs;
    void toggleProfile(int index) {
      if (index != -1) {
        message_selected = index;
      }
      showProfile.value = !showProfile.value;
      // print('toggled ${showProfile.value}, chat selected $message_selected');
    }



    var count = chat_content.length.obs;
    TextEditingController chat_controller = TextEditingController();
    var field_check = false.obs;
    void changing() {
      field_check.value = (chat_controller.text != '' ? true : false);
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            // leading: CircleAvatar(backgroundImage: AssetImage('assets/temp2.png'), radius: 15, backgroundColor: Colors.transparent,),
            title: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/temp1.jpg'),
                      radius: 17,
                      backgroundColor: Colors.transparent,
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: StatusIcon(icon_type: 'Online',icon_size: 16.0,icon_border: 3,),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  chat_page_id,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )
              ],
            ),
            actions: [
              Icon(Icons.call),
              SizedBox(
                width: 30,
              ),
              Icon(Icons.video_camera_front),
              SizedBox(
                width: 10,
              )
            ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7),
                    child: Obx(() => ListView.builder(
                          itemCount: count.value,
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return MessageTile(
                                profile_pic: chat_content[chat_content.length-1-index].profile,
                                username: chat_content[chat_content.length-1-index].username,
                                chat_message: chat_content[chat_content.length-1-index].message,
                                chat_time: chat_content[chat_content.length-1-index].time_stamp,
                                toggleMenu: () {toggleMenu(chat_content.length-1-index);},
                                toggleProfile: (){toggleProfile(chat_content.length-1-index);},);
                          },
                        )),
                  ),
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
                                count++;
                                chat_content.add(MessageData(
                                    profile: 'assets/images/temp1.jpg',
                                    username: 'Lunatic',
                                    message: chat_controller.text,
                                    time_stamp: '${DateTime.timestamp()}'));
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
              showMenu.value ? toggleMenu(-1) : showProfile.value ? toggleProfile(-1) : null;
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
          child: MessagePopup(chat_content: chat_content,message_selected: message_selected,),
        )),
        Obx(() => AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          bottom:
          showProfile.value ? 0.0 : -MediaQuery.of(context).size.height,
          left: 0.0,
          right: 0.0,
          child: ProfilePopup(message_selected: message_selected,),
        )),
      ],
    );
  }
}
