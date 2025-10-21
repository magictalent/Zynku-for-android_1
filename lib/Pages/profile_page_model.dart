import 'package:flutter/material.dart';

class UserdetailsModel extends ChangeNotifier {
  // Placeholder for user data (can be replaced with actual user profile fields)
  String? displayName;
  String? email;
  String? phoneNumber;
  String? avatarUrl;

  bool isLoading = false;
  String? errorMessage;

  // Example: Load user profile (can be replaced by firebased/user service logic)
  Future<void> loadUserProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Simulate a network call or fetch logic
      await Future.delayed(const Duration(seconds: 1));
      // Set mock data (replace with actual logic)
      displayName = 'Builder Zynku';
      email = 'zyynku@email.com';
      phoneNumber = '+1234567890';
      avatarUrl = null; // set to image url string if available

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to load profile';
      notifyListeners();
    }
  }

  // Example: Update display name
  Future<void> updateDisplayName(String name) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Simulate update call
      await Future.delayed(const Duration(milliseconds: 500));
      displayName = name;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      errorMessage = 'Failed to update display name';
      notifyListeners();
    }
  }

  // Dispose: Override if needed, currently nothing to clean up.
  @override
  void dispose() {
    super.dispose();
  }
}
