import 'package:chatapp/services/api_class.dart';
import 'package:chatapp/widgets/input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/main.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


TextEditingController logInEmailController = TextEditingController();
TextEditingController logInPassController = TextEditingController();
class Login extends StatelessWidget {
  const Login({super.key});

  // @override // don't need future builder for now
  // Widget build(BuildContext context) {
  //   return FutureBuilder<Widget>(
  //     future: _buildContent(context), // Replace with your async function call
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         return snapshot.data!;
  //       } else if (snapshot.hasError) {
  //         return Text("${snapshot.error}"); // Handle error
  //       }
  //       // Show a loading indicator while waiting
  //       return CircularProgressIndicator();
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
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
                sufix_icon: CupertinoIcons.eye,
              ),
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () async {
                  var userData = await sendLogIn(logInEmailController, logInPassController);
                  if (userData != 0){
                    Get.to(Home(clientUserData: userData,));
                  } else {
                    print('login failed');
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
    );
  }
}

TextEditingController signInUsernameController = TextEditingController();
TextEditingController signInDisplayController = TextEditingController();
TextEditingController signInEmailController = TextEditingController();
TextEditingController signInPassController = TextEditingController();
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
    return Scaffold(
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
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
                sufix_icon: CupertinoIcons.eye,
              ),
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () async {
                  var userData = await sendSignIn(signInUsernameController,
                      signInDisplayController, signInEmailController, signInPassController);
                  if (userData != 0){
                    Get.to(Home(
                      clientUserData: userData,
                    ));
                  } else {
                    print('singin failed');
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
              InkWell(
                enableFeedback: false,
                onTap: () async {
                  var userData = await debugLogIn("myemail@gmail.com", "1234567890");
                  if (userData != 0){
                    Get.to(Home(clientUserData: userData,));
                  } else {
                    print('login failed');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'quick login debug go to messages',
                        style: TextStyle(color: Colors.blueAccent.shade200),
                      )),
                ),
              ),
              InkWell(
                enableFeedback: false,
                onTap: () async {
                  Get.to(Home(clientUserData: {"_id":"6648a114828c9c34649c176b","username":"lunaticgonemad","display_name":"Lunatic","email":"myemail@gmail.com","password":"1234567890","profile_picture":"assets/images/default.png","status":"Offline","status_display":"","pronounce":"","about_me":"","__v":0},));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'offline debug go to messages',
                        style: TextStyle(color: Colors.blueAccent.shade200),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

debugLogIn(email, pass) async {
    print('sending log in');
    Map data = {
      'email': email,
      'password': pass
    };
    var response = await logInUser(data);
    return response;
}


sendLogIn(email, pass) async {
  if (RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.text) &&
      RegExp(r'.{8,}').hasMatch(pass.text)) {
    print('sending log in');
    Map data = {
      'email': email.text,
      'password': pass.text
    };
    var response = await logInUser(data);
    // print(response);
    return response;
  } else {
    print('login denied');
  }
}

sendSignIn(user, display, email, pass) async {
  if (RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*?$').hasMatch(user.text) &&
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.text) &&
      RegExp(r'.{8,}').hasMatch(pass.text)) {
    print('All accepted');
    Map data = {
      'username': user.text,
      'display': display.text != '' ? display.text : user.text,
      'email': email.text,
      'password': pass.text
    };
    var response = await signInUser(data);
    // print('response: $response');
    return response;
  } else {
    print(RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*?$').hasMatch(user.text));
    print(RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email.text));
    print(RegExp(r'.{8,}').hasMatch(pass.text));
    Map data = {
      'username': user.text,
      'display': display.text,
      'email': email.text,
      'password': pass.text
    };

    print('failed $data');
  }
}
