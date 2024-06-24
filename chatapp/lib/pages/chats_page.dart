import 'package:chatapp/pages/requests_page.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/widgets/user_group_tile.dart';
import 'package:get/get.dart';
import 'package:chatapp/services/api_class.dart';
import 'package:chatapp/widgets/status_icons.dart';
import 'package:chatapp/services/datatypes_and_global.dart';

var update = 0.obs;
bool initialM = true;
List chats = [];
List friends = [];
List<String> desiredDisplayOrder = ["Online", "DND", "Asleep", "Offline"];

class Chats extends StatelessWidget {
  final Map clientUserData;
  final Function toggleMenu;
  final Function toggleProfile;

  Chats(
      {super.key,
      required this.toggleMenu,
      required this.clientUserData,
      required this.toggleProfile});

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
            print(snapshot.error);
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

  Future<Widget> MessagesData() async {
    initialM ? await getChatsData(clientUserData['_id']) : null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Obx(
            () => SizedBox(
                width: double.infinity,
                height: 90,
                child:  update.value == update.value && friends.length < 1
                    ? Container()
                    : ListView.builder(
                        itemCount: friends.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(5),
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Color(0xAA18181F),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  toggleProfile(friends[index]['friend_id']);
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
                                        backgroundColor: Colors.grey.shade900,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -2,
                                      right: -2,
                                      child: StatusIcon(
                                        icon_type: friends[index]['status'] ==
                                                'Online'
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
          Obx(
            () => Expanded(
                child: update.value == update.value && chats.length < 1
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('You Do Not Have Any Friends'),
                            Text('Add Friends to Chat With')
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: chats.length,
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

getChatsData(currentUser) async {
  await getChats(currentUser);
  await getFriends(currentUser);
  initialM = false;
  update.value += 1;
}

getChats(currentUser) async {
  Map data = {'user_id': currentUser};
  var response = await getChatsPerform(data);
  if (response != 0) {
    chats = response;
  } else {
    chats = [];
  }
}

getFriends(currentUser) async {
  Map data = {
    'user_id': currentUser,
  };
  var response = await getFriendsPerform(data);
  if (response != 0) {
    friends = response;

    // friends.sort((map1, map2) {
    //   // Sort by "status" first ("Online" before "Offline")
    //   int statusOrder = map1["status"].compareTo(map2["status"]);
    //   if (statusOrder != 0) return statusOrder;
    //   // Sort by "display_status" within "status" group (using desired order)
    //   return desiredDisplayOrder.indexOf(map1["display_status"]).compareTo(
    //   desiredDisplayOrder.indexOf(map2["display_status"]));
    // });
    // return response;
  } else {
    friends = [];
  }
}
