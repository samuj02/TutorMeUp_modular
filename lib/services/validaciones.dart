bool isValidEmail(String email) {
  String pattern =
      r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email);
}

bool isValidPhoneNumber(String phoneNumber) {
  return phoneNumber.isNotEmpty && RegExp(r'^[0-9]+$').hasMatch(phoneNumber);
}

bool isValidPassword(String password) {
  String pattern = r'^(?=.*[A-Z])(?=.*[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(password);
}
