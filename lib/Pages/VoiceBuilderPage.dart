import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/message_service.dart';

import 'voicebuilderpage_model.dart';
export 'voicebuilderpage_model.dart';

class VoiceBuilderPageWidget extends StatefulWidget {
  const VoiceBuilderPageWidget({super.key});

  static String routeName = 'VoiceBuilderPage';
  static String routePath = '/voice-builder';

  @override
  State<VoiceBuilderPageWidget> createState() => _VoiceBuilderPageWidgetState();
}

class _VoiceBuilderPageWidgetState extends State<VoiceBuilderPageWidget> {
  late VoiceBuilderPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  bool _speechEnabled = false;
  bool _isListening = false;
  String _recognizedText = '';
  String _statusText = 'Tap the microphone to start speaking';

  @override
  void initState() {
    super.initState();
    _model = VoiceBuilderPageModel();
    _initSpeech();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    _model.dispose();
    super.dispose();
  }

  // Initialize speech recognition
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  // Get current location
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

  // Start listening for speech
  void _startListening() async {
    if (!_speechEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Speech recognition not available')),
      );
      return;
    }

    // Request microphone permission
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Microphone permission denied')));
      return;
    }

    setState(() {
      _isListening = true;
      _statusText = 'Listening... Speak now';
    });

    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _recognizedText = result.recognizedWords;
          _textController.text = result.recognizedWords; // Update text field
          if (result.finalResult) {
            _isListening = false;
            _statusText = 'Tap the microphone to start speaking';
          }
        });
      },
      listenFor: Duration(seconds: 30),
      pauseFor: Duration(seconds: 3),
      partialResults: true,
      localeId: 'en_US',
      onSoundLevelChange: (level) {
        // You can use this to show audio level indicators
      },
    );
  }

  // Stop listening
  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
      _statusText = 'Tap the microphone to start speaking';
    });
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Voice Builder',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Inter Tight',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
          centerTitle: true,
          elevation: 2,
          actions: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 24),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          bottom: true,
          child: Column(
            children: [
              // Google Map Section (Top 40%)
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: FutureBuilder<Position>(
                    future: _getCurrentLocation(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Loading location...',
                                style: FlutterFlowTheme.of(context).titleMedium,
                              ),
                            ],
                          ),
                        );
                      }

                      if (snapshot.hasError) {
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
                                style: FlutterFlowTheme.of(context).titleMedium,
                              ),
                              Text(
                                'Error: ${snapshot.error}',
                                style: FlutterFlowTheme.of(context).bodyMedium,
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
                                        MediaQuery.of(context).size.width * 0.3,
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
                                        MediaQuery.of(context).size.width * 0.6,
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
                                        MediaQuery.of(context).size.width * 0.2,
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
                                        MediaQuery.of(context).size.width * 0.7,
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
              ),

              // Voice Recording Section (Bottom 60%)
              Expanded(
                flex: 6,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: Column(
                      children: [
                        // Text Input Section (Manual + Voice)
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(
                              context,
                            ).primaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter your message:',
                                style: FlutterFlowTheme.of(context).titleSmall
                                    .override(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),

                              // Manual Text Input
                              TextFormField(
                                controller: _textController,
                                focusNode: _textFocusNode,
                                minLines: 1,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  hintText:
                                      'Type your message here or use voice...',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        color: FlutterFlowTheme.of(
                                          context,
                                        ).secondaryText,
                                        fontStyle: FontStyle.italic,
                                      ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).alternate,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).alternate,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).primary,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: FlutterFlowTheme.of(
                                    context,
                                  ).secondaryBackground,
                                ),
                                style: FlutterFlowTheme.of(context).bodyMedium,
                                onChanged: (value) {
                                  setState(() {
                                    _recognizedText = value;
                                  });
                                },
                              ),

                              SizedBox(height: 8),

                              // Voice Recognition Status (only show if text was recognized from voice)
                              if (_recognizedText.isNotEmpty &&
                                  _textController.text == _recognizedText)
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(
                                      context,
                                    ).primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).primary.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.record_voice_over,
                                        color: FlutterFlowTheme.of(
                                          context,
                                        ).primary,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Voice recognized: ${_recognizedText}',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Status Text
                        Text(
                          _statusText,
                          style: FlutterFlowTheme.of(context).titleMedium
                              .override(
                                color: _isListening
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(
                                        context,
                                      ).secondaryText,
                              ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: 12),

                        // Voice Recording Button
                        GestureDetector(
                          onTap: _isListening
                              ? _stopListening
                              : _startListening,
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isListening
                                  ? FlutterFlowTheme.of(context).error
                                  : FlutterFlowTheme.of(context).primary,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8,
                                  color:
                                      (_isListening
                                              ? FlutterFlowTheme.of(
                                                  context,
                                                ).error
                                              : FlutterFlowTheme.of(
                                                  context,
                                                ).primary)
                                          .withOpacity(0.3),
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isListening ? Icons.stop : Icons.mic,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        // Action Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Clear Text Button
                            ElevatedButton.icon(
                              onPressed: _recognizedText.isNotEmpty
                                  ? () {
                                      setState(() {
                                        _recognizedText = '';
                                      });
                                    }
                                  : null,
                              icon: Icon(Icons.clear, size: 18),
                              label: Text('Clear'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: FlutterFlowTheme.of(
                                  context,
                                ).secondaryText,
                                foregroundColor: Colors.white,
                              ),
                            ),

                            // Send to Builders Button
                            ElevatedButton.icon(
                              onPressed: _textController.text.trim().isNotEmpty
                                  ? () async {
                                      try {
                                        final loc = _model.currentLocation;
                                        await MessageService.sendBuilderMessage(
                                          text: _textController.text.trim(),
                                          category: 'plumbing',
                                          latitude: loc?.latitude,
                                          longitude: loc?.longitude,
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('Sent to builders'),
                                          ),
                                        );
                                        setState(() {
                                          _recognizedText = '';
                                          _textController.clear();
                                        });
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text('Failed to send: $e'),
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              icon: Icon(Icons.send, size: 18),
                              label: Text('Send to Builders'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: FlutterFlowTheme.of(
                                  context,
                                ).primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
