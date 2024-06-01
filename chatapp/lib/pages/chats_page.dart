import 'package:chatapp/pages/requests_page.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/widgets/user_group_tile.dart';
import 'package:get/get.dart';
import '../services/api_class.dart';
import '../widgets/status_icons.dart';

bool initialM = true;
List chats = [];
var CsLength = 0.obs;
List friends = [];
var FLength = 0.obs;
// const List<String> statusOrder = ['Online', 'DND', 'Asleep', 'Offline'];
// List<String> desiredDisplayOrder = ["Online", "DND", "Asleep", "Offline"];

class Chats extends StatelessWidget {
  final Map clientUserData;
  final Function toggleMenu;

  // final Function toFriends;
  // final List<UserGroupData> tile_content;
  Chats({super.key, required this.toggleMenu, required this.clientUserData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
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
            child: Row(
              children: [
                Icon(Icons.person_add),
                SizedBox(
                  width: 10,
                ),
                Text('Add Friend'),
              ],
            ),
          ),
          SizedBox(
            width: 25,
          )
        ],
      ),
      body: FutureBuilder<Widget>(
        future: MessagesData(),
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
          // Show a loading indicator while waiting
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<Widget> MessagesData() async {
    initialM ? await getData(clientUserData['_id']) : null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 90,
            child: Obx(() => ListView.builder(
                itemCount: FLength.value,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Color(0xFF18181F),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          print('profile: ${friends[index]['friend_id']}');
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                    friends[index]['picture'] == ''
                                        ? 'assets/images/default.png'
                                        : friends[index]['picture']),
                                // radius: 1,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Positioned(
                              bottom: -2,
                              right: -2,
                              child: StatusIcon(
                                icon_type:
                                    friends[index]['status'] == 'Online'
                                        ? friends[index]['status_display']
                                        : friends[index]['status'],
                                icon_size: 17,
                                icon_border: 3.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemCount: CsLength.value,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return chats[index]['chat_type'] == 'dm'
                        ? UserChatTile(
                            clientUserData: clientUserData,
                            otherUserData: chats[index]['users'][0],
                            topMessage: chats[index]['latest_message'],
                            chatPageId: chats[index]['chat_id'],
                            chatType: chats[index]['chat_type'],
                            logPressMenu: toggleMenu)
                        : Container(
                            height: 50,
                            width: 100,
                            child: Center(
                              child: Text(
                                  'add support for ${chats[index]['chat_type']}'),
                            ),
                          );
                  },
                )),
          ),
        ],
      ),
    );
  }
}

getData(currentUser) async {
  print('updating');
  await getChats(currentUser);
  await getFriends(currentUser);
  initialM = false;
  print('updated');
}

getChats(currentUser) async {
  Map data = {'user_id': currentUser};
  var response = await getChatsPerform(data);
  // print('chats response $response');
  if (response != 0) {
    chats = response;
    CsLength.value = response.length;
    // return response;
  } else {
    chats = [];
    CsLength.value = 0;
  }
}

getFriends(currentUser) async {
  Map data = {
    'user_id': currentUser,
  };
  var response = await getFriendsPerform(data);
  // print('friends response $response');
  if (response != 0) {
    friends = response;
    // friends.sort((map1, map2) {
    //   int aIndex = statusOrder.indexOf(map1['status']!);
    //   int bIndex = statusOrder.indexOf(map2['status']!);
    //   return aIndex.compareTo(bIndex);
    // });

    // friends.sort((map1, map2) {
    //   // Sort by "status" first ("Online" before "Offline")
    //   int statusOrder = map1["status"].compareTo(map2["status"]);
    //   if (statusOrder != 0) return statusOrder;
    //   // Sort by "display_status" within "status" group (using desired order)
    //   return desiredDisplayOrder.indexOf(map1["display_status"]).compareTo(
    //   desiredDisplayOrder.indexOf(map2["display_status"]));
    // });
    FLength.value = response.length;
    // return response;
  } else {
    friends = [];
    FLength.value = 0;
  }
}

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
