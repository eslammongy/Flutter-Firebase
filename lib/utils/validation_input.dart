String? isValidUserInput({required String email, required String password}) {
  if (isEmail(email) && isValidPassword(password)) {
    return null;
  } else if (!isEmail(email)) {
    return "please make sure you enter an valid email !";
  } else if (!isValidPassword(password)) {
    return "please make sure you enter an valid password !";
  } else {
    return "please make sure you enter an valid credentials !";
  }
}

bool isEmail(String email) {
  if (email.isEmpty) {
    return false;
  }
  const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  final regex = RegExp(pattern);

  return regex.hasMatch(email);
}

bool isValidPhoneNumber(String phoneNumber) {
  if (phoneNumber.isEmpty) {
    return false;
  }
  const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
  final regExp = RegExp(pattern);

  if (!regExp.hasMatch(phoneNumber)) {
    return false;
  }
  return true;
}

bool isValidPassword(String value) {
  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (value.isEmpty) {
    return false;
  } else if (value.length <= 6) {
    return false;
  } else {
    return regex.hasMatch(value);
  }
}
