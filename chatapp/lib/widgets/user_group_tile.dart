import 'package:chatapp/widgets/status_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatapp/pages/chat_page.dart';

class UserChatTile extends StatelessWidget {
  final clientUserData;
  final otherUserData;
  final topMessage;
  final chatPageId;
  final chatType;
  final Function logPressMenu;

  UserChatTile(
      {super.key,
      required this.otherUserData,
      required this.topMessage,
      required this.chatPageId,
      required this.logPressMenu,
      required this.chatType,
      required this.clientUserData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
        onTap: () {
          Get.to(Chat(
              chatPageId: chatPageId,
              otherUserData: otherUserData,
              clientUserData: clientUserData));
        },
        onLongPress: () {
          print('Long Press');
          logPressMenu([
            otherUserData['user_id'],
            otherUserData['username'] == null
                ? 'null'
                : otherUserData['username'],
            otherUserData['picture'],
            chatType
          ]);
        },
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(otherUserData['picture'] == ""
                  ? 'assets/images/default.png'
                  : otherUserData['picture']),
              radius: 25,
              backgroundColor: Colors.transparent,
            ),
            Positioned(
              bottom: -1,
              right: -1,
              child: StatusIcon(
                icon_type: otherUserData['status_display'] == '' &&
                        otherUserData['status'] != 'Online'
                    ? otherUserData['status']
                    : otherUserData['status_display'],
              ),
            ),
          ],
        ),
        title: Text(
          otherUserData['display'],
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF)),
        ),
        subtitle: Text(
          topMessage,
          style: TextStyle(fontSize: 14, color: Color(0xB0FFFFFF)),
        ),
      ),
    );
  }
}
