import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../auth/firebase_auth_service.dart';
import '../auth/user_type_service.dart';
import 'categorysignuppage_model.dart';
export 'categorysignuppage_model.dart';

class CategorySignupPageWidget extends StatefulWidget {
  const CategorySignupPageWidget({super.key});

  static String routeName = 'CategorySignupPage';
  static String routePath = '/category-signup';

  @override
  State<CategorySignupPageWidget> createState() =>
      _CategorySignupPageWidgetState();
}

class _CategorySignupPageWidgetState extends State<CategorySignupPageWidget> {
  late CategorySignupPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = CategorySignupPageModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Handle signup based on category
  Future<void> _handleSignup(String category) async {
    final email = _model.emailTextController.text;
    final phone = _model.phoneTextController.text;
    final password = _model.passwordTextController.text;
    final confirmPassword = _model.confirmPasswordTextController.text;

    if (email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      print('Attempting to sign up with email: $email');
      print('Selected category: $category');

      await FirebaseAuthService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.of(context).pop(); // Close loading dialog

      // Set user type and redirect based on category
      UserTypeService.setUserType(category);
      String redirectPath = _getRedirectPathForCategory(category);

      print('Signup successful, redirecting to: $redirectPath');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Account created successfully!')));

      Navigator.pushReplacementNamed(context, redirectPath);
    } catch (e) {
      Navigator.of(context).pop(); // Close loading dialog
      print('Signup error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup failed: $e')));
    }
  }

  String _getRedirectPathForCategory(String category) {
    switch (category) {
      case 'builder':
        return '/plumbing';
      case 'tab':
        return '/voice-help';
      case 'rental':
        return '/voice-help'; // You can change this to a rental-specific page
      case 'finance':
        return '/voice-help'; // You can change this to a finance-specific page
      default:
        return '/voice-help';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Category Signup',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
          centerTitle: true,
          elevation: 2,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Welcome Text
                Text(
                  'Create Your Account',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                    fontFamily: 'Outfit',
                    letterSpacing: 0,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Select your category and create your account',
                  style: FlutterFlowTheme.of(
                    context,
                  ).bodyMedium.override(fontFamily: 'Outfit', letterSpacing: 0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),

                // Category Selection
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryCard(
                        context,
                        title: 'Tab',
                        icon: FontAwesomeIcons.house,
                        color: Color(0xFF4CAF50),
                        onTap: () {
                          setState(() {
                            _model.selectedCategory = 'tab';
                          });
                        },
                        isSelected: _model.selectedCategory == 'tab',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildCategoryCard(
                        context,
                        title: 'Builder',
                        icon: FontAwesomeIcons.hammer,
                        color: Color(0xFFFF9800),
                        onTap: () {
                          setState(() {
                            _model.selectedCategory = 'builder';
                          });
                        },
                        isSelected: _model.selectedCategory == 'builder',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryCard(
                        context,
                        title: 'Rental',
                        icon: FontAwesomeIcons.key,
                        color: Color(0xFF2196F3),
                        onTap: () {
                          setState(() {
                            _model.selectedCategory = 'rental';
                          });
                        },
                        isSelected: _model.selectedCategory == 'rental',
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildCategoryCard(
                        context,
                        title: 'Finance',
                        icon: FontAwesomeIcons.dollarSign,
                        color: Color(0xFF9C27B0),
                        onTap: () {
                          setState(() {
                            _model.selectedCategory = 'finance';
                          });
                        },
                        isSelected: _model.selectedCategory == 'finance',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),

                // Signup Form
                if (_model.selectedCategory != null) ...[
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
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
                          'Signup as ${_model.selectedCategory!.toUpperCase()}',
                          style: FlutterFlowTheme.of(context).titleMedium
                              .override(fontFamily: 'Outfit', letterSpacing: 0),
                        ),
                        SizedBox(height: 20),

                        // Email Field
                        TextFormField(
                          controller: _model.emailTextController,
                          focusNode: _model.emailFocusNode,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: FlutterFlowTheme.of(context).labelMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0,
                                ),
                            hintText: 'Enter your email',
                            hintStyle: FlutterFlowTheme.of(context).labelMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(
                              context,
                            ).primaryBackground,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium
                              .override(fontFamily: 'Outfit', letterSpacing: 0),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16),

                        // Phone Field
                        TextFormField(
                          controller: _model.phoneTextController,
                          focusNode: _model.phoneFocusNode,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: FlutterFlowTheme.of(context).labelMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0,
                                ),
                            hintText: 'Enter your phone number',
                            hintStyle: FlutterFlowTheme.of(context).labelMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(
                              context,
                            ).primaryBackground,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium
                              .override(fontFamily: 'Outfit', letterSpacing: 0),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          controller: _model.passwordTextController,
                          focusNode: _model.passwordFocusNode,
                          autofocus: false,
                          obscureText: !_model.passwordVisibility,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: FlutterFlowTheme.of(context).labelMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0,
                                ),
                            hintText: 'Enter your password',
                            hintStyle: FlutterFlowTheme.of(context).labelMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(
                              context,
                            ).primaryBackground,
                            suffixIcon: InkWell(
                              onTap: () => setState(
                                () => _model.passwordVisibility =
                                    !_model.passwordVisibility,
                              ),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(
                                _model.passwordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: FlutterFlowTheme.of(
                                  context,
                                ).secondaryText,
                                size: 24,
                              ),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium
                              .override(fontFamily: 'Outfit', letterSpacing: 0),
                        ),
                        SizedBox(height: 16),

                        // Confirm Password Field
                        TextFormField(
                          controller: _model.confirmPasswordTextController,
                          focusNode: _model.confirmPasswordFocusNode,
                          autofocus: false,
                          obscureText: !_model.confirmPasswordVisibility,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: FlutterFlowTheme.of(context).labelMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0,
                                ),
                            hintText: 'Confirm your password',
                            hintStyle: FlutterFlowTheme.of(context).labelMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  letterSpacing: 0,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(
                              context,
                            ).primaryBackground,
                            suffixIcon: InkWell(
                              onTap: () => setState(
                                () => _model.confirmPasswordVisibility =
                                    !_model.confirmPasswordVisibility,
                              ),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(
                                _model.confirmPasswordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: FlutterFlowTheme.of(
                                  context,
                                ).secondaryText,
                                size: 24,
                              ),
                            ),
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium
                              .override(fontFamily: 'Outfit', letterSpacing: 0),
                        ),
                        SizedBox(height: 24),

                        // Signup Button
                        FFButtonWidget(
                          onPressed: () async {
                            await _handleSignup(_model.selectedCategory!);
                          },
                          text: 'Sign Up',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 50,
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0,
                              0,
                              0,
                              0,
                            ),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context).titleMedium
                                .override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  letterSpacing: 0,
                                ),
                            elevation: 3,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: FlutterFlowTheme.of(context).bodyMedium
                                  .override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0,
                                  ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/category-login');
                              },
                              child: Text(
                                'Login',
                                style: FlutterFlowTheme.of(context).bodyMedium
                                    .override(
                                      fontFamily: 'Outfit',
                                      color: FlutterFlowTheme.of(
                                        context,
                                      ).primary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.1)
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : FlutterFlowTheme.of(context).alternate,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? color
                  : FlutterFlowTheme.of(context).secondaryText,
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Outfit',
                color: isSelected
                    ? color
                    : FlutterFlowTheme.of(context).primaryText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
