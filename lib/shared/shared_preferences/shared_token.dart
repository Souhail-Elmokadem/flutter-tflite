

import 'package:testtp1android/shared/shared_preferences/sharedNatwork.dart';

class TokenManager {
  static Future<String?> getAccessToken() async {
    return  Sharednetwork.getDataString(key: "accessToken");
  }

  static Future<String?> getRefreshToken() async {
    return await Sharednetwork.getDataString(key: "refreshToken");
  }
  static Future<List<Map<String, String>>> getUserData() async {
    // Retrieve name and email from shared preferences
    String? name = await Sharednetwork.getDataString(key: "name");
    String? email = await Sharednetwork.getDataString(key: "email");

    // Return a list containing the name and email as a map
    if (name != null && email != null) {
      return [
        {
          "name": name,
          "email": email,
        }
      ];
    } else {
      return [];  // Return an empty list if no data found
    }
  }

  static Future<void> saveAccessToken(String token) async {
    await Sharednetwork.insertDataString(key: "accessToken", value: token);
  }
  static Future<void> saveUserData(String name,String email) async {
    await Sharednetwork.insertDataString(key: "name", value: name);
    await Sharednetwork.insertDataString(key: "email", value: email);
  }

  static Future<void> saveRefreshToken(String token) async {
    await Sharednetwork.insertDataString(key: "refreshToken", value: token);
  }

  static Future<void> clearTokens() async {
    await Sharednetwork.deleteData(key: "accessToken");
    await Sharednetwork.deleteData(key: "refreshToken");
  }
}
