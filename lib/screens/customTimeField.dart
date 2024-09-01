import 'package:flutter/material.dart';

class TimeField extends StatelessWidget {
  final String labelText;
  final TimeOfDay? time;
  final void Function() onTap;

  const TimeField({
    Key? key,
    required this.labelText,
    required this.time,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontSize: 20.0,
            fontWeight: FontWeight.w900,
            color: Color(0xFF004AAD),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(128, 0, 0, 0)),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF004AAD)),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          time != null ? time!.format(context) : 'Seleccionar hora',
          style: TextStyle(
            fontFamily: 'SF-Pro-Text',
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
