class AuthManager {
  static Future<Map<String, dynamic>?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // Mock implementation - in real app, use Supabase auth
    return {
      'user': {'id': 'mock_user_id', 'email': email},
      'session': {'access_token': 'mock_token'},
    };
  }

  static Future<Map<String, dynamic>?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    // Mock implementation
    return {
      'user': {'id': 'mock_user_id', 'email': email},
      'session': {'access_token': 'mock_token'},
    };
  }
}

final authManager = AuthManager();
