import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import '../auth/firebase_auth_service.dart';

class CreateAccount3Widget extends StatefulWidget {
  const CreateAccount3Widget({super.key});

  static String routeName = 'CreateAccount3';
  static String routePath = '/createAccount3';

  @override
  State<CreateAccount3Widget> createState() => _CreateAccount3WidgetState();
}

class _CreateAccount3WidgetState extends State<CreateAccount3Widget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Text controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create Customer Account',
              style: FlutterFlowTheme.of(context).headlineMedium,
            ),
            const SizedBox(height: 20),

            // Name field
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Email field
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Signup button
            FFButtonWidget(
              onPressed: () async {
                final name = _nameController.text;
                final email = _emailController.text;
                final password = _passwordController.text;

                if (name.isEmpty || email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (password.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Password must be at least 6 characters'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                try {
                  // Show loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        Center(child: CircularProgressIndicator()),
                  );

                  // Create Firebase user
                  await FirebaseAuthService.signUpWithEmailAndPassword(
                    email: email,
                    password: password,
                  );

                  // Close loading dialog
                  Navigator.of(context).pop();

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Account created successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // Navigate to login page
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {
                  // Close loading dialog
                  Navigator.of(context).pop();

                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              text: 'Sign Up',
              options: FFButtonOptions(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                iconPadding: const EdgeInsets.all(0),
                elevation: 3, // ✅ required
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(
                  context,
                ).titleSmall.override(fontSize: 18, color: Colors.white),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),

            // Go back button
            FFButtonWidget(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'Go Back',
              options: FFButtonOptions(
                width: double.infinity,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                iconPadding: const EdgeInsets.all(0),
                elevation: 0, // ✅ required
                color: FlutterFlowTheme.of(context).secondaryBackground,
                textStyle: FlutterFlowTheme.of(context).titleSmall,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
