import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageTileFull extends StatelessWidget {
  final String profile_pic;
  final String display;
  final String chat_message;
  final String chat_time;
  final Color? color;
  final Function toggleMenu;
  final Function toggleProfile;

  MessageTileFull(
      {required this.profile_pic,
      required this.display,
      required this.chat_message,
      required this.chat_time,
      required this.toggleMenu,
      required this.toggleProfile,
      this.color});

  @override
  Widget build(BuildContext context) {
    List<String> dateTimeValue = chat_time.split('.');
    List<String> separateDateTime = dateTimeValue[0].split(' ');
    List<String> separateDateValues = separateDateTime[0].split('-');
    List<String> separateTimeValues = separateDateTime[1].split(':');
    String formattedTime = '';
    if (int.parse(separateTimeValues[0]) > 12) {
      formattedTime = '${int.parse(separateTimeValues[0]) - 12}:${separateTimeValues[1]} PM';
    } else if (int.parse(separateTimeValues[0]) == 00) {
      formattedTime = '12:${separateTimeValues[1]} AM';
    } else {
      formattedTime = '${int.parse(separateTimeValues[0])}:${separateTimeValues[1]} AM';
    }

    return Container(
      margin: EdgeInsets.only(left: 18, top: 16, right: 18, bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              toggleProfile();
              print('profile');
            },
            child: CircleAvatar(
              backgroundImage: AssetImage(profile_pic),
              radius: 20,
              backgroundColor: Colors.transparent,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: InkWell(
              onLongPress: (){
                toggleMenu();
              },
              splashColor: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          print('name');
                        },
                        child: Text(
                          display,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        DateTime.now().toString().split(' ')[0] ==
                                dateTimeValue[0].split(' ')[0]
                            ? 'Today at $formattedTime'
                            : '${separateDateValues[2]}/${separateDateValues[1]}/${separateDateValues[0]}  $formattedTime',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    chat_message,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MessageTileCompact extends StatelessWidget {
  final String chat_message;
  final String chat_time;
  final Color? color;
  final Function toggleMenu;

  MessageTileCompact(
      {required this.chat_message,
      required this.chat_time,
      required this.toggleMenu,
      this.color});

  @override
  Widget build(BuildContext context) {
    // List<String> formattedTime = chat_time.split(' ');
    // List<String> formattedClock = formattedTime[1].split(':');

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            alignment: Alignment.centerRight,
            height: 15,
            width: 40,
            // child: Text('${formattedClock[0]}:${formattedClock[1]}',
            //   style: TextStyle(color: Colors.grey),),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: InkWell(
              onLongPress: (){
                toggleMenu();
              },
              // enableFeedback: false,
              splashColor: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat_message,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


//old formats
// return ListTile(
//   onLongPress: () {
//     print('working');
//     toggleMenu();
//   },
//   titleAlignment: ListTileTitleAlignment.top,
//   leading: InkWell(
//     onTap: () {
//       toggleProfile();
//       print('profile');
//     },
//     child: CircleAvatar(
//       backgroundImage: AssetImage(profile_pic),
//       radius: 21,
//       backgroundColor: Colors.transparent,
//     ),
//   ),
//   title: Row(
//     children: [
//       InkWell(
//         onTap: () {
//           print('name');
//         },
//         child: Text(
//           display,
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//         ),
//       ),
//       SizedBox(
//         width: 10,
//       ),
//       Text(
//         chat_time,
//         style: TextStyle(fontSize: 12, color: Colors.grey),
//       ),
//     ],
//   ),
//   subtitle: Text(chat_message,style: TextStyle(color: color),),
// );

// return Padding(
//   padding: EdgeInsets.symmetric(vertical: 0),
//   child: ListTile(
//     onLongPress: () {
//       print('working');
//       toggleMenu();
//     },
//     visualDensity: VisualDensity.compact,
//     dense: true,
//     titleAlignment: ListTileTitleAlignment.center,
//     contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
//     leading: Container(height: 1, width: 40, color: Colors.red,),
//     title: Text(chat_message,style: TextStyle(color: color, fontSize: 14,),),
//   ),
// );