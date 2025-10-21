import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SessionManager {
  static const String _userEmailKey = 'user_email';
  static const String _userUidKey = 'user_uid';
  static const String _isLoggedInKey = 'is_logged_in';

  // Save user session data
  static Future<void> saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, user.email ?? '');
    await prefs.setString(_userUidKey, user.uid);
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Clear user session data
  static Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userUidKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Check if user has a saved session
  static Future<bool> hasSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get saved user email
  static Future<String?> getSavedUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Get saved user UID
  static Future<String?> getSavedUserUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userUidKey);
  }

  // Verify if the current Firebase user matches saved session
  static Future<bool> verifySession() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return false;

    final savedUid = await getSavedUserUid();
    return savedUid == currentUser.uid;
  }

  // Initialize session persistence
  static Future<void> initializeSessionPersistence() async {
    // Firebase Auth persistence is handled differently on different platforms
    if (kIsWeb) {
      // On web, we can set persistence explicitly
      try {
        await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      } catch (e) {
        // Fallback if setPersistence fails
        print('Warning: Could not set persistence: $e');
      }
    } else {
      // On mobile platforms (Android/iOS), persistence is automatic
      // Firebase Auth automatically persists sessions on mobile
      print(
        'Mobile platform detected - Firebase Auth persistence is automatic',
      );
    }
  }
}
