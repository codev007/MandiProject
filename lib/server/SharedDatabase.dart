import 'package:shared_preferences/shared_preferences.dart';

class SharedDatabase {
  Future<String> getMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('mobile');
  }

  Future<String> getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('id');
  }

  Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('name');
  }

  Future<String> getType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('type');
  }

  setMobile(String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    prefs.setString('mobile', mobile);
  }

  setMandi(String mobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    prefs.setString('mandi', mobile);
  }

  setProfileData(String id, String name, String mobile, String type,
      String defaultMandi) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', id);
    prefs.setString('name', name);
    prefs.setString('type', type);
    prefs.setString('mobile', mobile);
    prefs.setString('mandi', defaultMandi);
  }

  Future<String> getMandi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    return prefs.getString('mandi');
  }

  mLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
