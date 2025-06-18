
import 'package:shared_preferences/shared_preferences.dart';

class Validators
{
  static String? emailOrPhoneValidator(String? value) {
    if (value!.isEmpty) {
      return "Email or Mobile no. cannot be empty";
    } else if (!isNumeric(value)) {
      if (!RegExp(
          r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(value)) {
        return 'Enter a valid Email or Mobile no.';
      }
    } else {
      if (!RegExp(r'(^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$)').hasMatch(value)) {
        return 'Enter a valid Email or Mobile no.';
      }
    }

    return null;
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }


  static String? emailValidator(String? value) {

    if(value!.isEmpty)
      {

      }
    else
      {
        value=value.toLowerCase();
      }

    if (value!.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Email should be valid Email address.';
    }
    return null;
  }

  static String? checkPasswordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Password is required';
    }
    return null;
  }
  static String? checkPassword(String? value) {
    if (value!.isEmpty) {
      return 'Password is required';
    }
    else if(value.length<8)
      {
        return 'Must be at least 8 characters.';
      }
    return null;
  }
  static String? phoneValidator(String? value) {
    //^0[67][0-9]{8}$
    if (!RegExp(r'(^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$)').hasMatch(value!)) {
      return 'Please enter valid mobile number, it must be of 10 digits and begins with 6, 7, 8 or 9.';
    }
    return null;
  }

  static String? checkPincode(String? value) {
    if (value!.isEmpty) {
      return "Pin code is required";
    } else if (!RegExp(r'(^[1-9][0-9]{5}$)').hasMatch(value)) {
      return 'Invalid Pin code';
    }
    return null;
  }

  static String? checkName(String? value) {
    if (value!.isEmpty) {
      return "Name is required";
    } else if (value.length<3) {
      return 'Name should have at least 3 characters';
    }
    return null;
  }


  static String? checkEmptyString(String? value) {
    if (value!.isEmpty) {
      return "Cannot be left as empty!";
    }
    return null;
  }

  static String? checkSchoolName(String? value) {
    if (value!.isEmpty) {
      return "School name cannot be empty!";
    }
    return null;
  }


  static String? checkDate(String? value) {
    if (value!.isEmpty) {
      return "Please select date!";
    }
    return null;
  }
  static String? hasValidUrl(String? value) {
    String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = new RegExp(pattern);
    if (value!.length == 0) {
      return 'Please enter url';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid url';
    }
    return null;
  }
  static String? checkStartTime(String? value) {
    if (value!.isEmpty) {
      return "Please select class start time!";
    }
    return null;
  }

  static String? checkEndTime(String? value) {
    if (value!.isEmpty) {
      return "Please select class end time!";
    }
    return null;
  }

  static String? admissionNo(String? value) {
    if (value!.isEmpty) {
      return "Admission Number is required";
    }
    return null;
  }


}
