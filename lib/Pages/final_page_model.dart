import 'package:flutter/material.dart';
import '/flutter_flow/form_field_controller.dart';

class FinalPageModel extends ChangeNotifier {
  TextEditingController? textController;
  FocusNode? textFieldFocusNode;
  FormFieldController<String>? dropDownValueController;
  String? dropDownValue;

  String? Function(String?)? textControllerValidator;

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
    dropDownValueController?.dispose();
    super.dispose();
  }
}
