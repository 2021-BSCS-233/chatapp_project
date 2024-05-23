import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String profile_pic;
  final String username;
  final String chat_message;
  final String chat_time;
  final Function toggleMenu;
  final Function toggleProfile;

  MessageTile(
      {required this.profile_pic,
      required this.username,
      required this.chat_message,
      required this.chat_time,
      required this.toggleMenu,
      required this.toggleProfile});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        print('working');
        toggleMenu();
      },
      titleAlignment: ListTileTitleAlignment.top,
      leading: InkWell(
        onTap: () {
          toggleProfile();
          print('profile');
        },
        child: CircleAvatar(
          backgroundImage: AssetImage(profile_pic),
          radius: 21,
          backgroundColor: Colors.transparent,
        ),
      ),
      // title: Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // children: [
      title: Row(
        children: [
          InkWell(
            onTap: () {
              print('name');
            },
            child: Text(
              username,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            chat_time,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      subtitle: Text(chat_message),
      //   ],
      // )
      // ],
    );
  }
}
