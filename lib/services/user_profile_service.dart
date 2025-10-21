import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get user display name by user ID
  static Future<String> getUserDisplayName(String userId) async {
    try {
      print('Getting display name for userId: $userId');

      // First try to get from the current user if it's the same ID
      final currentUser = _auth.currentUser;
      print(
        'Current user: ${currentUser?.uid}, displayName: ${currentUser?.displayName}, email: ${currentUser?.email}',
      );

      if (currentUser?.uid == userId) {
        final name =
            currentUser?.displayName ??
            currentUser?.email?.split('@')[0] ??
            'User';
        print('Using current user name: $name');
        return name;
      }

      // Try to get from a user profiles collection (if you have one)
      final doc = await _db.collection('user_profiles').doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        final name = data?['displayName'] ?? data?['name'] ?? 'User';
        print('Found in user_profiles: $name');
        return name;
      }

      // Fallback: return a shortened version of the user ID
      final fallbackName = 'User (${userId.substring(0, 8)}...)';
      print('Using fallback name: $fallbackName');
      return fallbackName;
    } catch (e) {
      print('Error fetching user display name: $e');
      return 'User';
    }
  }

  /// Create or update user profile
  static Future<void> createOrUpdateUserProfile({
    required String userId,
    required String displayName,
    String? email,
    String? phone,
  }) async {
    try {
      await _db.collection('user_profiles').doc(userId).set({
        'displayName': displayName,
        'email': email,
        'phone': phone,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error creating/updating user profile: $e');
    }
  }
}
