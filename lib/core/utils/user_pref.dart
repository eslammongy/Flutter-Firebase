import '../../features/profile/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserPref {
  static late SharedPreferences sharedPreferences;
  
  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveUserLoggedIn({required bool isLogged}) async {
    await sharedPreferences.setBool('UserIsLogin', isLogged);
    
  }

  static Future<bool> checkUserLoggedIn() async {
    return sharedPreferences.getBool('UserIsLogin') ?? false;
  }

  static Future<void> saveUserInfoLocally(
      {required UserModel userModel}) async {
    sharedPreferences.setString('UserId', userModel.uId!);
    sharedPreferences.setString('UserName', userModel.name ?? "");
    sharedPreferences.setString('UserEmail', userModel.email ?? "");
    sharedPreferences.setString('UserPhone', userModel.phone ?? "");
    sharedPreferences.setString('UserAvatar', userModel.image ?? "");
  }

  static Future<UserModel?> getUserInfoLocally() async {
    UserModel userModel = UserModel();
    userModel.uId = sharedPreferences.getString('UserId');
    userModel.name = sharedPreferences.getString('UserName');
    userModel.email = sharedPreferences.getString('UserEmail');
    userModel.phone = sharedPreferences.getString('UserPhone');
    userModel.image = sharedPreferences.getString('UserAvatar');

    return userModel;
  }
}
