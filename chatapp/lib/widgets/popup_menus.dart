import 'package:chatapp/widgets/status_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatapp/services/api_class.dart';
import 'package:chatapp/widgets/option_tile.dart';

class UserGroupPopup extends StatelessWidget {
  final List tile_content;

  UserGroupPopup({required this.tile_content});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.56,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(tile_content[2] == 'null'
                          ? 'assets/images/missing.png'
                          : tile_content[2]),
                      radius: 25,
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(
                      '@${tile_content[1]}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),
                ),
                OptionTile(
                    action: () {
                      print(
                          'Prolfie action on ${tile_content[0]}, chat ${tile_content[3]}');
                    },
                    action_icon: Icons.person,
                    action_name: 'Profile'),
                OptionTile(
                    action: () {
                      print(
                          'Close Action on ${tile_content[0]}, chat ${tile_content[3]}');
                    },
                    action_icon: Icons.remove_circle_outline,
                    action_name: 'Close DM'),
                OptionTile(
                    action: () {
                      print(
                          'MAR action on ${tile_content[0]}, chat ${tile_content[3]}');
                    },
                    action_icon: CupertinoIcons.eye,
                    action_name: 'Mark As Read'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessagePopup extends StatelessWidget {
  // final List chat_content;
  final messageSelected;

  MessagePopup({required this.messageSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.56,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  OptionTile(
                      action: () {
                        print('Prolfie action on ${messageSelected}');
                      },
                      action_icon: Icons.edit,
                      action_name: 'Edit Message'),
                  OptionTile(
                      action: () {
                        print('Close Action on ${messageSelected}');
                      },
                      action_icon: Icons.copy,
                      action_name: 'Copy Text'),
                  OptionTile(
                      action: () {
                        print('MAR action on ${messageSelected}');
                      },
                      action_icon: CupertinoIcons.delete,
                      action_name: 'Delete Message'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

var userProflieData = null;
class ProfilePopup extends StatelessWidget {
  final selectedUser;

  ProfilePopup({required this.selectedUser});

  @override // don't need future builder for now
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _buildContent(context), // Replace with your async function call
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}"); // Handle error
        }
        // Show a loading indicator while waiting
        return Container(
            height: MediaQuery.of(context).size.height * 0.65,
            child: CircularProgressIndicator());
      },
    );
  }

  Future<Widget> _buildContent(BuildContext context) async {
    await getUserProfile(selectedUser);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      width: double.infinity,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Column(
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.yellow.shade700,
                              //make it adapt to the major color of profile
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25),
                                  topRight: Radius.circular(25))),
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          color: Colors.transparent,
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 10,
                      left: 20,
                      child: Stack(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 6, color: Colors.black)),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                  userProflieData['profile_picture'] ??
                                      'assets/images/missing.png'),
                              // radius: 10,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Positioned(
                            bottom: 3,
                            right: 3,
                            child: StatusIcon(
                              icon_type:
                                  userProflieData['status'] == 'Online'
                                      ? userProflieData['status_display']
                                      : userProflieData['status']  ?? 'Offline',
                              icon_size: 24,
                              icon_border: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 130,
                  decoration: BoxDecoration(
                      color: Color(0xFF121218),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProflieData['display_name'] ?? 'User Error',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        userProflieData['username'] ?? 'Failed to user data',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        userProflieData['pronounce'] ?? 'Try again later',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  alignment: Alignment.centerLeft,
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Color(0xFF121218),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Me',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        userProflieData['about_me'] ?? '',
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey.shade300),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatusPopup extends StatelessWidget {
  const StatusPopup({super.key});

  @override
  Widget build(BuildContext context) {
    var selectedValue = 1.obs;
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      width: double.infinity,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: Column(
                children: [
                  Text(
                    'Change Online Status',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Online Status',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    // height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xFF121218),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Obx(() => Column(
                          children: [
                            ListTile(
                              leading: StatusIcon(icon_type: 'Online'),
                              title: Text('Online'),
                              trailing: Radio(
                                  value: 1,
                                  groupValue: selectedValue.value,
                                  onChanged: (value) {
                                    selectedValue.value = value as int;
                                  }),
                            ),
                            ListTile(
                              leading: StatusIcon(icon_type: 'DND'),
                              title: Text('Do Not Disturb'),
                              trailing: Radio(
                                  value: 2,
                                  groupValue: selectedValue.value,
                                  onChanged: (value) {
                                    selectedValue.value = value as int;
                                  }),
                            ),
                            ListTile(
                              leading: StatusIcon(icon_type: 'Asleep'),
                              title: Text('Idel'),
                              trailing: Radio(
                                  value: 3,
                                  groupValue: selectedValue.value,
                                  onChanged: (value) {
                                    selectedValue.value = value as int;
                                  }),
                            ),
                            ListTile(
                              leading: StatusIcon(icon_type: 'Offline'),
                              title: Text('Hidden'),
                              trailing: Radio(
                                  value: 4,
                                  groupValue: selectedValue.value,
                                  onChanged: (value) {
                                    selectedValue.value = value as int;
                                  }),
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

getUserProfile(userId) async {
  Map data = {'user_id': userId};
  var response = await getUserProfilePerform(data);
  if (response != 0) {
    userProflieData = response;
  } else {
    userProflieData = null;
  }
}
