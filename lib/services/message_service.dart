import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_profile_service.dart';

class MessageService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Send a message from a customer to builders nearby.
  static Future<void> sendBuilderMessage({
    required String text,
    required String category, // e.g. 'plumbing'
    double? latitude,
    double? longitude,
  }) async {
    final user = _auth.currentUser;

    // Try to get a better display name
    String displayName =
        user?.displayName ?? user?.email?.split('@')[0] ?? 'Customer';

    print(
      'Creating message with displayName: $displayName for user: ${user?.uid}',
    );

    // Create or update user profile
    if (user != null) {
      await UserProfileService.createOrUpdateUserProfile(
        userId: user.uid,
        displayName: displayName,
        email: user.email,
      );
    }

    await _db.collection('builder_messages').add({
      'text': text,
      'category': category,
      'createdAt': FieldValue.serverTimestamp(), // ✅ ensures correct ordering
      'customerId': user?.uid,
      'customerName': displayName, // Add customer name
      'senderName': displayName, // Add sender name for consistency
      'senderType': 'customer', // Add sender type
      'location': latitude != null && longitude != null
          ? GeoPoint(latitude, longitude)
          : null,
      'status': 'new',
    });
  }

  /// Stream messages for a category, ordered by time.
  static Stream<QuerySnapshot<Map<String, dynamic>>> streamBuilderMessages({
    required String category,
  }) {
    return _db
        .collection('builder_messages')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true) // ✅ ensures latest first
        .snapshots();
  }

  /// Stream messages for a specific customer conversation
  static Stream<QuerySnapshot<Map<String, dynamic>>> streamCustomerMessages({
    required String category,
    required String customerId,
  }) {
    // Use a simpler query to avoid index requirements
    return _db
        .collection('builder_messages')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Send a message in the chat
  static Future<void> sendMessage({
    required String text,
    required String category,
    required String senderId,
    required String senderName,
    required String senderType,
    String? customerId, // Add customerId for conversation tracking
  }) async {
    await _db.collection('builder_messages').add({
      'text': text,
      'category': category,
      'createdAt': FieldValue.serverTimestamp(),
      'senderId': senderId,
      'senderName': senderName,
      'senderType': senderType,
      'customerId': customerId, // Include customerId in the message
    });
  }
}
