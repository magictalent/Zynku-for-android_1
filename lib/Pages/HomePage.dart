import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
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
            Flexible(
              child: Container(
                width: 397.6,
                height: 321.12,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/vnimc_1.png',
                        width: 408.72,
                        height: 340.9,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(1, -1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 20, 0),
                        child: Icon(
                          Icons.wifi,
                          color: FlutterFlowTheme.of(
                            context,
                          ).secondaryBackground,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsetsDirectional.fromSTEB(75, 0, 0, 0),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.max,
            //     children: [
            //       Align(
            //         alignment: AlignmentDirectional(0, -1),
            //         child: Padding(
            //           padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
            //           child: Text(
            //             'Hey Zynku!',
            //             style: FlutterFlowTheme.of(context).displayMedium
            //                 .override(
            //                   font: GoogleFonts.interTight(
            //                     fontWeight: FlutterFlowTheme.of(
            //                       context,
            //                     ).displayMedium.fontWeight,
            //                     fontStyle: FlutterFlowTheme.of(
            //                       context,
            //                     ).displayMedium.fontStyle,
            //                   ),
            //                   fontSize: 50,
            //                   letterSpacing: 0.0,
            //                   fontWeight: FlutterFlowTheme.of(
            //                     context,
            //                   ).displayMedium.fontWeight,
            //                   fontStyle: FlutterFlowTheme.of(
            //                     context,
            //                   ).displayMedium.fontStyle,
            //                 ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 30, 0, 0),
                  child: Text(
                    'One Voice, One Commuinity.',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FlutterFlowTheme.of(
                          context,
                        ).titleSmall.fontWeight,
                        fontStyle: FlutterFlowTheme.of(
                          context,
                        ).titleSmall.fontStyle,
                      ),
                      fontSize: 20,
                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(
                        context,
                      ).titleSmall.fontWeight,
                      fontStyle: FlutterFlowTheme.of(
                        context,
                      ).titleSmall.fontStyle,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28.0),
                    child: Image.asset(
                      'assets/images/mark.png',
                      height: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      Navigator.pushNamed(context, '/board-slide-show');
                    },
                    text: 'Get Started',
                    icon: Icon(Icons.room, size: 20),
                    options: FFButtonOptions(
                      width: 300,
                      height: 60,
                      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: Color(0xFF0048FB),
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
                            color: FlutterFlowTheme.of(
                              context,
                            ).primaryBackground,
                            fontSize: 20,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(
                              context,
                            ).titleSmall.fontWeight,
                            fontStyle: FlutterFlowTheme.of(
                              context,
                            ).titleSmall.fontStyle,
                          ),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
