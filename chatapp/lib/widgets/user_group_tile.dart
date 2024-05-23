import 'package:chatapp/widgets/status_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatapp/pages/chat_page.dart';

class UserChatTile extends StatelessWidget {
  final user_data;
  final top_message;
  final chat_page_id;
  final chat_type;
  final Function log_press_menu;

  UserChatTile(
      {super.key,
      required this.user_data,
      required this.top_message,
      required this.chat_page_id,
      required this.log_press_menu,
      required this.chat_type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        onTap: () {
          Get.to(Chat(chat_page_id));
        },
        onLongPress: () {
          print('Long Press');
          log_press_menu([
            user_data['user_id'],
            user_data['username'] == null ? 'null' : user_data['username'],
            user_data['picture'],
            chat_type
          ]);
        },
        dense: true,
        contentPadding: EdgeInsets.zero,
        // leading: CircleAvatar(backgroundImage: AssetImage(image), radius: 23,backgroundColor: Colors.transparent,),
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(user_data['picture']),
              radius: 25,
              backgroundColor: Colors.transparent,
            ),
            Positioned(
              bottom: -1,
              right: -1,
              child: StatusIcon(
                icon_type: user_data['status_display'] == '' && user_data['status'] != 'Online'
                    ? user_data['status']
                    : user_data['status_display'],
              ),
            ),
          ],
        ),
        title: Text(
          user_data['display'],
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF)),
        ),
        subtitle: Text(
          top_message,
          style: TextStyle(fontSize: 14, color: Color(0xB0FFFFFF)),
        ),
      ),
    );
  }
}
