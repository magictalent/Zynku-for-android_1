import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'successful_page_model.dart';
export 'successful_page_model.dart';

class SuccessfulPageWidget extends StatefulWidget {
  const SuccessfulPageWidget({super.key});

  static String routeName = 'SuccessfulPage';
  static String routePath = '/successfulPage';

  @override
  State<SuccessfulPageWidget> createState() => _SuccessfulPageWidgetState();
}

class _SuccessfulPageWidgetState extends State<SuccessfulPageWidget> {
  late SuccessfulPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SuccessfulPageModel());
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
            Container(
              width: 422.2,
              height: 298.63,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/Screenshot_2.png',
                      width: 486.7,
                      height: 340,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, -1),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 150, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0, -1),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    60,
                                    0,
                                    0,
                                    0,
                                  ),
                                  child: Text(
                                    'Job Completed',
                                    style: FlutterFlowTheme.of(context)
                                        .displaySmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).displaySmall.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).displaySmall.fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(
                                            context,
                                          ).displaySmall.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).displaySmall.fontStyle,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                              'Successfully',
                              style: FlutterFlowTheme.of(context).displaySmall
                                  .override(
                                    font: GoogleFonts.interTight(
                                      fontWeight: FlutterFlowTheme.of(
                                        context,
                                      ).displaySmall.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(
                                        context,
                                      ).displaySmall.fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(
                                      context,
                                    ).displaySmall.fontWeight,
                                    fontStyle: FlutterFlowTheme.of(
                                      context,
                                    ).displaySmall.fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: AlignmentDirectional(-0.77, -0.67),
                    child: Text(
                      'Zynku',
                      style: FlutterFlowTheme.of(context).headlineSmall
                          .override(
                            font: GoogleFonts.interTight(
                              fontWeight: FlutterFlowTheme.of(
                                context,
                              ).headlineSmall.fontWeight,
                              fontStyle: FlutterFlowTheme.of(
                                context,
                              ).headlineSmall.fontStyle,
                            ),
                            color: FlutterFlowTheme.of(
                              context,
                            ).secondaryBackground,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(
                              context,
                            ).headlineSmall.fontWeight,
                            fontStyle: FlutterFlowTheme.of(
                              context,
                            ).headlineSmall.fontStyle,
                          ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.81, -0.67),
                    child: Icon(
                      Icons.wifi,
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 452.1,
              height: 558.9,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.06, -1.19),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Container(
                            width: 350,
                            height: 230.5,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(
                                context,
                              ).secondaryBackground,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(0),
                                          bottomRight: Radius.circular(0),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Container(
                                        width: 350,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(
                                            context,
                                          ).secondaryBackground,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(0),
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    0,
                                                    20,
                                                    0,
                                                    0,
                                                  ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          10,
                                                          0,
                                                          0,
                                                          0,
                                                        ),
                                                    child: Text(
                                                      'Orest\'s Plumbing',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).titleLarge.override(
                                                            font: GoogleFonts.interTight(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleLarge
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleLarge
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleLarge
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleLarge
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          60,
                                                          0,
                                                          0,
                                                          0,
                                                        ),
                                                    child: Text(
                                                      '\$75/h',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).titleLarge.override(
                                                            font: GoogleFonts.interTight(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleLarge
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleLarge
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleLarge
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleLarge
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    0,
                                                    20,
                                                    0,
                                                    0,
                                                  ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          12,
                                                          0,
                                                          0,
                                                          0,
                                                        ),
                                                    child: Text(
                                                      'Plumbing',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).titleMedium.override(
                                                            font: GoogleFonts.interTight(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleMedium
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional.fromSTEB(
                                                          100,
                                                          0,
                                                          0,
                                                          0,
                                                        ),
                                                    child: Text(
                                                      '14  Oct  2025',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).titleMedium.override(
                                                            font: GoogleFonts.interTight(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleMedium
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleMedium
                                                                    .fontStyle,
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
                                    Container(
                                      width: 350,
                                      height: 133.3,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(
                                          context,
                                        ).secondaryBackground,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(0),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Align(
                                            alignment: AlignmentDirectional(
                                              -1,
                                              -1,
                                            ),
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                    10,
                                                    30,
                                                    0,
                                                    0,
                                                  ),
                                              child: RatingBar.builder(
                                                onRatingUpdate: (newValue) =>
                                                    safeSetState(
                                                      () =>
                                                          _model.ratingBarValue =
                                                              newValue,
                                                    ),
                                                itemBuilder: (context, index) =>
                                                    Icon(
                                                      Icons.star_rounded,
                                                      color: Color(0xFFF9E100),
                                                    ),
                                                direction: Axis.horizontal,
                                                initialRating:
                                                    _model.ratingBarValue ??= 5,
                                                unratedColor:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).accent1,
                                                itemCount: 5,
                                                itemSize: 30,
                                                glowColor: Color(0xFFF9E100),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  0,
                                                  10,
                                                  0,
                                                  0,
                                                ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        8,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                  child: FFButtonWidget(
                                                    onPressed: () {
                                                      print(
                                                        'Button pressed ...',
                                                      );
                                                    },
                                                    text: 'On time',
                                                    options: FFButtonOptions(
                                                      width: 100,
                                                      height: 40,
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
                                                      color: Color(0xF5033EFF),
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).titleSmall.override(
                                                            font: GoogleFonts.interTight(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                      elevation: 0,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        5,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                  child: FFButtonWidget(
                                                    onPressed: () {
                                                      print(
                                                        'Button pressed ...',
                                                      );
                                                    },
                                                    text: 'Good Value',
                                                    options: FFButtonOptions(
                                                      width: 100,
                                                      height: 40,
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
                                                      color: Color(0xF5033EFF),
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).titleSmall.override(
                                                            font: GoogleFonts.interTight(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                      elevation: 0,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        5,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                  child: FFButtonWidget(
                                                    onPressed: () {
                                                      print(
                                                        'Button pressed ...',
                                                      );
                                                    },
                                                    text: 'Professional',
                                                    options: FFButtonOptions(
                                                      width: 100,
                                                      height: 40,
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
                                                      color: Color(0xF5033EFF),
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).titleSmall.override(
                                                            font: GoogleFonts.interTight(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleSmall
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .titleSmall
                                                                      .fontStyle,
                                                            ),
                                                            color: Colors.white,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleSmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .titleSmall
                                                                    .fontStyle,
                                                          ),
                                                      elevation: 0,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
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
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, -1),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-1, 0),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                    22,
                                    0,
                                    0,
                                    0,
                                  ),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      Navigator.pushNamed(
                                        context,
                                        '/booking-history',
                                      );
                                    },
                                    text: 'Receipt',
                                    options: FFButtonOptions(
                                      width: 170,
                                      height: 50,
                                      padding: EdgeInsetsDirectional.fromSTEB(
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
                                      ).secondaryBackground,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
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
                                            ).primaryText,
                                            fontSize: 22,
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).titleSmall.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).titleSmall.fontStyle,
                                          ),
                                      elevation: 8,
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(
                                          context,
                                        ).primaryText,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  10,
                                  0,
                                  0,
                                  0,
                                ),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    Navigator.pushNamed(context, '/plumbing');
                                  },
                                  text: 'Book Agian',
                                  options: FFButtonOptions(
                                    width: 170,
                                    height: 50,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      16,
                                      0,
                                      16,
                                      0,
                                    ),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0,
                                      0,
                                      0,
                                      0,
                                    ),
                                    color: Color(0xFF00B697),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FlutterFlowTheme.of(
                                              context,
                                            ).titleSmall.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(
                                              context,
                                            ).titleSmall.fontStyle,
                                          ),
                                          color: Colors.white,
                                          fontSize: 22,
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(
                                            context,
                                          ).titleSmall.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(
                                            context,
                                          ).titleSmall.fontStyle,
                                        ),
                                    elevation: 8,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: Container(
                          width: 350,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Color(0xFF07122A),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  50,
                                  0,
                                  0,
                                  0,
                                ),
                                child: Icon(
                                  Icons.home,
                                  color: FlutterFlowTheme.of(
                                    context,
                                  ).secondaryBackground,
                                  size: 26,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  45,
                                  0,
                                  0,
                                  0,
                                ),
                                child: Icon(
                                  Icons.watch_later_rounded,
                                  color: FlutterFlowTheme.of(
                                    context,
                                  ).secondaryBackground,
                                  size: 26,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  45,
                                  0,
                                  0,
                                  0,
                                ),
                                child: Icon(
                                  Icons.people_rounded,
                                  color: FlutterFlowTheme.of(
                                    context,
                                  ).secondaryBackground,
                                  size: 26,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                  45,
                                  0,
                                  0,
                                  0,
                                ),
                                child: Icon(
                                  Icons.person,
                                  color: FlutterFlowTheme.of(
                                    context,
                                  ).secondaryBackground,
                                  size: 26,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
