import 'package:flutter/material.dart';

class ReviewPageModel extends ChangeNotifier {
  TextEditingController? textController1;
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController2;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController3;
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController4;
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController5;
  FocusNode? textFieldFocusNode5;

  String? Function(String?)? textController1Validator;
  String? Function(String?)? textController2Validator;
  String? Function(String?)? textController3Validator;
  String? Function(String?)? textController4Validator;
  String? Function(String?)? textController5Validator;

  @override
  void dispose() {
    textController1?.dispose();
    textFieldFocusNode1?.dispose();
    textController2?.dispose();
    textFieldFocusNode2?.dispose();
    textController3?.dispose();
    textFieldFocusNode3?.dispose();
    textController4?.dispose();
    textFieldFocusNode4?.dispose();
    textController5?.dispose();
    textFieldFocusNode5?.dispose();
    super.dispose();
  }
}
