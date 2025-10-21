import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VoiceBuilderPageModel extends ChangeNotifier {
  ///  State fields for stateful widgets in this page.

  LatLng? currentLocation;
  Set<Marker> markers = {};

  @override
  void dispose() {
    super.dispose();
  }
}
