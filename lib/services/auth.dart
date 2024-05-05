import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String authTokenKey = 'authToken';

  // Save the authentication token to local memory
  static Future<void> saveAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(authTokenKey, token);
  }

  // Retrieve the authentication token from local memory
  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(authTokenKey);
  }
}