import 'package:chatapp/pages/login_signin_page.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:chatapp/services/api_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

var showMenu = false.obs;

void toggleMenu() {
  showMenu.value = !showMenu.value;
}

TextEditingController usernameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class EditAccount extends StatelessWidget {
  final clientUserData;

  EditAccount({super.key, required this.clientUserData}) {
    usernameController.text = clientUserData['username'];
    emailController.text = clientUserData['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: MediaQuery.of(context).size.height * 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text('USERNAME',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                              fontSize: 12)),
                      TextFormField(
                        controller: usernameController,
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
                      Text('EMAIL',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade400,
                              fontSize: 12)),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(),
                          labelText: clientUserData['email'],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              toggleMenu();
                            },
                            child: Container(
                              height: 45,
                              width: 140,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent.shade700,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              updateAccount(usernameController.text,
                                  emailController.text, '1234567890');
                            },
                            child: Container(
                              height: 45,
                              width: 140,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent.shade700,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      logOutDisconnect(clientUserData['_id']);
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('email');
                      await prefs.remove('password');
                      Get.offAll(Signin());
                    },
                    child: Container(
                      height: 45,
                      width: 140,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: showMenu.value,
              child: GestureDetector(
                onTap: () {
                  toggleMenu();
                },
                child: Container(
                  color: Color(0xC01D1D1F),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                ),
              ),
            )),
        Obx(() => Material(
              color: Colors.transparent,
              child: Visibility(
                visible: showMenu.value,
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      height: 400,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Color(0xFF121218),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('OLD PASSWORD',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                  fontSize: 12)),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: OutlineInputBorder(),
                              labelText: clientUserData['email'],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text('OLD PASSWORD',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                  fontSize: 12)),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: OutlineInputBorder(),
                              labelText: clientUserData['email'],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

updateAccount(username, email, password) async {
  Map data = {
    'username': username,
    'password': password,
    'new_username': username,
    'new_email': email,
  };
  // var response = await updateAccountPerform(data);
}
