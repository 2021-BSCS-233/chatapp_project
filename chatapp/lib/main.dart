import 'package:chatapp/pages/login_signin_page.dart';
import 'package:chatapp/services/custom_datatypes.dart';
import 'package:chatapp/widgets/popup_menus.dart';
import 'package:chatapp/widgets/status_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/pages/chats_page.dart';
import 'package:chatapp/pages/notification_page.dart';
import 'package:chatapp/pages/friends_page.dart';
import 'package:chatapp/pages/profile_page.dart';

void main() {
  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.copyWith(
              bodyLarge: TextStyle(fontFamily: 'gg_sans'),
              bodyMedium: TextStyle(fontFamily: 'gg_sans'),
              bodySmall: TextStyle(fontFamily: 'gg_sans'),
            ),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(fontFamily: 'gg_sans'),
            toolbarTextStyle: TextStyle(fontFamily: 'gg_sans')),
        scaffoldBackgroundColor: Colors.black,
      ),
      getPages: [],
      home: Signin()));
}

// bool login_check() {
//   // login check functionality
//
//   return false;
// }
var selected_index = 0.obs;
var selectedUsername = '';
var selectedUserId = '';
var selectedUserPic = '';
var selectedChatType = '';

var showMenu = false.obs;
void toggleMenu(dataList) {
  selectedUserId = dataList[0];
  selectedUsername = dataList[1];
  selectedUserPic = dataList[2];
  selectedChatType = dataList[3];

  showMenu.value = !showMenu.value;
}

class Home extends StatelessWidget {
  final Map clientUserData;

  Home({super.key, required this.clientUserData}){
    initialM = true;
    initialF = true;
  }

  @override
  Widget build(BuildContext context) {

    List pages = [
      Chats(
        toggleMenu: toggleMenu,
        clientUserData: clientUserData,
      ),
      const Notifications(),
      Friends(
        clientUserData: clientUserData,
      ),
      Profile(
        clientUserData: clientUserData,
        toggleMenu: toggleMenu,
      )
    ];

    return Stack(
      children: [
        Column(
          children: [
            Obx(() => Expanded(child: pages[selected_index.value])),
            Obx(() => BottomNavigationBar(
                  currentIndex: selected_index.value,
                  onTap: (index) {
                    selected_index.value = index;
                  },
                  unselectedFontSize: 10,
                  selectedFontSize: 10,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.grey,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.chat_bubble_2_fill),
                        label: 'Messages'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.notifications),
                        label: 'Notifications'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.people), label: 'Friends'),
                    BottomNavigationBarItem(
                        icon: Container(
                          // margin: EdgeInsets.symmetric(vertical: 2),
                          height: 26,
                          width: 32,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                    clientUserData['profile_picture'] == ''
                                        ? 'assets/images/missing.png'
                                        : clientUserData['profile_picture']),
                                radius: 11.5,
                                backgroundColor: Colors.transparent,
                              ),
                              Positioned(
                                bottom: -1,
                                right: -1,
                                child: StatusIcon(
                                    icon_type: clientUserData['status_display'] != ''
                                        ? clientUserData['status_display']
                                        : 'Online'),
                              ),
                            ],
                          ),
                        ),
                        label: 'Profile'),
                  ],
                )),
          ],
        ),
        Obx(() => Visibility(
              visible: showMenu.value,
              child: GestureDetector(
                onTap: () {
                  toggleMenu(['', '', '', '']);
                },
                child: Container(
                  color: Color(0xC01D1D1F),
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
              child: selected_index.value == 0
                  ? UserGroupPopup(
                      tile_content: [
                        selectedUserId,
                        selectedUsername,
                        selectedUserPic,
                        selectedChatType
                      ],
                    )
                  : selected_index.value == 3
                      ? StatusPopup()
                      : Container(),
            ))
      ],
    );
  }
}
//Done: Main Ui(messages page, friends page, chats page, profile page) (took 4 days, stuff kept breaking),
//  Learn Getx (still not fully learnt),
//  Spend a whole day figuring out connection problems cuz i am using physical device to testing
//  Option to make account, Option to login, Option to send friend request, Option to view request
//  Option to accept/deny request, Option to see friends, Option to see their chats
//  Option to see who is online
//TODO: make settings page
//TODO: add option to change account into
//TODO: make chat work
//TODO: finally learn sockets