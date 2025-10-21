import 'package:flutter/material.dart';

class CategoryLoginPageModel extends ChangeNotifier {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final emailTextController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordTextController = TextEditingController();
  final passwordFocusNode = FocusNode();

  String? selectedCategory;
  bool passwordVisibility = false;

  @override
  void dispose() {
    unfocusNode.dispose();
    emailTextController.dispose();
    emailFocusNode.dispose();
    passwordTextController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
}
