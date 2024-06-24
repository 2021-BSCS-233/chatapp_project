import 'package:chatapp/services/api_class.dart';
import 'package:chatapp/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

TextEditingController logInEmailController = TextEditingController();
TextEditingController logInPassController = TextEditingController();
var showOverlayLogIn = false.obs;
var showMessageLogIn = false.obs;

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Log In',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Text('We\'re excited to see you again!'),
                  SizedBox(
                    height: 40,
                  ),
                  Align(
                    child: Container(
                        margin: EdgeInsets.only(left: 5, bottom: 5),
                        child: Text(
                          'ACCOUNT INFORMATION',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        )),
                    alignment: Alignment.centerLeft,
                  ),
                  InputField(
                    field_label: 'Email',
                    controller: logInEmailController,
                    field_radius: 2,
                    horisontal_margin: 0,
                    vertical_margin: 2,
                    field_hight: 50,
                    contentTopPadding: 13,
                    sufix_icon: Icons.all_inclusive,
                  ),
                  InputField(
                    field_label: 'Password',
                    controller: logInPassController,
                    field_radius: 2,
                    horisontal_margin: 0,
                    vertical_margin: 2,
                    field_hight: 50,
                    contentTopPadding: 13,
                    sufix_icon: Icons.all_inclusive,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () async {
                      showOverlayLogIn.value = true;
                      var userData = await sendLogIn(
                          logInEmailController.text.trim(),
                          logInPassController.text.trim());
                      if (userData != 0) {
                        connectSocket(userData['_id']);
                        await saveUserOnDevice(logInEmailController.text.trim(),
                            logInPassController.text.trim());
                        showOverlayLogIn.value = false;
                        Get.off(Home(
                          clientUserData: userData,
                        ));
                      } else {
                        showOverlayLogIn.value = true;
                        showMessageLogIn.value = true;
                      }
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Center(child: Text('Log In')),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.shade700,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: showOverlayLogIn.value || showMessageLogIn.value,
              child: GestureDetector(
                onTap: showMessageLogIn.value
                    ? () {
                        showOverlayLogIn.value = false;
                        showMessageLogIn.value = false;
                      }
                    : () {},
                child: Container(
                  color: Color(0xC01D1D1F),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            )),
        Obx(() => Material(
              color: Colors.transparent,
              child: Visibility(
                visible: showMessageLogIn.value,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Color(0xFF121218),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('LogIn Failed',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 5),
                        Text('Email or Password is Wrong',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 35),
                        InkWell(
                          onTap: () {
                            showMessageLogIn.value = false;
                            showOverlayLogIn.value = false;
                          },
                          child: Container(
                            height: 50,
                            width: 130,
                            child: Center(
                              child: Text(
                                'Close',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade700,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

TextEditingController signInUsernameController = TextEditingController();
TextEditingController signInDisplayController = TextEditingController();
TextEditingController signInEmailController = TextEditingController();
TextEditingController signInPassController = TextEditingController();

var showOverlaySignIn = false.obs;
var showMessageSignIn = false.obs;
double messageHeightSignIn = 250;
String failMessage = '';

class Signin extends StatelessWidget {
  void checkNameFormat(TextEditingController controller) {
    if (RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*?$').hasMatch(controller.text)) {
      print('matches');
    } else {
      print('doesnt match');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Create Account',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Welcome To Quarrel!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Text('We\'re excited to see you join us!'),
                  SizedBox(
                    height: 40,
                  ),
                  Align(
                    child: Container(
                        margin: EdgeInsets.only(left: 5, bottom: 5),
                        child: Text(
                          'ACCOUNT INFORMATION',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        )),
                    alignment: Alignment.centerLeft,
                  ),
                  InputField(
                    field_label: 'Username',
                    controller: signInUsernameController,
                    field_radius: 2,
                    horisontal_margin: 0,
                    vertical_margin: 2,
                    field_hight: 50,
                    contentTopPadding: 13,
                    sufix_icon: Icons.all_inclusive,
                    maxLength: 20,
                    // on_change: () {
                    //   checkNameFormat(username_controller);
                    // },
                  ),
                  InputField(
                    field_label: 'Display Name',
                    controller: signInDisplayController,
                    field_radius: 2,
                    horisontal_margin: 0,
                    vertical_margin: 2,
                    field_hight: 50,
                    contentTopPadding: 13,
                    sufix_icon: Icons.all_inclusive,
                  ),
                  InputField(
                    field_label: 'Email',
                    controller: signInEmailController,
                    field_radius: 2,
                    horisontal_margin: 0,
                    vertical_margin: 2,
                    field_hight: 50,
                    contentTopPadding: 13,
                    sufix_icon: Icons.all_inclusive,
                  ),
                  InputField(
                    field_label: 'Password',
                    controller: signInPassController,
                    field_radius: 2,
                    horisontal_margin: 0,
                    vertical_margin: 2,
                    field_hight: 50,
                    contentTopPadding: 13,
                    sufix_icon: Icons.all_inclusive,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () async {
                      showOverlaySignIn.value = true;
                      var userData = await sendSignIn(
                          signInUsernameController.text.trim(),
                          signInDisplayController.text.trim(),
                          signInEmailController.text.trim(),
                          signInPassController.text.trim());
                      if (userData != 0) {
                        connectSocket(userData['_id']);
                        await saveUserOnDevice(
                            signInEmailController.text.trim(),
                            signInPassController.text.trim());
                        showOverlaySignIn.value = false;
                        Get.off(Home(
                          clientUserData: userData,
                        ));
                      } else {
                        print('SingIn failed');
                      }
                    },
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Center(child: Text('Sign In')),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.shade700,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                  ),
                  InkWell(
                    enableFeedback: false,
                    onTap: () {
                      Get.to(Login());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Already have an account? Log In',
                            style: TextStyle(color: Colors.blueAccent.shade200),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() => Visibility(
              visible: showOverlaySignIn.value || showMessageSignIn.value,
              child: GestureDetector(
                onTap: showMessageSignIn.value
                    ? () {
                        showMessageSignIn.value = false;
                        showOverlaySignIn.value = false;
                        messageHeightSignIn = 250;
                        failMessage = '';
                      }
                    : () {},
                child: Container(
                  color: Color(0xC01D1D1F),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            )),
        Obx(() => Material(
              color: Colors.transparent,
              child: Visibility(
                visible: showMessageSignIn.value,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: messageHeightSignIn,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Color(0xFF121218),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('SignIn Failed',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 5),
                        Text(failMessage,
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(height: 35),
                        InkWell(
                          onTap: () {
                            showMessageSignIn.value = false;
                            showOverlaySignIn.value = false;
                            messageHeightSignIn = 250;
                            failMessage = '';
                          },
                          child: Container(
                            height: 50,
                            width: 130,
                            child: Center(
                              child: Text(
                                'Close',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent.shade700,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

saveUserOnDevice(email, pass) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('password', pass);
  print('saved data');
}

sendLogIn(email, pass) async {
  if (RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email) &&
      RegExp(r'.{8,}').hasMatch(pass)) {
    print('sending log in');
    Map data = {'email': email, 'password': pass};
    var response = await sendLogInPerform(data);
    return response;
  } else {
    print('login denied');
  }
}

sendSignIn(user, display, email, pass) async {
  if (RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*?$').hasMatch(user) &&
      user.length >= 3 &&
      user.length <= 20 &&
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email) &&
      RegExp(r'.{8,}').hasMatch(pass)) {
    print('All accepted');
    Map data = {
      'username': user,
      'display': display != '' ? display : user,
      'email': email,
      'password': pass
    };
    var response = await sendSignInPerform(data);
    if (response != 0) {
      return response;
    } else {
      failMessage = '• Error Occurred While Trying to Sign In Pls Try Again Later';
      showOverlaySignIn.value = true;
      showMessageSignIn.value= true;
      return 0;
    }
  } else {
    if (user == '') {
      failMessage = '• Pls Enter a Username';
    } else if (user.length < 3 || user.length > 20) {
      failMessage = '• Length of Username Must Between 3 to 20';
    } else if (!(RegExp(r'^[a-zA-Z][a-zA-Z0-9_]+?$').hasMatch(user))) {
      failMessage =
          '• Username Must Start With An Alphabet And Can Only Container Letters, Numbers and \'_\'';
      messageHeightSignIn += 15;
    }
    if (!(RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email))) {
      failMessage = "$failMessage\n• Invalid Email Format";
      messageHeightSignIn += 10;
    }
    if (!(RegExp(r'.{8,}').hasMatch(pass))) {
      failMessage = "$failMessage\n• Password Must be At Least 8 Characters";
      messageHeightSignIn += 10;
    }
    Map data = {
      'username': user,
      'display': display,
      'email': email,
      'password': pass
    };
    showOverlaySignIn.value = true;
    showMessageSignIn.value = true;
    print('failed $data');
    return 0;
  }
}
