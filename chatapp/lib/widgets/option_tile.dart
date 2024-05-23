import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {
  final IconData action_icon;
  final String action_name;
  final Function action;
  OptionTile({required this.action, required this.action_icon, required this.action_name});

  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        // color: Color(0xFF18181D),
        color: Color(0xFF121218),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListTile(
        leading: Icon(action_icon),
        title: Text(action_name, style: TextStyle(fontWeight: FontWeight.w600),),
        onTap: () {
          action();
        },
      ),
    );
  }
}