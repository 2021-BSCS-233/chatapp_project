import 'package:chatapp/pages/login_page.dart';
import 'package:chatapp/services/custom_datatypes.dart';
import 'package:chatapp/widgets/popup_menus.dart';
import 'package:chatapp/widgets/status_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/pages/messages_page.dart';
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

class Home extends StatelessWidget {
  final Map userData;

  Home({super.key, required this.userData});

  @override
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
        return CircularProgressIndicator();
      },
    );
  }

  Future<Widget> _buildContent(BuildContext context) async {
    var selected_index = 0.obs;
    // int chat_selected = 0;
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
      // print('toggled ${showMenu.value}, chat selected $chat_selected');
    }

    List<UserGroupData> tileContent = [
      UserGroupData(
          image: 'assets/images/temp1.jpg',
          username: 'Argo',
          top_message: 'it doesnt',
          chat_page_id: 'Argo',
          status: 'Online'),
      UserGroupData(
          image: 'assets/images/temp2.png',
          username: 'Dany',
          top_message: 'Alright see you then',
          chat_page_id: 'Dany',
          status: 'Offline'),
      UserGroupData(
          image: 'assets/images/temp3.png',
          username: 'Kris',
          top_message: 'not nescesarry',
          chat_page_id: 'Kris',
          status: 'Offline'),
      UserGroupData(
          image: 'assets/images/pic.png',
          username: 'Lunatic',
          top_message: 'Hello',
          chat_page_id: 'Lunatic',
          status: 'DND'),
      UserGroupData(
          image: 'assets/images/temp4.png',
          username: 'Droub',
          top_message: 'When does the new season start',
          chat_page_id: 'Droub',
          status: 'Asleep'),
    ];

    List pages = [
      Messages(
        toggleMenu: toggleMenu,
        userData: userData,
      ),
      Notifications(),
      Friends(
        userData: userData,
      ),
      Profile(
        userData: userData,
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
                                    userData['profile_picture'] == ''
                                        ? 'assets/images/missing.png'
                                        : userData['profile_picture']),
                                radius: 11.5,
                                backgroundColor: Colors.transparent,
                              ),
                              Positioned(
                                bottom: -1,
                                right: -1,
                                child: StatusIcon(
                                    icon_type: userData['status_display'] != ''
                                        ? userData['status_display']
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