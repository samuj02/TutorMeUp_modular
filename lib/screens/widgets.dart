import 'package:flutter/material.dart';

// Para mostrar datos
Widget outPutRow(IconData icon, String label, String? value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 35.0),
        SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'SF-Pro-Rounded',
                fontSize: 14.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              value ?? 'No disponible',
              style: TextStyle(
                fontFamily: 'SF-Pro-Display',
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Para editar datos
Widget inputRow(IconData icon, String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 35.0),
        SizedBox(width: 20.0),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                fontFamily: 'SF-Pro-Rounded',
                fontSize: 14.0,
                fontWeight: FontWeight.w800,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
