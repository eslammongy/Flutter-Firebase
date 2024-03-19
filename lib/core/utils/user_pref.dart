import 'package:shared_preferences/shared_preferences.dart';

class UserPref {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> keepUserAuthenticated({required bool isLogged}) async {
    await sharedPreferences.setBool('UserIsLogin', isLogged);
  }

  static Future<bool> checkIsUserAuthenticated() async {
    return sharedPreferences.getBool('UserIsLogin') ?? false;
  }
}
