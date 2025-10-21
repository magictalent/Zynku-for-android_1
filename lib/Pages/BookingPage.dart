import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/message_service.dart';

import 'booking_page_model.dart';
export 'booking_page_model.dart';

class BookingPageWidget extends StatefulWidget {
  final Map<String, dynamic>? customerData;

  const BookingPageWidget({super.key, this.customerData});

  static String routeName = 'BookingPage';
  static String routePath = '/bookingPage';

  @override
  State<BookingPageWidget> createState() => _BookingPageWidgetState();
}

class _BookingPageWidgetState extends State<BookingPageWidget> {
  late BookingPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BookingPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getUserDisplayName() {
    final user = _auth.currentUser;
    if (user != null) {
      return user.displayName ?? 'Builder';
    }
    return 'Builder';
  }

  LatLng? _getLocationCoordinates() {
    final location = widget.customerData?['location'];
    if (location == null) return null;

    if (location is GeoPoint) {
      return LatLng(location.latitude, location.longitude);
    } else if (location is Map<String, dynamic>) {
      final lat = location['latitude'] as double?;
      final lng = location['longitude'] as double?;
      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    }
    return null;
  }

  String? _formatLocation(dynamic location) {
    if (location == null) return null;

    if (location is String) {
      return location;
    } else if (location is GeoPoint) {
      return 'Lat: ${location.latitude.toStringAsFixed(4)}, Lng: ${location.longitude.toStringAsFixed(4)}';
    } else if (location is Map<String, dynamic>) {
      // Handle case where location might be stored as a map
      if (location.containsKey('latitude') &&
          location.containsKey('longitude')) {
        final lat = location['latitude'] as double?;
        final lng = location['longitude'] as double?;
        if (lat != null && lng != null) {
          return 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}';
        }
      }
    }

    return location.toString();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await MessageService.sendMessage(
        text: _messageController.text.trim(),
        category: 'plumbing',
        senderId: user.uid,
        senderName: _getUserDisplayName(),
        senderType: 'builder',
        customerId: widget.customerData?['customerId'],
      );

      _messageController.clear();

