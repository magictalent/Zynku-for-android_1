import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/message_service.dart';
import '../services/user_profile_service.dart';

import 'plumbing_page_model.dart';
export 'plumbing_page_model.dart';

class PlumbingPageWidget extends StatefulWidget {
  const PlumbingPageWidget({super.key});

  static String routeName = 'PlumbingPage';
  static String routePath = '/plumbingPage';

  @override
  State<PlumbingPageWidget> createState() => _PlumbingPageWidgetState();
}

class _PlumbingPageWidgetState extends State<PlumbingPageWidget> {
  late PlumbingPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlumbingPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
          automaticallyImplyLeading: false,
          title: Text(
            'Builder Dashboard',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Inter Tight',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              // onSelected: (value) async {
              //   if (value == 'logout') {
              //     await FirebaseAuth.instance.signOut();
              //     Navigator.pushNamedAndRemoveUntil(
              //       context,
              //       '/login',
              //       (_) => false,
              //     );
              //   }
              // },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 8),
                      Text('Profile'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
            ),
          ],
          centerTitle: true,
          elevation: 2,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Message Panel - Half Screen
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Messages',
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
                            print(
                              '🔥 Firestore Stream Error: ${snapshot.error}',
                            );
                            return Center(
                              child: Text(
                                'Error loading messages: ${snapshot.error}',
                              ),
                            );
                          }

                          final allDocs =
                              List<
                                QueryDocumentSnapshot<Map<String, dynamic>>
                              >.from(snapshot.data?.docs ?? []);

                          // Filter out builder messages - only show customer messages
                          final docs = allDocs.where((doc) {
                            final data = doc.data();
                            final senderType = data['senderType'] as String?;
                            // Only show messages that are not from builders
                            return senderType != 'builder';
                          }).toList();

                          // Sort locally by createdAt desc; handle nulls safely
                          docs.sort((a, b) {
                            final av = a.data()['createdAt'];
                            final bv = b.data()['createdAt'];
                            final at = av is Timestamp
                                ? av.toDate()
                                : DateTime.fromMillisecondsSinceEpoch(0);
                            final bt = bv is Timestamp
                                ? bv.toDate()
                                : DateTime.fromMillisecondsSinceEpoch(0);
                            return bt.compareTo(at);
                          });
                          if (docs.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.message_outlined,
                                    size: 64,
                                    color: FlutterFlowTheme.of(
                                      context,
                                    ).secondaryText,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No customer messages yet',
                                    style: FlutterFlowTheme.of(
                                      context,
                                    ).bodyLarge,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Messages from customers will appear here',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).secondaryText,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: docs.length,
                            separatorBuilder: (_, __) => SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final data = docs[index].data();
                              final text = data['text'] as String? ?? '';
                              final created = data['createdAt'];
                              final location = data['location'];
                              final customerId = data['customerId'] as String?;
                              final customerName =
                                  data['customerName'] as String?;
                              final senderName = data['senderName'] as String?;

                              return Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(
                                    context,
                                  ).secondaryBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(
                                      context,
                                    ).alternate,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Colors.black12,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).primary,
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Customer Request',
                                          style: FlutterFlowTheme.of(context)
                                              .titleSmall
                                              .override(
                                                fontFamily: 'Inter Tight',
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0,
                                              ),
                                        ),
                                        Spacer(),
                                        if (location != null)
                                          Icon(
                                            Icons.location_on,
                                            color: FlutterFlowTheme.of(
                                              context,
                                            ).secondaryText,
                                            size: 16,
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      text,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Inter Tight',
                                            letterSpacing: 0,
                                          ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).secondaryText,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          created is Timestamp
                                              ? _formatTimestamp(
                                                  created.toDate(),
                                                )
                                              : 'Just now',
                                          style: FlutterFlowTheme.of(context)
                                              .labelMedium
                                              .override(
                                                fontFamily: 'Inter Tight',
                                                letterSpacing: 0,
                                              ),
                                        ),
                                        Spacer(),
                                        FFButtonWidget(
                                          onPressed: () async {
                                            // Navigate to booking page with customer data
                                            String displayName =
                                                customerName ??
                                                senderName ??
                                                'Customer';

                                            // Debug: Print what we have
                                            print(
                                              'Message data - customerName: $customerName, senderName: $senderName, customerId: $customerId',
                                            );

                                            // If we have a customerId but no name, try to get it from user profile
                                            if ((customerName == null &&
                                                    senderName == null) &&
                                                customerId != null) {
                                              try {
                                                print(
                                                  'Trying to get name for customerId: $customerId',
                                                );
                                                displayName =
                                                    await UserProfileService.getUserDisplayName(
                                                      customerId,
                                                    );
                                                print(
                                                  'Retrieved display name: $displayName',
                                                );
                                              } catch (e) {
                                                print(
                                                  'Error fetching customer name: $e',
                                                );
                                                displayName = 'Customer';
                                              }
                                            }

                                            print(
                                              'Final display name: $displayName',
                                            );

                                            final customerData = {
                                              'customerName': displayName,
                                              'location':
                                                  location, // Pass raw location data
                                              'phone':
                                                  '+1 234 567 8900', // You can get this from user data
                                              'description': text,
                                              'customerId': customerId,
                                            };
                                            Navigator.pushNamed(
                                              context,
                                              '/booking',
                                              arguments: customerData,
                                            );
                                          },
                                          text: 'Details',
                                          options: FFButtonOptions(
                                            width: 100,
                                            height: 32,
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  12,
                                                  0,
                                                  12,
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
                                            ).primary,
                                            textStyle:
                                                FlutterFlowTheme.of(
                                                  context,
                                                ).titleSmall.override(
                                                  fontFamily: 'Inter Tight',
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  letterSpacing: 0,
                                                ),
                                            elevation: 2,
                                            borderSide: BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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

            // Builder Name Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
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
              child: Column(
                children: [
                  Text(
                    _getUserDisplayName(),
                    style: FlutterFlowTheme.of(context).headlineLarge.override(
                      fontFamily: 'Inter Tight',
                      letterSpacing: 0,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Professional Plumbing Services',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter Tight',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0,
                    ),
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
                  _buildNavItem(Icons.chat_bubble, 'Chats', () {
                    Navigator.pushNamed(context, '/chats');
                    // TODO: Implement schedule
                  }),
                  _buildNavItem(Icons.people_rounded, 'Jobs', () {
                    // TODO: Implement jobs
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

  String _getUserDisplayName() {
    final user = _auth.currentUser;
    if (user != null) {
      // Try to get display name first
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        return user.displayName!;
      }
      // Fallback to email username (part before @)
      if (user.email != null) {
        return user.email!.split('@')[0];
      }
    }
    // Default fallback
    return 'Builder';
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
