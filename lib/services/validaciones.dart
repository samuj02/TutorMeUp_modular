import 'package:cloud_firestore/cloud_firestore.dart';

bool isValidEmail(String email) {
  String pattern =
      r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email);
}

bool isValidPhoneNumber(String phoneNumber) {
  return phoneNumber.length == 10 &&
      RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber);
}

bool isValidPassword(String password) {
  String pattern = r'^(?=.*[A-Z])(?=.*[!@#\$&*~+]).{8,}$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(password);
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<bool> checkEmailExists(String email) async {
  final QuerySnapshot result = await _firestore
      .collection('user')
      .where('email', isEqualTo: email)
      .get();
  final List<DocumentSnapshot> documents = result.docs;

  // Si hay documentos, significa que el correo ya está registrado
  return documents.isNotEmpty;
}
