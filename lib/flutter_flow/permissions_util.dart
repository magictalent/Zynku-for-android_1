enum PermissionType { microphone, camera, location, storage }

class PermissionsUtil {
  static Future<bool> requestPermission(PermissionType permission) async {
    // Mock implementation - in real app, use permission_handler package
    return true;
  }
}

// Mock permission types
const microphonePermission = PermissionType.microphone;
