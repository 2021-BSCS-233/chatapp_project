import 'package:flutter/cupertino.dart';
import 'package:chatapp/widgets/status_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatelessWidget {
  final Map userData;
  final Function toggleMenu;

  Profile({required this.toggleMenu, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      color: Colors.yellow
                          .shade700, //make it adapt to the major color of profile
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.transparent,
                    )
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: Stack(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(width: 6)),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              userData['profile_picture'] == ''
                                  ? 'assets/images/missing.png'
                                  : userData['profile_picture']),
                          // radius: 10,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Positioned(
                        bottom: 3,
                        right: 3,
                        child: StatusIcon(
                          icon_type: userData['status_display'] != ''
                              ? userData['status_display']
                              : 'Online',
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
              height: 168,
              decoration: BoxDecoration(
                  color: Color(0xFF121218),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData['display_name'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    userData['username'],
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    userData['pronounce'],
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            print('Editing status');
                            toggleMenu(['null', 'null', 'null', 'null']);
                          },
                          child: Container(
                              height: 38,
                              width: 140,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent.shade400,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    CupertinoIcons.chat_bubble_fill,
                                    size: 20,
                                  ),
                                  Text(
                                    'Edit Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              )),
                        ),
                        InkWell(
                          onTap: () {
                            print('Editing Profile');
                          },
                          child: Container(
                            height: 38,
                            width: 140,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade400,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                                Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
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
                    '''${userData['about_me']}''',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade300),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
