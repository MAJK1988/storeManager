import 'package:shared_preferences/shared_preferences.dart';

getEmailPassword() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? email = preferences.getString("email");
  String? password = preferences.getString("password");
  return {"email": email, "password": password};
}

setEmailPassword({required String email, required String passWord}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  preferences.setString("email", email);
  preferences.setString("password", passWord);
  preferences.commit();
}
