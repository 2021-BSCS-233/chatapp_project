import 'package:chatapp/services/api_class.dart';
import 'package:chatapp/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

List allIncomingRequests = [];
var IRLength = 0.obs;
List allOutgoingRequests = [];
var ORLength = 0.obs;

class Requests extends StatelessWidget {
  final Map clientUserData;

  Requests({required this.clientUserData});

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
    var field_check = false.obs;
    TextEditingController request_controller = TextEditingController();
    void changing() {
      field_check.value = (request_controller.text != '' ? true : false);
    }

    // allIncomingRequests = await getIncomingRequests(userData['_id']);
    // allOutgoingRequests = await getOutgoingRequests(userData['_id']);
    await getIncomingRequests(clientUserData['_id']);
    await getOutgoingRequests(clientUserData['_id']);

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
        body: TabBarView(
          children: [
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
                                  sendRequest(
                                      clientUserData['_id'], request_controller);
                                  request_controller.text = '';
                                },
                                style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(0),
                                  ),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                  Obx(() => ListView.builder(
                      itemCount: IRLength.value,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 15),
                          decoration: BoxDecoration(
                            // color: Color(0xFF16161A),
                            color: Color(0xFF121218),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  allIncomingRequests[index]['profile_pic'] ==
                                          ''
                                      ? 'assets/images/missing.png'
                                      : allIncomingRequests[index]
                                          ['profile_pic']),
                              radius: 17,
                              backgroundColor: Colors.transparent,
                            ),
                            title: Text(
                              allIncomingRequests[index]['display'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle:
                                Text(allIncomingRequests[index]['username']),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Container(
                                        width: 35,
                                        height: 40,
                                        child: Icon(Icons.check)),
                                    onTap: () {
                                      print(
                                          'Accept ${allIncomingRequests[index]['request_id']}');
                                      requestAction(
                                          allIncomingRequests[index]
                                              ['request_id'],
                                          'accept', () {
                                        getOutgoingRequests(clientUserData['_id']);
                                        getIncomingRequests(clientUserData['_id']);
                                      });
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
                                          allIncomingRequests[index]
                                              ['request_id'],
                                          'deny', () {
                                        getOutgoingRequests(clientUserData['_id']);
                                        getIncomingRequests(clientUserData['_id']);
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                ],
              ),
            ),
            Obx(() => ListView.builder(
                itemCount: ORLength.value,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      // color: Color(0xFF16161A),
                      color: Color(0xFF121218),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(
                            allOutgoingRequests[index]['profile_pic'] == ''
                                ? 'assets/images/missing.png'
                                : allOutgoingRequests[index]['profile_pic']),
                        radius: 17,
                        backgroundColor: Colors.transparent,
                      ),
                      title: Text(
                        allOutgoingRequests[index]['display'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(allOutgoingRequests[index]['username']),
                      trailing: InkWell(
                        child: Container(
                            width: 40, height: 40, child: Icon(Icons.close)),
                        onTap: () {
                          print(
                              'Deny ${allOutgoingRequests[index]['request_id']}');
                          requestAction(
                              allOutgoingRequests[index]['request_id'], 'deny',
                              () {
                            getOutgoingRequests(clientUserData['_id']);
                            getIncomingRequests(clientUserData['_id']);
                          });
                        },
                      ),
                    ),
                  );
                })),
          ],
        ),
      ),
    );
  }
}

sendRequest(currentUser, request) async {
  if (RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*?$').hasMatch(request.text)) {
    Map data = {
      'sender_id': currentUser,
      'username': request.text,
    };
    var response = await sendRequestPerform(data);
    if (response != null) {
      // allIncomingRequests = await getIncomingRequests(currentUser);
      allOutgoingRequests = await getOutgoingRequests(currentUser);
      // print('in requests $response');
    }
  }
}

getIncomingRequests(currentUser) async {
  Map data = {'receiver_id': currentUser};
  var response = await getIncomingRequestsPerform(data);
  // print('data: $response');
  if (response != 0) {
    allIncomingRequests = response;
    IRLength.value = response.length;
    // return response;
  } else {
    allIncomingRequests = [];
    IRLength.value = 0;
    // return null;
  }
}

getOutgoingRequests(currentUser) async {
  Map data = {'sender_id': currentUser};
  var response = await getOutgoingRequestsPerform(data);
  // print('data: $response');
  if (response != 0) {
    allOutgoingRequests = response;
    ORLength.value = response.length;
    // return response;
  } else {
    allOutgoingRequests = [];
    ORLength.value = 0;
    // return null;
  }
}

requestAction(request, action, function) async {
  Map data = {'request_id': request, 'action': action};
  var response = await requestActionPerform(data);
  // return response;
  if (response == true) {
    function();
  }
}
