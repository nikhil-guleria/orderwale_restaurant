

class Validations {
  static final Validations validations = Validations._internal();

  factory Validations() {
    return validations;
  }
  Validations._internal();

  bool isValidateEmail(String value) {
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex =  RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  String? validateEmail(value) {
    if(isValidateEmail(value.trim())) {
      return null;
    } else {
      return 'Please enter valid email';
    }
  }
  String?  validatePassword(value) {
    if(value.length > 5) {
      return null;
    } else {
      return 'Password must have 6 characters or above';
    }
  }

  String? validatePhone(value) {
    if (value.trim().length != 10) {
      return 'Please enter 10 digit number';
    }
    return null;
  }

  String? validateEmptyFields(value) {
    if(value.trim().isNotEmpty) {
      return null;
    } else {
      return "This field can't be empty";
    }
  }

  String? fieldCantEmpty(value){
    if(value.trim().isNotEmpty) {
      return null;
    } else {
      return "Field can't be empty";
    }
  }

  String? validateCoupon(value) {
    if(value.trim().isNotEmpty) {
      return null;
    } else {
      return "Enter usage time";
    }
  }




  String? validateEmptyCustomisationFields(value) {
    if(value.trim().isNotEmpty) {
      return null;
    } else {
      return "Enter Price";
    }
  }

  String? validateCharges(value) {
    if(value.trim().isNotEmpty && value.trim() != ".") {
      return null;
    } else {
      return 'Please enter valid value';
    }
  }

  String? validatePinCode(value) {
    if (value.trim().length != 6) {
      return 'Please enter 6 digit pin code';
    }
    return null;
  }

  String? validateCouponCode(value) {
    if(value.trim().length < 3) {
      return "The coupon code must be at least 3 characters";
    } else {
      return null;
    }
  }
  String? validateCouponDescription(value) {
    if(value.trim().length < 10) {
      return "The description must be at least 10 characters";
    } else {
      return null;
    }
  }

  }
