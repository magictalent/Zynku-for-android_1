import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserdetailsWidget extends StatefulWidget {
  const UserdetailsWidget({super.key});

  static String routeName = 'Userdetails';
  static String routePath = 'profile';

  @override
  State<UserdetailsWidget> createState() => _UserdetailsWidgetState();
}

class _UserdetailsWidgetState extends State<UserdetailsWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
        backgroundColor: Color(0xFFF5F8F9),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
            child: Text(
              'Profile',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 400,
                        decoration: BoxDecoration(),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            Image.asset(
                              'assets/images/avatar_woman.png',
                              width: double.infinity,
                              height: 385,
                              fit: BoxFit.cover,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 4,
                                      sigmaY: 4,
                                    ),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 90,
                                      constraints: BoxConstraints(
                                        maxHeight: 90,
                                        minHeight: 90,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0x63F4F4F4),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  0,
                                                  5,
                                                  0,
                                                  5,
                                                ),
                                            child: Container(
                                              width:
                                                  MediaQuery.sizeOf(
                                                    context,
                                                  ).width *
                                                  0.9,
                                              constraints: BoxConstraints(
                                                maxHeight: 80,
                                              ),
                                              decoration: BoxDecoration(),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Demo',
                                                    style:
                                                        GoogleFonts.montserrat(
                                                          color: Color(
                                                            0xFF021C27,
                                                          ),
                                                          fontSize: 32,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional.fromSTEB(
                                                                0,
                                                                0,
                                                                5,
                                                                0,
                                                              ),
                                                          child: Icon(
                                                            Icons.star_rounded,
                                                            color: Color(
                                                              0xFFFDB861,
                                                            ),
                                                            size: 20,
                                                          ),
                                                        ),
                                                        Text(
                                                          '5',
                                                          style:
                                                              GoogleFonts.montserrat(
                                                                color: Color(
                                                                  0xFF021C27,
                                                                ),
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional.fromSTEB(
                                                                20,
                                                                0,
                                                                0,
                                                                0,
                                                              ),
                                                          child: Container(
                                                            height: 15,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Color(
                                                                    0xFF021C27,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                    10,
                                                                    0,
                                                                    10,
                                                                    0,
                                                                  ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'Plumber',
                                                                    style: GoogleFonts.montserrat(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          10,
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
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 10,
                                        color: Color(0x33C8C8C8),
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width:
                                                  MediaQuery.sizeOf(
                                                    context,
                                                  ).width *
                                                  0.9,
                                              decoration: BoxDecoration(),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional.fromSTEB(
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  15,
                                                                ),
                                                            child: SelectionArea(
                                                              child: Text(
                                                                'STATUS',
                                                                style: GoogleFonts.montserrat(
                                                                  color: Colors
                                                                      .grey[600],
                                                                  fontSize: 10,
                                                                  letterSpacing:
                                                                      1,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 25,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Color(
                                                                    0x82BBF7D0,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                    10,
                                                                    0,
                                                                    10,
                                                                    0,
                                                                  ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'Active',
                                                                    style: GoogleFonts.montserrat(
                                                                      color: Color(
                                                                        0xFF009D36,
                                                                      ),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 40,
                                                        child: VerticalDivider(
                                                          width: 30,
                                                          thickness: 1,
                                                          indent: 1,
                                                          endIndent: 1,
                                                          color: Color(
                                                            0xFFC0C0C0,
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional.fromSTEB(
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  15,
                                                                ),
                                                            child: SelectionArea(
                                                              child: Text(
                                                                'DEPARTMENT',
                                                                style: GoogleFonts.montserrat(
                                                                  color: Colors
                                                                      .grey[600],
                                                                  fontSize: 10,
                                                                  letterSpacing:
                                                                      1,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 25,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Color(
                                                                    0x81C7D2FE,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional.fromSTEB(
                                                                    10,
                                                                    0,
                                                                    10,
                                                                    0,
                                                                  ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Text(
                                                                    'Fixing',
                                                                    style: GoogleFonts.montserrat(
                                                                      color: Color(
                                                                        0xFF062497,
                                                                      ),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional.fromSTEB(
                                                              30,
                                                              0,
                                                              0,
                                                              0,
                                                            ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                IconButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .file_present,
                                                                    color: Color(
                                                                      0xFF487CF6,
                                                                    ),
                                                                    size: 30,
                                                                  ),
                                                                  onPressed: () {
                                                                    // Resume button pressed
                                                                  },
                                                                ),
                                                                Text(
                                                                  'Resume',
                                                                  style: GoogleFonts.montserrat(
                                                                    color: Color(
                                                                      0xFF487CF6,
                                                                    ),
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
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
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.9,
                              decoration: BoxDecoration(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0, 0.15),
                              child: SelectionArea(
                                child: Text(
                                  'Recruitment Process',
                                  style: GoogleFonts.montserrat(
                                    color: Color(0xFF021C27),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0,
                                30,
                                0,
                                0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SelectionArea(
                                        child: Text(
                                          'COMPLETED',
                                          style: GoogleFonts.montserrat(
                                            color: Color(0xFFA9C2CC),
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          12,
                                          0,
                                          0,
                                        ),
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFF1F4F8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '70%',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                color: Color(0xFF021C27),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SelectionArea(
                                        child: Text(
                                          'REVIEWS',
                                          style: GoogleFonts.montserrat(
                                            color: Color(0xFFA9C2CC),
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          12,
                                          0,
                                          0,
                                        ),
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFF1F4F8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '80%',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                color: Color(0xFF021C27),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SelectionArea(
                                        child: Text(
                                          'EVERYDAY LOGIN',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.montserrat(
                                            color: Color(0xFFA9C2CC),
                                            fontSize: 10,
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                          0,
                                          12,
                                          0,
                                          0,
                                        ),
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFF1F4F8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '90%',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.montserrat(
                                                color: Color(0xFF021C27),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
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
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 80,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(30, 0, 30, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0,
                                0,
                                20,
                                0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last Task Done',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Sep. 30 2025 2:30 pm',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              // Edit button pressed
                            },
                            icon: Icon(Icons.edit_square, size: 15),
                            label: Text('Edit'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF969696),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              textStyle: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                              shape: RoundedRectangleBorder(
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
            ],
          ),
        ),
        // bottomNavigationBar: CustomBottomNavigationBar(
        //   currentIndex: 3, // Profile page index
        //   onTap: (index) {
        //     // Navigation is handled in the CustomBottomNavigationBar
        //   },
        // ),
      ),
    );
  }
}
