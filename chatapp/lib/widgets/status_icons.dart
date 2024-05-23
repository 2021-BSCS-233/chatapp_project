import 'package:flutter/material.dart';

class StatusIcon extends StatelessWidget {
  final String icon_type;
  final double? icon_size;
  final double? icon_border;
  StatusIcon({required this.icon_type, this.icon_border, this.icon_size});

  @override
  Widget build(BuildContext context){
    double size = icon_size ?? 16.0;
    double border = icon_border ?? 2.5;
    if (icon_type == 'Online'){
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(width: border),
          shape: BoxShape.circle,
          color: Colors.green,
        ),
      );
    }
    else if (icon_type == 'DND'){
      return Container(
        width: size,
        height: size,
        child: Center(
          child: Container(
            height: 2.5,
            width: 7.5,
            color: Colors.black,
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(width: border),
          shape: BoxShape.circle,
          color: Colors.red.shade600,
        ),
      );
    }
    else if (icon_type == 'Asleep'){
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(width: border),
          shape: BoxShape.circle,
          color: Colors.yellow,
        ),
      );
    }
    else if (icon_type == 'Offline'){
      return Container(
        child: Center(
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              border: Border.all(width: 0),
              color: Colors.black,
              shape: BoxShape.circle
            ),
          ),
        ),
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(width: border),
          shape: BoxShape.circle,
          color: Colors.grey.shade600,
        ),
      );
    }
    else {
      return Container(
        child: Center(
          child: Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
                border: Border.all(width: 0),
                color: Colors.black,
                shape: BoxShape.circle
            ),
          ),
        ),
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(width: border),
          shape: BoxShape.circle,
          color: Colors.grey.shade600,
        ),
      );
    }
  }
}