      // Scroll to bottom after sending message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send message: $e')));
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
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: true,
          title: Text(
            'Booking Details',
            style: FlutterFlowTheme.of(context).headlineSmall.override(
              fontFamily: 'Inter Tight',
              color: Colors.white,
              letterSpacing: 0,
            ),
          ),
          centerTitle: true,
          elevation: 2,
        ),
        body: Column(
          children: [
            // Customer Information Section
            Container(
              width: double.infinity,
              height:
                  160, // Further reduced height since we removed description
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Left side - Customer Details
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Header
                        Text(
                          'Customer Info',
                          style: FlutterFlowTheme.of(context).titleMedium
                              .override(
                                fontFamily: 'Inter Tight',
                                letterSpacing: 0,
                                fontSize: 16,
                              ),
                        ),
                        // Name row
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.customerData?['customerName'] ??
                                    'Customer Name',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      fontFamily: 'Inter Tight',
                                      letterSpacing: 0,
                                      fontSize: 14,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        // Phone row
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: FlutterFlowTheme.of(context).primary,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.customerData?['phone'] ??
                                    'Phone not provided',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      fontFamily: 'Inter Tight',
                                      letterSpacing: 0,
                                      fontSize: 14,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  // Right side - Google Map
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: FlutterFlowTheme.of(
                            context,
                          ).primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: _getLocationCoordinates() != null
                            ? GoogleMap(
                                onMapCreated: (GoogleMapController controller) {
                                  _mapController = controller;
                                },
                                initialCameraPosition: CameraPosition(
                                  target: _getLocationCoordinates()!,
                                  zoom: 15.0,
                                ),
                                markers: {
                                  Marker(
                                    markerId: MarkerId('customer_location'),
                                    position: _getLocationCoordinates()!,
                                    infoWindow: InfoWindow(
                                      title:
                                          widget
                                              .customerData?['customerName'] ??
                                          'Customer',
                                      snippet: 'Customer Location',
                                    ),
                                  ),
                                },
                                mapType: MapType.normal,
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,
                                scrollGesturesEnabled: true,
                                tiltGesturesEnabled: false,
                                rotateGesturesEnabled: false,
                              )
                            : Container(
                                color: FlutterFlowTheme.of(
                                  context,
                                ).primaryBackground,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.location_off,
                                        color: FlutterFlowTheme.of(
                                          context,
                                        ).secondaryText,
                                        size: 24,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'No Location',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Inter Tight',
                                              color: FlutterFlowTheme.of(
                                                context,
                                              ).secondaryText,
                                              fontSize: 10,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Chat Section
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Chat with Customer',
                      style: FlutterFlowTheme.of(context).headlineSmall
                          .override(
                            fontFamily: 'Inter Tight',
                            letterSpacing: 0,
                          ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: MessageService.streamBuilderMessages(
                          category: 'plumbing',
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error loading messages: ${snapshot.error}',
                              ),
                            );
                          }

                          final allDocs = snapshot.data?.docs ?? [];

                          // Filter messages for this specific customer conversation
                          final customerId = widget.customerData?['customerId'];
                          final docs = customerId != null
                              ? allDocs.where((doc) {
                                  final data = doc.data();
                                  final messageCustomerId =
                                      data['customerId'] as String?;
                                  return messageCustomerId == customerId;
                                }).toList()
                              : allDocs;

                          if (docs.isEmpty) {
                            return Center(
                              child: Text(
                                'No messages yet. Start the conversation!',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      fontFamily: 'Inter Tight',
                                      letterSpacing: 0,
                                    ),
                              ),
                            );
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final data = docs[index].data();
                              final text = data['text'] as String? ?? '';
                              final senderName =
                                  data['senderName'] as String? ?? 'Unknown';
                              final senderType =
                                  data['senderType'] as String? ?? 'customer';
                              final isBuilder = senderType == 'builder';

                              return Container(
                                margin: EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment: isBuilder
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    if (!isBuilder) ...[
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: FlutterFlowTheme.of(
                                          context,
                                        ).primary,
                                        child: Icon(
                                          Icons.person,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                    ],
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isBuilder
                                              ? FlutterFlowTheme.of(
                                                  context,
                                                ).primary
                                              : FlutterFlowTheme.of(
                                                  context,
                                                ).alternate,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (!isBuilder)
                                              Text(
                                                senderName,
                                                style:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.override(
                                                      fontFamily: 'Inter Tight',
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).primaryText,
                                                      letterSpacing: 0,
                                                      fontSize: 12,
                                                    ),
                                              ),
                                            Text(
                                              text,
                                              style:
                                                  FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                    fontFamily: 'Inter Tight',
                                                    color: isBuilder
                                                        ? Colors.white
                                                        : FlutterFlowTheme.of(
                                                            context,
                                                          ).primaryText,
                                                    letterSpacing: 0,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (isBuilder) ...[
                                      SizedBox(width: 8),
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: FlutterFlowTheme.of(
                                          context,
                                        ).secondary,
                                        child: Icon(
                                          Icons.build,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Message Input Section
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.black12,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  SizedBox(width: 12),
                  FloatingActionButton(
                    onPressed: _sendMessage,
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    child: Icon(Icons.send, color: Colors.white),
                    mini: true,
                  ),
                ],
              ),
            ),

            // Bottom Navigation
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color: Color(0xFF07122A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home, 'Home', () {
                    Navigator.pushNamed(context, '/');
                  }),
                  _buildNavItem(Icons.watch_later_rounded, 'Schedule', () {
                    // TODO: Implement schedule
                  }),
                  _buildNavItem(Icons.people_rounded, 'Jobs', () {
                    Navigator.pushNamed(context, '/plumbing');
                  }),
                  _buildNavItem(Icons.person_sharp, 'Profile', () {
                    Navigator.pushNamed(context, '/profile');
                    // TODO: Implement profile
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: FlutterFlowTheme.of(context).secondaryBackground,
            size: 26,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: FlutterFlowTheme.of(context).labelMedium.override(
              fontFamily: 'Inter Tight',
              color: FlutterFlowTheme.of(context).secondaryBackground,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
