import 'package:flutter/material.dart';

TextField buildCustomTextField({
  required TextEditingController controller,
  required String labelText,
  required String hintText,
  TextInputType keyboardType = TextInputType.text,
  IconData? prefixIcon,
  bool obscureText = false,
  void Function()? onIconPressed,
  int? maxLines,
  int? minLines,
  Color? colorTheme,
}) {
  return TextField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText && (maxLines == null || maxLines == 1),
    maxLines: obscureText ? 1 : maxLines,
    minLines: obscureText ? 1 : minLines,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
          fontFamily: 'SF-Pro-Text',
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
          color: colorTheme),
      hintText: hintText,
      filled: true,
      fillColor: Colors.transparent,
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              size: 35.0,
              color: colorTheme,
            )
          : null,
      suffixIcon: onIconPressed != null
          ? IconButton(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              icon: Icon(
                obscureText
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 35,
                color: colorTheme,
              ),
              onPressed: onIconPressed,
            )
          : null,
      contentPadding: EdgeInsets.only(left: 30.0, top: 24.0, bottom: 20.0),
      floatingLabelBehavior: FloatingLabelBehavior.always,

      // Borde del TextField
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),

      // Borde cuando no está enfocado
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(128, 0, 0, 0)),
        borderRadius: BorderRadius.circular(10.0),
      ),

      // Borde cuando está enfocado
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF004AAD)),
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    style: TextStyle(
        fontFamily: 'SF-Pro-Text', fontSize: 20.0, fontWeight: FontWeight.w600),
  );
}
