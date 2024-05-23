import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  final IconData? prefix_icon;
  final IconData? sufix_icon;
  final Color? field_color;
  final String field_label;
  final TextEditingController controller;
  final double? field_hight;
  final double? field_radius;
  final double? horisontal_margin;
  final double? vertical_margin;
  final double? contentTopPadding;
  final Function? on_change;
  final List<TextInputFormatter>? inputFormats;
  final int? maxLength;

  InputField(
      {required this.field_label,
      required this.controller,
      this.sufix_icon,
      this.prefix_icon,
      this.field_color,
      this.field_hight,
      this.on_change,
      this.inputFormats,
      this.field_radius,
      this.horisontal_margin,
      this.vertical_margin,
      this.maxLength,
      this.contentTopPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: horisontal_margin ?? 5, vertical: vertical_margin ?? 0),
      height: field_hight ?? 40,
      child: TextFormField(

        inputFormatters: inputFormats,
        maxLength: maxLength,
        maxLines: 1,
        onChanged: (e) {
          on_change != null ? on_change!() : null;
        },
        controller: controller,
        decoration: InputDecoration(
          counterText: '',
          isCollapsed: true,
          contentPadding: EdgeInsets.fromLTRB(prefix_icon != null ? 5.0 : 15, contentTopPadding == null ? 6.5 : contentTopPadding!, 5.0, 0.0),
          //made it so if you pass all_inclusive icon it becomes invis as a temp solution for this field height not working problem
          //PS all_inclusive icon cuz its the least use apparently
          prefixIcon: prefix_icon == Icons.all_inclusive
              ? Icon(
                  prefix_icon,
                  color: Colors.transparent,
                )
              : prefix_icon != null
                  ? Icon(prefix_icon)
                  : null,
          suffixIcon: sufix_icon == Icons.all_inclusive
              ? Icon(
                  sufix_icon,
                  color: Colors.transparent,
                )
              : sufix_icon != null
                  ? Icon(sufix_icon)
                  : null,
          fillColor: field_color ?? Color(0xFF202020),
          filled: true,
          border: UnderlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(field_radius ?? 300)),
            borderSide: BorderSide.none,
          ),
          label: Text(field_label),
          hintText: '',
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
      ),
    );
  }
}
