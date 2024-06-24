import 'package:chatapp/services/api_class.dart';
import 'package:chatapp/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

var update = 0.obs;
var initial = true;
List allIncomingRequests = [];
List allOutgoingRequests = [];
var field_check = false.obs;
TextEditingController request_controller = TextEditingController();

void changing() {
  field_check.value = (request_controller.text != '' ? true : false);
}

class Requests extends StatelessWidget {
  final Map clientUserData;

  Requests({required this.clientUserData});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Requests',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xD0FFFFFF),
                fontSize: 22),
          ),
          bottom: TabBar(
            tabs: [Tab(text: 'Incoming'), Tab(text: 'Outgoing')],
            indicatorColor: Colors.transparent,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.white,
            dividerColor: Colors.transparent,
          ),
        ),
        body: FutureBuilder<Widget>(
          future: requestsData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!;
            } else if (snapshot.hasError) {
              return Material(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("We could not access our services"),
                      Text("Check your connection or try again later")
                    ],
                  ),
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Future<Widget> requestsData() async {
    initial ? await getRequestsData(clientUserData['_id']) : null;
    return TabBarView(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10),
          child: Obx(() => update.value == update.value &&
                  allIncomingRequests.length < 1
              ? Center(
                  child: Text('You do not have Incoming Requests'),
                )
              : ListView.builder(
                  itemCount: allIncomingRequests.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        color: Color(0xFF121218),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(
                              allIncomingRequests[index]['profile_pic'] == ''
                                  ? 'assets/images/missing.png'
                                  : allIncomingRequests[index]['profile_pic']),
                          radius: 17,
                          backgroundColor: Color(0x20F2F2F2),
                        ),
                        title: Text(
                          allIncomingRequests[index]['display'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(allIncomingRequests[index]['username']),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: Container(
                                    width: 35,
                                    height: 40,
                                    child: Icon(Icons.check)),
                                onTap: () async {
                                  print(
                                      'Accept ${allIncomingRequests[index]['request_id']}');
                                  await requestAction(
                                      allIncomingRequests[index]['request_id'],
                                      'accept');
                                  await getIncomingRequests(
                                      clientUserData['_id']);
                                  update.value += 1;
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                child: Container(
                                    width: 35,
                                    height: 40,
                                    child: Icon(Icons.close)),
                                onTap: () {
                                  print(
                                      'Deny ${allIncomingRequests[index]['request_id']}');
                                  requestAction(
                                      allIncomingRequests[index]['request_id'],
                                      'deny');
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      field_label: 'Add Friend',
                      controller: request_controller,
                      prefix_icon: CupertinoIcons.person_add,
                      on_change: changing,
                      contentTopPadding: 10,
                    ),
                  ),
                  Obx(() => Visibility(
                        visible: field_check.value,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blueAccent.shade700),
                          width: 40,
                          height: 40,
                          child: TextButton(
                            child: Icon(
                              Icons.send,
                              size: 25,
                            ),
                            onPressed: () {
                              field_check.value = false;
                              sendRequest(clientUserData['_id'],
                                  request_controller.text.trim());
                              request_controller.text = '';
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(0),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
              Obx(() => Expanded(
                    child: update.value == update.value &&
                            allOutgoingRequests.length < 1
                        ? Center(
                            child: Text('You Havent Send Any Requests'),
                          )
                        : ListView.builder(
                            itemCount: update.value == -1
                                ? allOutgoingRequests.length
                                : allOutgoingRequests.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(top: 15),
                                decoration: BoxDecoration(
                                  color: Color(0xFF121218),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ListTile(
                                  dense: true,
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage(
                                        allOutgoingRequests[index]
                                                    ['profile_pic'] ==
                                                ''
                                            ? 'assets/images/missing.png'
                                            : allOutgoingRequests[index]
                                                ['profile_pic']),
                                    radius: 17,
                                    backgroundColor: Color(0x20F2F2F2),
                                  ),
                                  title: Text(
                                    allOutgoingRequests[index]['display'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  subtitle: Text(
                                      allOutgoingRequests[index]['username']),
                                  trailing: InkWell(
                                    child: Container(
                                        width: 40,
                                        height: 40,
                                        child: Icon(Icons.close)),
                                    onTap: () {
                                      print(
                                          'Deny ${allOutgoingRequests[index]['request_id']}');
                                      requestAction(
                                          allOutgoingRequests[index]
                                              ['request_id'],
                                          'deny');
                                    },
                                  ),
                                ),
                              );
                            }),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

getRequestsData(currentUser) async {
  await getIncomingRequests(currentUser);
  await getOutgoingRequests(currentUser);
  initial = false;
  update.value += 1;
}

sendRequest(currentUser, request) async {
  if (RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*?$').hasMatch(request)) {
    Map data = {
      'sender_id': currentUser,
      'username': request,
    };
    var response = await sendRequestPerform(data);
    if (response != 0) {
      await getOutgoingRequests(currentUser);
      print('error line $allOutgoingRequests');
      update.value += 1;
    }
  }
}

getIncomingRequests(currentUser) async {
  Map data = {'receiver_id': currentUser};
  var response = await getIncomingRequestsPerform(data);
  if (response != 0) {
    allIncomingRequests = response;
  } else {
    allIncomingRequests = [];
  }
}

getOutgoingRequests(currentUser) async {
  Map data = {'sender_id': currentUser};
  var response = await getOutgoingRequestsPerform(data);
  if (response != 0) {
    allOutgoingRequests = response;
  } else {
    allOutgoingRequests = [];
  }
}

requestAction(request, action) async {
  Map data = {'request_id': request, 'action': action};
  await requestActionPerform(data);
}
