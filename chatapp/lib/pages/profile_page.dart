// import 'package:chatapp/pages/edit_account_page.dart';
import 'package:chatapp/pages/edit_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatapp/widgets/status_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatapp/services/datatypes_and_global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/services/api_class.dart';
import 'package:chatapp/pages/login_signin_page.dart';

var update = 0.obs;

class Profile extends StatelessWidget {
  final Function toggleMenu;
  final Function updateClientUserData;

  Profile(
      {super.key,
      required this.toggleMenu,
      required this.updateClientUserData});

  updateProfileData() {
    update.value += 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(() => Column(
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
                                  clientUserDataGlobal['profile_picture'] == ''
                                      ? 'assets/images/missing.png'
                                      : clientUserDataGlobal[
                                          'profile_picture']),
                              // radius: 10,
                              backgroundColor: Colors.grey.shade900,
                            ),
                          ),
                          Positioned(
                            bottom: 3,
                            right: 3,
                            child: StatusIcon(
                              icon_type: clientUserDataGlobal['status'] ==
                                      'Online'
                                  ? clientUserDataGlobal['status_display']
                                  : clientUserDataGlobal['status'] ?? 'Offline',
                              icon_size: 24,
                              icon_border: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                    //     right: 15,
                    //     top: 40,
                    //     child: InkWell(
                    //       onTap: (){
                    //         Get.to(EditAccount(clientUserData: clientUserData,));
                    //       },
                    //       child: Container(
                    //           height: 35,
                    //           width: 35,
                    //           decoration: BoxDecoration(
                    //             shape: BoxShape.circle,
                    //             color: Colors.black54
                    //           ),
                    //           child: Icon(Icons.settings, size: 28,)),
                    //     ))
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
                        update.value == 1
                            ? clientUserDataGlobal['display_name']
                            : clientUserDataGlobal['display_name'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        clientUserDataGlobal['username'],
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        clientUserDataGlobal['pronounce'],
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
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
                                Get.to(EditProfile(
                                  clientUserData: clientUserDataGlobal,
                                  updateClientUserData: updateClientUserData,
                                  updateProfileData: updateProfileData,
                                ));
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
                  // height: 200,
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
                        '''${clientUserDataGlobal['about_me']}''',
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey.shade300),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: () async {
                    logOutDisconnect(clientUserDataGlobal['_id']);
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('email');
                    await prefs.remove('password');
                    Get.offAll(Signin());
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 45,
                      width: 140,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.redAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
