import 'package:chatapp/pages/login_signin_page.dart';
import 'package:chatapp/services/api_class.dart';
import 'package:chatapp/services/datatypes_and_global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/widgets/popup_menus.dart';
import 'package:chatapp/widgets/status_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/pages/chats_page.dart';
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
    home: Loading(),
  ));
}

var UserData;
bool result = false;
bool initialMain = true;

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _buildContent(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          print("${snapshot.error}");
          return Material(
              color: Colors.transparent,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("We could not access our services"),
                    Text("Check your connection or try again later")
                  ],
                ),
              ));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<Widget> _buildContent(BuildContext context) async {
    initialMain ? await login_check() : null;
    if (result) {
      print('log data available');
      connectSocket(UserData['_id']);
      return Home(clientUserData: UserData);
    } else {
      print('login data not available');
      return Signin();
    }
  }

  login_check() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? password = prefs.getString('password');
    if (email != null && password != null) {
      Map data = {'email': email, 'password': password};
      var response = await sendLogInPerform(data);
      if (response != 0) {
        UserData = response;
        result = true;
      } else {
        result = false;
      }
    } else {
      result = false;
    }
    initialMain = false;
  }
}

var update = 0.obs;
var selectedIndex = 0.obs;
var selectedUsername = '';
var selectedUserId = '';
var selectedUserPic = '';
var selectedChatType = '';

var showMenu = false.obs;
var showProfile = false.obs;

void toggleMenu(dataList) {
  selectedUserId = dataList[0];
  selectedUsername = dataList[1];
  selectedUserPic = dataList[2];
  selectedChatType = dataList[3];
  showMenu.value = !showMenu.value;
}

void toggleProfile(data) {
  selectedUserId = data;
  showProfile.value = !showProfile.value;
}

class Home extends StatelessWidget {
  Map clientUserData;

  Home({super.key, required this.clientUserData}) {
    initialM = true;
    initialF = true;
    clientUserDataGlobal = clientUserData;
  }

  updateClientUserData(newData) {
    clientUserDataGlobal = newData;
    clientUserData = newData;
  }

  updateStatusDisplay(status) {
    clientUserDataGlobal['status_display'] = status;
    update += 1;
  }

  @override
  Widget build(BuildContext context) {
    List pages = [
      Chats(
        toggleMenu: toggleMenu,
        toggleProfile: toggleProfile,
        clientUserData: clientUserData,
      ),
      // const Notifications(),
      Friends(
        clientUserData: clientUserData,
        toggleProfile: toggleProfile,
      ),
      Profile(
        toggleMenu: toggleMenu,
        updateClientUserData: updateClientUserData,
      )
    ];

    return Stack(
      children: [
        Column(
          children: [
            Obx(() => Expanded(child: pages[selectedIndex.value])),
            Obx(() => BottomNavigationBar(
                  currentIndex: selectedIndex.value,
                  onTap: (index) {
                    selectedIndex.value = index;
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
                    // BottomNavigationBarItem(
                    //     icon: Icon(Icons.notifications),
                    //     label: 'Notifications'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.people), label: 'Friends'),
                    BottomNavigationBarItem(
                        icon: Container(
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
                                backgroundColor: Color(0x20F2F2F2),
                              ),
                              Positioned(
                                  bottom: -1,
                                  right: -1,
                                  child: Obx(
                                    () => StatusIcon(
                                      icon_type: update == 1
                                          ? clientUserDataGlobal[
                                              'status_display']
                                          : clientUserDataGlobal[
                                              'status_display'],
                                      border_color: Color(0xFF222222),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        label: 'Profile'),
                  ],
                )),
          ],
        ),
        Obx(() => Visibility(
              visible: showMenu.value || showProfile.value,
              child: GestureDetector(
                onTap: () {
                  selectedUserId = '';
                  showMenu.value = false;
                  showProfile.value = false;
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
              child: selectedIndex.value == 0
                  ? UserGroupPopup(
                      tile_content: [
                        selectedUserId,
                        selectedUsername,
                        selectedUserPic,
                        selectedChatType
                      ],
                    )
                  : selectedIndex.value == 2
                      ? StatusPopup(
                          clientUserData: clientUserData,
                          updateSD: updateStatusDisplay)
                      : Container(),
            )),
        Obx(() => AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              bottom:
                  showProfile.value ? 0.0 : -MediaQuery.of(context).size.height,
              left: 0.0,
              right: 0.0,
              child: selectedUserId == ''
                  ? Container()
                  : ProfilePopup(selectedUser: selectedUserId),
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
//  make chat work
//  option to edit profile
//TODO: add option to change account into (ignored for now)

//future builder code cuz i keep forgetting
// @override
// Widget build(BuildContext context) {
//   return FutureBuilder<Widget>(
//     future: _buildContent(context),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         return snapshot.data!;
//       } else if (snapshot.hasError) {
//         return Text("${snapshot.error}");
//       }
//       return CircularProgressIndicator();
//     },
//   );
// }
//
// Future<Widget> _buildContent(BuildContext context) async {
