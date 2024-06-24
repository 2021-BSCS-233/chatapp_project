import 'package:chatapp/services/api_class.dart';
import 'package:chatapp/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatapp/widgets/status_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

TextEditingController displayController = TextEditingController();
TextEditingController pronounceController = TextEditingController();
TextEditingController aboutMeController = TextEditingController();

class EditProfile extends StatelessWidget {
  final Map clientUserData;
  final Function updateClientUserData;
  final Function updateProfileData;

  EditProfile(
      {super.key,
      required this.clientUserData,
      required this.updateClientUserData,
      required this.updateProfileData}) {
    displayController.text = clientUserData['display_name'];
    pronounceController.text = clientUserData['pronounce'];
    aboutMeController.text = clientUserData['about_me'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121218),
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async {
              var result = await updateProfile(
                  clientUserData['_id'],
                  displayController.text,
                  pronounceController.text,
                  aboutMeController.text);
              if(result != 0){
                print('running');
                updateClientUserData(result);
                updateProfileData();
              }
            },
            child: Container(
              height: 50,
              width: 80,
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
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
                      height: 60,
                      color: Colors.transparent,
                    )
                  ],
                ),
                Positioned(
                  bottom: 10,
                  left: 20,
                  child: Stack(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 6, color: Color(0xFF121218))),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                              clientUserData['profile_picture'] ??
                                  'assets/images/missing.png'),
                          // radius: 10,
                          backgroundColor: Colors.grey.shade900,
                        ),
                      ),
                      Positioned(
                        bottom: 3,
                        right: 3,
                        child: StatusIcon(
                          icon_type: clientUserData['status'] == 'Online'
                              ? clientUserData['status_display']
                              : clientUserData['status'] ?? 'Offline',
                          icon_size: 24,
                          icon_border: 4,
                        ),
                      ),
                      Positioned(
                          right: 3,
                          top: 3,
                          child: InkWell(
                            child: Container(
                              height: 24,
                              width: 24,
                              child: Icon(
                                Icons.edit,
                                size: 14,
                                color: Colors.grey.shade400,
                              ),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF121218)),
                            ),
                          ))
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
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DISPLAY NAME',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontSize: 12)),
                    TextFormField(
                      controller: displayController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(),
                        labelText: clientUserData['display_name'],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('PRONOUNS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontSize: 12)),
                    TextFormField(
                      maxLength: 40,
                      controller: pronounceController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(),
                          labelText: clientUserData['pronounce']),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('ABOUT ME',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontSize: 12)),
                    TextFormField(
                      controller: aboutMeController,
                      maxLines: 7,
                      maxLength: 190,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(),
                        label: Text(clientUserData['about_me']),
                        // labelStyle: TextStyle(overflow: TextOverflow.ellipsis)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

updateProfile(id, display, pronounce, about) async {
  Map data = {
    'user_id': id,
    'display': display,
    'pronounce': pronounce,
    'about': about
  };
  return await updateProfilePerform(data);
}
