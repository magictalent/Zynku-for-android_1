import 'package:flutter/material.dart';

class CreateAccount1Model extends ChangeNotifier {
  TextEditingController? fullNameTextController;
  FocusNode? fullNameFocusNode;
  TextEditingController? emailAddressTextController;
  FocusNode? emailAddressFocusNode;
  TextEditingController? passwordTextController;
  FocusNode? passwordFocusNode;
  TextEditingController? passwordConfirmTextController;
  FocusNode? passwordConfirmFocusNode;
  bool passwordVisibility = false;
  bool passwordConfirmVisibility = false;

  String? Function(String?)? emailAddressTextControllerValidator;
  String? Function(String?)? passwordTextControllerValidator;
  String? Function(String?)? passwordConfirmTextControllerValidator;

  @override
  void dispose() {
    fullNameTextController?.dispose();
    fullNameFocusNode?.dispose();
    emailAddressTextController?.dispose();
    emailAddressFocusNode?.dispose();
    passwordTextController?.dispose();
    passwordFocusNode?.dispose();
    passwordConfirmTextController?.dispose();
    passwordConfirmFocusNode?.dispose();
    super.dispose();
  }
}
