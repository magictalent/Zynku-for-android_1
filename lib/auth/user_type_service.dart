class UserTypeService {
  static String? _selectedUserType;

  // Set the user type when user selects Customer or Supplier
  static void setUserType(String userType) {
    _selectedUserType = userType;
  }

  // Get the selected user type
  static String? get selectedUserType => _selectedUserType;

  // Clear the user type (useful for logout)
  static void clearUserType() {
    _selectedUserType = null;
  }

  // Get the redirect path based on user type
  static String getRedirectPath() {
    switch (_selectedUserType) {
      case 'customer':
        return '/voice-help';
      case 'supplier':
        return '/supplier-auth';
      default:
        return '/'; // Default to home page
    }
  }
}
