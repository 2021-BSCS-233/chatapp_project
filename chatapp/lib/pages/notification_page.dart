import 'package:flutter/material.dart';

class Notifications extends StatelessWidget{
  const Notifications({super.key});


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xD0FFFFFF),
              fontSize: 22),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            ListTile(leading: Icon(Icons.notification_add),title: Text('Notification 1'),),
            ListTile(leading: Icon(Icons.notification_add),title: Text('Notification 2'),),
            ListTile(leading: Icon(Icons.notification_add),title: Text('Notification 3'),)
          ],
        ),
      ),
    );
  }
}