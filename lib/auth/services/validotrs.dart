class Validator {
  static bool checkEmpty(String? name, String? password,
      [String? passwordConfirm]) {
    if (name == null || password == null) {
      return false;
    }
    if (name.isEmpty || password.isEmpty) {
      return false;
    } else {
      if (passwordConfirm == null) {
        return false;
      } else {
        return true && passwordConfirm.isNotEmpty;
      }
    }
  }

  static bool checkAllInput(
      {required String? email,
      required String? name,
      required String? password,
      required String? passwordConfirm,
      required String? phone}) {
    if (name != null) {
      if (phone != null) {
        if (password != null) {
          if (passwordConfirm != null) {
            if (email != null) {
              return true;
            }
          }
        }
      }
    }
    return false;
  }

  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  /// Check if a phone number if valid or not.
  /// [phoneNumber] The phone number which will be validated.
  /// Return true if the phone number is valid. Otherwise, return false.
  static String? validPhoneNumber({required String? phone}) {
    // Null or empty string is invalid phone number
    if (phone == null || phone.isEmpty) {
      return 'Phone number can\'t be empty';
    }

    // You may need to change this pattern to fit your requirement.
    // I just copied the pattern from here: https://regexr.com/3c53v
    const pattern = r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(phone)) {
      return 'Enter a correct Phone number ';
    }
    return null;
  }

  static String? validateEmail({required String? email}) {
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password == null) {
      return null;
    }
    if (password.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Password length is at least 6';
    }

    return '';
  }

  static bool confirmPassword(
      {required String? password, required String? confirmPassword}) {
    if (password == confirmPassword) {
      return true;
    } else
      return false;
  }
}
