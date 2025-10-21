import 'package:flutter/material.dart';
import '/flutter_flow/form_field_controller.dart';

class VoicepageModel extends ChangeNotifier {
  TextEditingController? textFieldTextController;
  FocusNode? textFieldFocusNode;
  FormFieldController<String>? dropDownValueController;
  String? dropDownValue;

  String? Function(String?)? textFieldTextControllerValidator;

  @override
  void dispose() {
    textFieldTextController?.dispose();
    textFieldFocusNode?.dispose();
    dropDownValueController?.dispose();
    super.dispose();
  }
}
