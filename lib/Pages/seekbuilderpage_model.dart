import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SeekbuilderpageModel extends ChangeNotifier {
  TextEditingController? textController1;
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController2;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController3;
  FocusNode? textFieldFocusNode3;
  TabController? tabBarController;

  double ratingBarValue1 = 0.0;
  double ratingBarValue2 = 0.0;
  double ratingBarValue3 = 0.0;
  double ratingBarValue4 = 0.0;
  double ratingBarValue5 = 0.0;
  double ratingBarValue6 = 0.0;
  double ratingBarValue7 = 0.0;
  double ratingBarValue8 = 0.0;
  double ratingBarValue9 = 0.0;

  String? Function(String?)? textController1Validator;
  String? Function(String?)? textController2Validator;
  String? Function(String?)? textController3Validator;

  // Google Maps variables
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng? currentLocation;
  bool isMapReady = false;

  @override
  void dispose() {
    textController1?.dispose();
    textFieldFocusNode1?.dispose();
    textController2?.dispose();
    textFieldFocusNode2?.dispose();
    textController3?.dispose();
    textFieldFocusNode3?.dispose();
    tabBarController?.dispose();
    super.dispose();
  }
}
