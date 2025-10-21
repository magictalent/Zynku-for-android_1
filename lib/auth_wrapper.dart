import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Pages/HomePage.dart' show HomePageWidget;
import 'Pages/LoginPage.dart' show LoginPageWidget;
import 'session_manager.dart' show SessionManager;

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // Ensure Firebase Auth is properly initialized
    await FirebaseAuth.instance.authStateChanges().first;

    // Check if user has a saved session
    final hasSession = await SessionManager.hasSavedSession();
    if (hasSession) {
      // Verify the session is still valid
      final isValid = await SessionManager.verifySession();
      if (!isValid) {
        // Clear invalid session
        await SessionManager.clearUserSession();
      }
    }

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing...'),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Handle connection state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Checking authentication...'),
                ],
              ),
            ),
          );
        }

        // Handle errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isInitialized = false;
                      });
                      _initializeAuth();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Check if user is authenticated
        final user = snapshot.data;
        if (user != null) {
          // User is signed in - save their session
          SessionManager.saveUserSession(user);
          // Firebase Auth handles session persistence automatically
          return HomePageWidget();
        } else {
          // User is not signed in - clear any saved session
          SessionManager.clearUserSession();
          return LoginPageWidget();
        }
      },
    );
  }
}
