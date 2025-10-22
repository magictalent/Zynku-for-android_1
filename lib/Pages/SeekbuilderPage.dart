import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'seekbuilderpage_model.dart';
export 'seekbuilderpage_model.dart';

class SeekbuilderpageWidget extends StatefulWidget {
  const SeekbuilderpageWidget({super.key});

  static String routeName = 'Seekbuilderpage';
  static String routePath = '/seekbuilderpage';

  @override
  State<SeekbuilderpageWidget> createState() => _SeekbuilderpageWidgetState();
}

class _SeekbuilderpageWidgetState extends State<SeekbuilderpageWidget>
    with TickerProviderStateMixin {
  late SeekbuilderpageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SeekbuilderpageModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  // Helper method to get current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 10),
    );
  }

  // Helper method to add plumber markers
  void _addPlumberMarkers() {
    if (_model.currentLocation == null) return;

    // Add some sample plumber locations around the current location
    final plumberLocations = [
      LatLng(
        _model.currentLocation!.latitude + 0.005,
        _model.currentLocation!.longitude + 0.005,
      ),
      LatLng(
        _model.currentLocation!.latitude - 0.003,
        _model.currentLocation!.longitude + 0.008,
      ),
      LatLng(
        _model.currentLocation!.latitude + 0.008,
        _model.currentLocation!.longitude - 0.002,
      ),
      LatLng(
        _model.currentLocation!.latitude - 0.006,
        _model.currentLocation!.longitude - 0.004,
      ),
    ];

    _model.markers.clear();

    // Add current location marker
    _model.markers.add(
      Marker(
        markerId: MarkerId('current_location'),
        position: _model.currentLocation!,
        infoWindow: InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );

    // Add plumber markers
    for (int i = 0; i < plumberLocations.length; i++) {
      _model.markers.add(
        Marker(
          markerId: MarkerId('plumber_$i'),
          position: plumberLocations[i],
          infoWindow: InfoWindow(
            title: 'Plumber ${i + 1}',
            snippet: 'Tap to view details',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 311.93,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Stack(
                children: [
                  // Google Map
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: FutureBuilder<Position>(
                      future: _getCurrentLocation(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text(
                                  'Loading map...',
                                  style: FlutterFlowTheme.of(
                                    context,
                                  ).titleMedium,
                                ),
                              ],
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          print('Location error: ${snapshot.error}');
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_off,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Unable to load location',
                                  style: FlutterFlowTheme.of(
                                    context,
                                  ).titleMedium,
                                ),
                                Text(
                                  'Error: ${snapshot.error}',
                                  style: FlutterFlowTheme.of(
                                    context,
                                  ).bodyMedium,
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  child: Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }

                        final position = snapshot.data!;
                        _model.currentLocation = LatLng(
                          position.latitude,
                          position.longitude,
                        );

                        print(
                          'Current location: ${position.latitude}, ${position.longitude}',
                        );

                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            children: [
                              // Map placeholder with location pins
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Stack(
                                  children: [
                                    // Background pattern
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.grey[200]!,
                                            Colors.grey[300]!,
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Location pins
                                    Positioned(
                                      left:
                                          MediaQuery.of(context).size.width *
                                          0.3,
                                      top:
                                          MediaQuery.of(context).size.height *
                                          0.15,
                                      child: Icon(
                                        Icons.location_on,
                                        color: Color(0xFF0948FB),
                                        size: 30,
                                      ),
                                    ),
                                    Positioned(
                                      left:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                      top:
                                          MediaQuery.of(context).size.height *
                                          0.2,
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 25,
                                      ),
                                    ),
                                    Positioned(
                                      left:
                                          MediaQuery.of(context).size.width *
                                          0.2,
                                      top:
                                          MediaQuery.of(context).size.height *
                                          0.25,
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 25,
                                      ),
                                    ),
                                    Positioned(
                                      left:
                                          MediaQuery.of(context).size.width *
                                          0.7,
                                      top:
                                          MediaQuery.of(context).size.height *
                                          0.3,
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 25,
                                      ),
                                    ),
                                    // Map unavailable message
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.map_outlined,
                                            size: 48,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Map Unavailable',
                                            style: FlutterFlowTheme.of(context)
                                                .titleMedium
                                                .override(
                                                  color: Colors.grey[700],
                                                ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Location services are working',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  color: Colors.grey[600],
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Location info overlay
                              Positioned(
                                bottom: 20,
                                left: 20,
                                right: 20,
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Color(0xFF0948FB),
                                            size: 20,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Current Location',
                                            style: FlutterFlowTheme.of(
                                              context,
                                            ).titleMedium,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Lat: ${position.latitude.toStringAsFixed(6)}',
                                        style: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium,
                                      ),
                                      Text(
                                        'Lng: ${position.longitude.toStringAsFixed(6)}',
                                        style: FlutterFlowTheme.of(
                                          context,
                                        ).bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Header with Zynku title and WiFi icon
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Text(
                      'Zynku',
                      style: FlutterFlowTheme.of(context).headlineMedium
                          .override(
                            font: GoogleFonts.interTight(
                              fontWeight: FlutterFlowTheme.of(
                                context,
                              ).headlineMedium.fontWeight,
                              fontStyle: FlutterFlowTheme.of(
                                context,
                              ).headlineMedium.fontStyle,
                            ),
                            fontSize: 28,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(
                              context,
                            ).headlineMedium.fontWeight,
                            fontStyle: FlutterFlowTheme.of(
                              context,
                            ).headlineMedium.fontStyle,
                          ),
                    ),
                  ),

                  Positioned(
                    top: 20,
                    right: 20,
                    child: Icon(
                      Icons.wifi,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 28,
                    ),
                  ),

                  // Search bar
                  Positioned(
                    top: 80,
                    left: 20,
                    right: 20,
                    child: Container(
                      width: double.infinity,
                      height: 49.23,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              10,
                              0,
                              0,
                              0,
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: Color(0xFF0948FB),
                              size: 30,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _model.textController1,
                              focusNode: _model.textFieldFocusNode1,
                              autofocus: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                labelStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(
                                          context,
                                        ).labelMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).labelMedium.fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(
                                        context,
                                      ).labelMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(
                                        context,
                                      ).labelMedium.fontStyle,
                                    ),
                                hintText: 'Plumbers near SW1A 1AA',
                                hintStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FlutterFlowTheme.of(
                                          context,
                                        ).titleMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(
                                          context,
                                        ).titleMedium.fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(
                                        context,
                                      ).titleMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(
                                        context,
                                      ).titleMedium.fontStyle,
                                    ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: FlutterFlowTheme.of(context).error,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: FlutterFlowTheme.of(
                                  context,
                                ).secondaryBackground,
                              ),
                              style: FlutterFlowTheme.of(context).bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(
                                        context,
                                      ).bodyMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(
                                        context,
                                      ).bodyMedium.fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(
                                      context,
                                    ).bodyMedium.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(
                                      context,
                                    ).bodyMedium.fontStyle,
                                  ),
                              cursorColor: FlutterFlowTheme.of(
                                context,
                              ).primaryText,
                              enableInteractiveSelection: true,
                              validator: _model.textController1Validator,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              0,
                              15,
                              0,
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.pen,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sort and Filter buttons
                  Positioned(
                    top: 150,
                    left: 20,
                    child: Container(
                      width: 84.05,
                      height: 42.7,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 8),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: TextFormField(
                        controller: _model.textController2,
                        focusNode: _model.textFieldFocusNode2,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Sort',
                          hintStyle: FlutterFlowTheme.of(context).titleMedium
                              .override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FlutterFlowTheme.of(
                                    context,
                                  ).titleMedium.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(
                                    context,
                                  ).titleMedium.fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(
                                  context,
                                ).titleMedium.fontWeight,
                                fontStyle: FlutterFlowTheme.of(
                                  context,
                                ).titleMedium.fontStyle,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(
                            context,
                          ).secondaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(
                              context,
                            ).bodyMedium.fontWeight,
                            fontStyle: FlutterFlowTheme.of(
                              context,
                            ).bodyMedium.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(
                            context,
                          ).bodyMedium.fontWeight,
                          fontStyle: FlutterFlowTheme.of(
                            context,
                          ).bodyMedium.fontStyle,
                        ),
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        enableInteractiveSelection: true,
                        validator: _model.textController2Validator,
                      ),
                    ),
                  ),

                  Positioned(
                    top: 150,
                    right: 20,
                    child: Container(
                      width: 66.86,
                      height: 42.9,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Color(0x33000000),
                            offset: Offset(0, 8),
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: TextFormField(
                        controller: _model.textController3,
                        focusNode: _model.textFieldFocusNode3,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Filter',
                          hintStyle: FlutterFlowTheme.of(context).titleMedium
                              .override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FlutterFlowTheme.of(
                                    context,
                                  ).titleMedium.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(
                                    context,
                                  ).titleMedium.fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(
                                  context,
                                ).titleMedium.fontWeight,
                                fontStyle: FlutterFlowTheme.of(
                                  context,
                                ).titleMedium.fontStyle,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(
                            context,
                          ).secondaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(
                              context,
                            ).bodyMedium.fontWeight,
                            fontStyle: FlutterFlowTheme.of(
                              context,
                            ).bodyMedium.fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(
                            context,
                          ).bodyMedium.fontWeight,
                          fontStyle: FlutterFlowTheme.of(
                            context,
                          ).bodyMedium.fontStyle,
                        ),
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        enableInteractiveSelection: true,
                        validator: _model.textController3Validator,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      // --- TabBar header ---
                      TabBar(
                        labelColor: FlutterFlowTheme.of(context).primaryText,
                        unselectedLabelColor: FlutterFlowTheme.of(
                          context,
                        ).secondaryText,
                        indicatorColor: FlutterFlowTheme.of(context).primary,
                        tabs: const [
                          Tab(text: 'Cheapest'),
                          Tab(text: 'Best Rated'),
                          Tab(text: 'Closest'),
                        ],
                      ),
                      // --- Tab content ---
                      Expanded(
                        child: TabBarView(
                          children: [
                            // Cheapest
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  _buildServiceCard(
                                    context,
                                    title: "Affordable Plumbing",
                                    price: "\$40/h",
                                    time: "25 min",
                                    distance: "1.1 mile",
                                    rating: 4,
                                  ),
                                  _buildServiceCard(
                                    context,
                                    title: "Metro Plumbers",
                                    price: "\$42/h",
                                    time: "42 min",
                                    distance: "2.5 mile",
                                    rating: 5,
                                  ),
                                ],
                              ),
                            ),
                            // Best Rated
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  _buildServiceCard(
                                    context,
                                    title: "BestFlow Services",
                                    price: "\$50/h",
                                    time: "30 min",
                                    distance: "1.8 mile",
                                    rating: 5,
                                  ),
                                ],
                              ),
                            ),
                            // Closest
                            SingleChildScrollView(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  _buildServiceCard(
                                    context,
                                    title: "QuickFix Plumbing",
                                    price: "\$45/h",
                                    time: "20 min",
                                    distance: "0.8 mile",
                                    rating: 4.5,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String price,
    required String time,
    required String distance,
    required double rating,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: const Color(0x33000000),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: FlutterFlowTheme.of(context).titleMedium,
                ),
              ),
              Text(
                price,
                style: FlutterFlowTheme.of(context).titleMedium.override(
                  color: FlutterFlowTheme.of(context).primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              const SizedBox(width: 4),
              Text(time, style: FlutterFlowTheme.of(context).bodyMedium),
              const SizedBox(width: 16),
              Icon(
                Icons.location_on,
                size: 16,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
              const SizedBox(width: 4),
              Text(distance, style: FlutterFlowTheme.of(context).bodyMedium),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < rating.floor()
                      ? Icons.star
                      : index < rating
                      ? Icons.star_half
                      : Icons.star_border,
                  size: 16,
                  color: Colors.amber,
                );
              }),
              const SizedBox(width: 8),
              Text(
                rating.toString(),
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
