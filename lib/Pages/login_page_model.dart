import 'package:flutter/material.dart';

class LoginPageModel extends ChangeNotifier {
  TextEditingController? emailAddressTextController;
  FocusNode? emailAddressFocusNode;
  TextEditingController? passwordTextController;
  FocusNode? passwordFocusNode;
  bool passwordVisibility = false;

  String? Function(String?)? emailAddressTextControllerValidator;
  String? Function(String?)? passwordTextControllerValidator;

  @override
  void dispose() {
    emailAddressTextController?.dispose();
    emailAddressFocusNode?.dispose();
    passwordTextController?.dispose();
    passwordFocusNode?.dispose();
    super.dispose();
  }
}
