import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/pages/requests_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:chatapp/services/api_class.dart';

bool initialF = true;
var update = 0.obs;
List friends = [];

class Friends extends StatelessWidget {
  final Map clientUserData;
  final Function toggleProfile;

  const Friends(
      {super.key, required this.clientUserData, required this.toggleProfile});

  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder<Widget>(
  //     future: _buildContent(context), // Replace with your async function call
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         return snapshot.data!;
  //       } else if (snapshot.hasError) {
  //         return Material(
  //             color: Colors.transparent,
  //             child: Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Text("We could not access our services"),
  //                   Text("Check your connection or try again later")
  //                 ],
  //               ),
  //             )); // Handle error
  //       }
  //       // Show a loading indicator while waiting
  //       return CircularProgressIndicator();
  //     },
  //   );
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Friends',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF),
              fontSize: 22),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(Requests(
                clientUserData: clientUserData,
              ));
            },
            child: Container(
              height: 40,
              width: 120,
              decoration: BoxDecoration(
                  color: Colors.blueAccent.shade700,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Add Friend'),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: FutureBuilder<Widget>(
        future: friendsData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else if (snapshot.hasError) {
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
      ),
    );
  }

  Future<Widget> friendsData() async {
    initialF ? await getFriends(clientUserData['_id']) : null;

    return Obx(() => update.value == update.value && friends.length < 1
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You do not have any friends'),
                Text('Start adding some friends to chat with')
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.only(left: 10),
            child: ListView.builder(
                itemCount: friends.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      color: Color(0xFF121218),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: ListTile(
                      leading: InkWell(
                        onTap: () {
                          toggleProfile(friends[index]['friend_id']);
                        },
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage(friends[index]['picture']),
                          radius: 17,
                          backgroundColor: Colors.grey.shade900,
                        ),
                      ),
                      title: Text(
                        friends[index]['display'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Container(
                        width: 70,
                        child: Row(
                          children: [
                            InkWell(
                              child: Icon(CupertinoIcons.chat_bubble_text_fill),
                              onTap: () {
                                Get.to(Chat(
                                    chatPageId: friends[index]['chat_id'],
                                    otherUserData: friends[index],
                                    clientUserData: clientUserData));
                              },
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              child: Icon(
                                Icons.person_remove,
                                color: Colors.red,
                              ),
                              onTap: () {
                                print(
                                    'Unfriended ${friends[index]['friend_id']}');
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ));
  }
}

getFriends(currentUser) async {
  Map data = {
    'user_id': currentUser,
  };
  var response = await getFriendsPerform(data);
  if (response != 0) {
    friends = response;
    // friends.sort((map1, map2) => map1["friend_display"]!.compareTo(map2["friend_display"] as String));
    initialF = false;
    // return response;
  } else {
    friends = [];
  }
  update.value += 1;
}
