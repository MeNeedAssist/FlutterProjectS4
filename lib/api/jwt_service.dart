import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JWTService {
  Future<bool> isTokenExpired() async {
    try {
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences? prefs = await _prefs;
      final token = prefs?.getString('token');

      if (token == null || token.isEmpty) {
        // Token is not available or empty
        return true;
      }

      // Decode the JWT token
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      // Check if the token is expired
      if (decodedToken.containsKey('exp')) {
        final int expiryTimeInSeconds = decodedToken['exp'];
        final DateTime expiryDateTime =
            DateTime.fromMillisecondsSinceEpoch(expiryTimeInSeconds * 1000);

        // Compare the expiry time with the current time
        return DateTime.now().isAfter(expiryDateTime);
      } else {
        // If 'exp' claim is not present, consider the token as expired
        return true;
      }
    } catch (error) {
      // Handle decoding or other errors
      print('Error decoding or checking JWT expiry: $error');
      return true; // Assume expired in case of an error
    }
  }
}
