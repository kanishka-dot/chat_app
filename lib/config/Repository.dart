import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Repository {
  // Create storage
  final storage =  FlutterSecureStorage();

  // Read value
  Future readData(String key) async{
    String value = await storage.read(key: key);
    return value;
  }
  // Read all values
  Future readAllData(String _key) async{
    Map<String, String> allValues = await storage.readAll();
    return allValues;
  }
  // Delete value
  deleteData(String key) async{
    await storage.delete(key: key);
  }
  // Delete all
  void deleteAllData() async{
    await storage.deleteAll();
  }
  // Write value
  Future addValue(String key, String value) async
  {
    await storage.write(key: key, value: value);
  }

}

class AppSharedData{
   SharedPreferences prefs;

  AppSharedData(SharedPreferences preferences) {
    prefs = preferences;
  }

  Future setToken(String token, String value) async{
    await prefs.setString(token, value);
  }

  String getToken(String token){
    return prefs.getString(token);
  }

  Future clearToken(String token) async{
    await prefs.remove(token);
  }
}

/// normal String
/// 1. create object of APPSharedData
/// AppSharedData pref = AppSharedData();
///
/// 2. define global variable
/// const CACHED_USER = 'CACHED_USER';
///
/// 3. set data
/// await pref.setToken(CACHED_USER, "sahan");
///
/// 4. get data
/// pref.getToken(CACHED_USER);
///
/// 5. clear data
/// await pref.clearToken(CACHED_USER);
///
///
/// JSON STRING
///
/// set data(first of all create instance of model as a example userModel)
/// await pref.setToken(CACHED_USER, json.encode(userModel.toJson());
///
/// get data
/// final jsonString = pref.getToken(CACHED_USER);
///
/// Create method include this and return type is Model (Future<UserModel>)
///     if (jsonString != null) {
///      return Future.value(UserModel.fromJson(json.decode(jsonString)));
///     } else {
///       throw CacheException();
///     }