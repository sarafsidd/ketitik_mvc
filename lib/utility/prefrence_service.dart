import 'package:shared_preferences/shared_preferences.dart';

class PrefrenceService {
  SharedPreferences? _prefs;
  //SharedPreferences pref = await SharedPreferences.getInstance();

  Future<bool> getSharedPreferencesInstance() async {
    _prefs = await SharedPreferences.getInstance().catchError((e) {
      print("shared prefrences error : $e");
      // return e;
    });
    return true;
  }

  setName(String? name) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString('name', name!);
    print("Name : $name");
  }

  setEmail(String? email) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString('email', email!);
    print("Email : $email");
  }

  setPhone(String? phone) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString('phone', phone!);
    print("Phone : $phone");
  }

  setToken(String? token) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString('token', token!);
    print("Tokennnnn : $token");
  }

  setAvatarImage(String? avatar) async {
    _prefs = await SharedPreferences.getInstance();
    _prefs!.setString('avatar', avatar!);
    print("avatar : $avatar");
  }

  getAvatarImage() async {
    _prefs = await SharedPreferences.getInstance();
    String? getAvatar = _prefs!.getString('avatar');
    print("Get Avatar :$getAvatar");
    return getAvatar;
  }

  Future<String?> getName() async {
    _prefs = await SharedPreferences.getInstance();
    String? getName = _prefs!.getString('name');
    print("Get Name :$getName");
    return getName;
  }

  Future<String?> getEmail() async {
    _prefs = await SharedPreferences.getInstance();
    String? getEmail = _prefs!.getString('email');
    print("Get Email :$getEmail");
    return getEmail;
  }

  Future<String?> getToken() async {
    _prefs = await SharedPreferences.getInstance();
    String? getToken = _prefs!.getString('token');
    print("Get Token :$getToken");
    return getToken;
  }

  Future<String?> getPhone() async {
    _prefs = await SharedPreferences.getInstance();
    String? getPhone = _prefs!.getString('phone');
    print("Get Phone :$getPhone");
    return getPhone;
  }

  /*getPrefrence() async {
    List<String>? prefrence = _prefs!.getStringList("prefrence");
    print("Get Token :$getToken");
    return prefrence;
  }*/

  Future clearToken() async {
    await _prefs!.clear();
  }

  Future<bool> setLoggedIn(bool status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("logged_in", status);
  }

  Future<bool> getLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("logged_in") ?? false;
  }
}

// class SharedPrefrence {
//   Future<bool> setLoggedIn(bool status) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setBool("logged_in", status);
//   }

//   Future<bool> getLogedIn() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getBool("logged_in") ?? false;
//   }

//   Future<bool> setUserId(String userId) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.setString("user_id", userId);
//   }

//   Future<String> getUserId() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString("user_id") ?? '';
//   }
// }
