import 'package:flutter/material.dart';

class CategorySignupPageModel extends ChangeNotifier {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final emailTextController = TextEditingController();
  final emailFocusNode = FocusNode();
  final phoneTextController = TextEditingController();
  final phoneFocusNode = FocusNode();
  final passwordTextController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final confirmPasswordTextController = TextEditingController();
  final confirmPasswordFocusNode = FocusNode();

  String? selectedCategory;
  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;

  @override
  void dispose() {
    unfocusNode.dispose();
    emailTextController.dispose();
    emailFocusNode.dispose();
    phoneTextController.dispose();
    phoneFocusNode.dispose();
    passwordTextController.dispose();
    passwordFocusNode.dispose();
    confirmPasswordTextController.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }
}
