import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'listening_page_model.dart';
export 'listening_page_model.dart';

class ListeningPageWidget extends StatefulWidget {
  const ListeningPageWidget({super.key});

  static String routeName = 'ListeningPage';
  static String routePath = '/listeningPage';

  @override
  State<ListeningPageWidget> createState() => _ListeningPageWidgetState();
}

class _ListeningPageWidgetState extends State<ListeningPageWidget>
    with TickerProviderStateMixin {
  late ListeningPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListeningPageModel());

    // Animation setup removed - using standard Flutter animations instead
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                print('Requesting microphone permission...');
              },
              child: Container(
                width: 543.3,
                height: 935.42,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.09, -0.41),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 2,
                        shape: const CircleBorder(),
                        child: Container(
                          width: 155,
                          height: 155,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(
                              context,
                            ).secondaryBackground,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xEF3175FC),
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(30, 30, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(1, -1),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    0,
                                    3,
                                    0,
                                    0,
                                  ),
                                  child: Icon(
                                    Icons.record_voice_over_outlined,
                                    color: FlutterFlowTheme.of(
                                      context,
                                    ).primaryText,
                                    size: 40,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(1, -1),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    250,
                                    0,
                                    0,
                                    0,
                                  ),
                                  child: Icon(
                                    Icons.list,
                                    color: FlutterFlowTheme.of(
                                      context,
                                    ).primaryText,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.08, -0.41),
                      child: Container(
                        width: 155,
                        height: 155,
                        decoration: BoxDecoration(
                          color: Color(0xEF3175FC),
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: FaIcon(
                            FontAwesomeIcons.microphoneAlt,
                            color: FlutterFlowTheme.of(
                              context,
                            ).secondaryBackground,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.13, -0.01),
                      child: Text(
                        'Ready to listen...',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(
                              context,
                            ).bodyMedium.fontStyle,
                          ),
                          fontSize: 26,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          fontStyle: FlutterFlowTheme.of(
                            context,
                          ).bodyMedium.fontStyle,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.2, 0.22),
                      child: Lottie.asset(
                        'assets/jsons/Sound_voice_waves.json',
                        width: 304.8,
                        height: 210.1,
                        fit: BoxFit.contain,
                        animate: true,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.07, 0.56),
                      child: FFButtonWidget(
                        onPressed: () async {
                          Navigator.pushNamed(context, '/voice-help');
                        },
                        text: 'Cancel',
                        icon: Icon(Icons.camera_alt_outlined, size: 2),
                        options: FFButtonOptions(
                          width: 300,
                          height: 40,
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                            0,
                            0,
                            0,
                            0,
                          ),
                          color: FlutterFlowTheme.of(
                            context,
                          ).secondaryBackground,
                          textStyle: FlutterFlowTheme.of(context).titleSmall
                              .override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FlutterFlowTheme.of(
                                    context,
                                  ).titleSmall.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(
                                    context,
                                  ).titleSmall.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 22,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(
                                  context,
                                ).titleSmall.fontWeight,
                                fontStyle: FlutterFlowTheme.of(
                                  context,
                                ).titleSmall.fontStyle,
                              ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryText,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.07, 0.45),
                      child: FFButtonWidget(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        text: 'Attach photos (optional)',
                        icon: Icon(Icons.camera_alt_outlined, size: 27),
                        options: FFButtonOptions(
                          width: 300,
                          height: 40,
                          padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                            0,
                            0,
                            0,
                            0,
                          ),
                          color: FlutterFlowTheme.of(
                            context,
                          ).secondaryBackground,
                          textStyle: FlutterFlowTheme.of(context).titleSmall
                              .override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FlutterFlowTheme.of(
                                    context,
                                  ).titleSmall.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(
                                    context,
                                  ).titleSmall.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 18,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(
                                  context,
                                ).titleSmall.fontWeight,
                                fontStyle: FlutterFlowTheme.of(
                                  context,
                                ).titleSmall.fontStyle,
                              ),
                          elevation: 0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primaryText,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(8),
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
    );
  }
}
