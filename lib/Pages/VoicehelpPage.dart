import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'voicepage_model.dart';
export 'voicepage_model.dart';

class VoicepageWidget extends StatefulWidget {
  const VoicepageWidget({super.key});

  static String routeName = 'voicepage';
  static String routePath = '/voicepage';

  @override
  State<VoicepageWidget> createState() => _VoicepageWidgetState();
}

class _VoicepageWidgetState extends State<VoicepageWidget> {
  late VoicepageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VoicepageModel());

    _model.textFieldTextController ??= TextEditingController(
      text: 'Manchester',
    );
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      // Check if location services are enabled
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
          'Location services are disabled. Please enable location services.',
        );
      }

      // Check permission
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception(
            'Location permissions are denied. Please allow location access.',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied. Please enable location access in app settings.',
        );
      }

      // Get current location with timeout
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
    } catch (e) {
      print('Location error: $e');
      rethrow;
    }
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
        appBar: AppBar(
          title: Text('Voice Help'),
          backgroundColor: FlutterFlowTheme.of(context).primary,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  // Trigger rebuild to refresh location
                });
              },
              tooltip: 'Refresh Location',
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height:
                        MediaQuery.of(context).size.height *
                        0.33, // One third of screen
                    child: FutureBuilder<Position>(
                      future: _determinePosition(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Getting your location...'),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_off,
                                    size: 64,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Location Error',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${snapshot.error}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        // Trigger rebuild to retry location
                                      });
                                    },
                                    child: Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (!snapshot.hasData) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_searching,
                                  size: 64,
                                  color: Colors.orange,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Unable to fetch location',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }

                        final position = snapshot.data!;
                        final LatLng currentLocation = LatLng(
                          position.latitude,
                          position.longitude,
                        );

                        print(
                          'Current location: ${position.latitude}, ${position.longitude}',
                        );

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: currentLocation,
                                zoom: 15,
                              ),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              onMapCreated: (GoogleMapController controller) {
                                print('Map created successfully');
                              },
                              markers: {
                                Marker(
                                  markerId: const MarkerId('currentLocation'),
                                  position: currentLocation,
                                  infoWindow: InfoWindow(
                                    title: 'You are here',
                                    snippet:
                                        'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}',
                                  ),
                                ),
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Location display widget
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  child: FutureBuilder<Position>(
                    future: _determinePosition(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Getting location...'),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Row(
                          children: [
                            Icon(
                              Icons.location_off,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Location unavailable: ${snapshot.error}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasData) {
                        final position = snapshot.data!;
                        return Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Location',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return const Text('Location not available');
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        33,
                                        0,
                                        0,
                                        0,
                                      ),
                                      child: Text(
                                        'What do you need today',
                                        style: FlutterFlowTheme.of(context)
                                            .displayMedium
                                            .override(
                                              fontFamily:
                                                  GoogleFonts.interTight()
                                                      .fontFamily,
                                              fontSize: 30,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      85,
                                      10,
                                      0,
                                      0,
                                    ),
                                    child: Text(
                                      '(e.g."Book a cab to Heathrow"',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily:
                                                GoogleFonts.inter().fontFamily,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      90,
                                      0,
                                      0,
                                      0,
                                    ),
                                    child: Text(
                                      'or "Find a plumber near me")',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily:
                                                GoogleFonts.inter().fontFamily,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 398.6,
                                height: 158.08,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(
                                    context,
                                  ).secondaryBackground,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional(0, -1),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional(
                                              0,
                                              -1,
                                            ),
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    30,
                                                    20,
                                                    0,
                                                    0,
                                                  ),
                                              child: FFButtonWidget(
                                                onPressed: () async {
                                                  Navigator.pushNamed(
                                                    context,
                                                    '/voice-builder',
                                                  );
                                                },
                                                text: 'Builder',
                                                icon: FaIcon(
                                                  FontAwesomeIcons.hammer,
                                                  size: 26,
                                                ),
                                                options: FFButtonOptions(
                                                  width: 155,
                                                  height: 55,
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        16,
                                                        0,
                                                        16,
                                                        0,
                                                      ),
                                                  iconPadding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                  color: Color(0xFFFB6522),
                                                  textStyle:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).titleSmall.override(
                                                        fontFamily:
                                                            GoogleFonts.interTight()
                                                                .fontFamily,
                                                        color: Colors.white,
                                                        fontSize: 22,
                                                        letterSpacing: 0.0,
                                                      ),
                                                  elevation: 10,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  20,
                                                  20,
                                                  0,
                                                  0,
                                                ),
                                            child: FFButtonWidget(
                                              onPressed: () {
                                                print('Button pressed ...');
                                              },
                                              text: 'Cab',
                                              icon: FaIcon(
                                                FontAwesomeIcons.carAlt,
                                                size: 26,
                                              ),
                                              options: FFButtonOptions(
                                                width: 155,
                                                height: 55,
                                                padding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      16,
                                                      0,
                                                      16,
                                                      0,
                                                    ),
                                                iconPadding:
                                                    EdgeInsetsDirectional.fromSTEB(
                                                      0,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).warning,
                                                textStyle:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).titleSmall.override(
                                                      fontFamily:
                                                          GoogleFonts.interTight()
                                                              .fontFamily,
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).primaryText,
                                                      fontSize: 22,
                                                      letterSpacing: 0.0,
                                                    ),
                                                elevation: 10,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                30,
                                                10,
                                                0,
                                                0,
                                              ),
                                          child: FFButtonWidget(
                                            onPressed: () {
                                              print('Button pressed ...');
                                            },
                                            text: 'Rental',
                                            icon: FaIcon(
                                              FontAwesomeIcons.houseUser,
                                              size: 26,
                                            ),
                                            options: FFButtonOptions(
                                              width: 155,
                                              height: 55,
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    16,
                                                    0,
                                                    16,
                                                    0,
                                                  ),
                                              iconPadding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              color: FlutterFlowTheme.of(
                                                context,
                                              ).secondary,
                                              textStyle:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).titleSmall.override(
                                                    fontFamily:
                                                        GoogleFonts.interTight()
                                                            .fontFamily,
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    letterSpacing: 0.0,
                                                  ),
                                              elevation: 10,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                20,
                                                10,
                                                0,
                                                0,
                                              ),
                                          child: FFButtonWidget(
                                            onPressed: () {
                                              print('Button pressed ...');
                                            },
                                            text: 'Finance',
                                            icon: Icon(
                                              Icons.monetization_on,
                                              size: 26,
                                            ),
                                            options: FFButtonOptions(
                                              width: 155,
                                              height: 55,
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    16,
                                                    0,
                                                    16,
                                                    0,
                                                  ),
                                              iconPadding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    0,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                              color: FlutterFlowTheme.of(
                                                context,
                                              ).success,
                                              textStyle:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).titleSmall.override(
                                                    fontFamily:
                                                        GoogleFonts.interTight()
                                                            .fontFamily,
                                                    color: Colors.white,
                                                    fontSize: 22,
                                                    letterSpacing: 0.0,
                                                  ),
                                              elevation: 10,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  10,
                                  0,
                                  0,
                                ),
                                child: Container(
                                  width: 326.2,
                                  height: 58.91,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF07122A),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          40,
                                          0,
                                          0,
                                          0,
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            Navigator.pushNamed(context, '/');
                                          },
                                          child: Icon(
                                            Icons.home,

                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).secondaryBackground,

                                            size: 26,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          40,
                                          0,
                                          0,
                                          0,
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            Navigator.pushNamed(
                                              context,
                                              '/chats',
                                            );
                                          },
                                          child: Icon(
                                            Icons.message,

                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).secondaryBackground,

                                            size: 26,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          40,
                                          0,
                                          0,
                                          0,
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            Navigator.pushNamed(
                                              context,
                                              '/maps',
                                            );
                                          },
                                          child: Icon(
                                            Icons.person_pin_circle_sharp,

                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).secondaryBackground,

                                            size: 26,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          40,
                                          0,
                                          0,
                                          0,
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            Navigator.pushNamed(
                                              context,
                                              '/profile',
                                            );
                                          },
                                          child: Icon(
                                            Icons.person,

                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).secondaryBackground,

                                            size: 26,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Align(
            //   alignment: AlignmentDirectional(-1, 0),
            //   child: Stack(
            //     children: [
            //       Align(
            //         alignment: AlignmentDirectional(0.06, -0.33),
            //         child: InkWell(
            //           splashColor: Colors.transparent,
            //           focusColor: Colors.transparent,
            //           hoverColor: Colors.transparent,
            //           highlightColor: Colors.transparent,
            //           onTap: () async {
            //             Navigator.pushNamed(context, '/listening');
            //           },
            //           child: Container(
            //             width: 130,
            //             height: 130,
            //             decoration: BoxDecoration(
            //               color: Color(0xFF1177FF),
            //               boxShadow: [
            //                 BoxShadow(
            //                   blurRadius: 30,
            //                   color: Color(0x33000000),
            //                   offset: Offset(0, 8),
            //                 ),
            //               ],
            //               shape: BoxShape.circle,
            //             ),
            //             child: Align(
            //               alignment: AlignmentDirectional(0, 0),
            //               child: FaIcon(
            //                 FontAwesomeIcons.microphoneAlt,
            //                 color: FlutterFlowTheme.of(
            //                   context,
            //                 ).secondaryBackground,
            //                 size: 60,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
