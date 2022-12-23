import 'package:store_manager/utils/objects.dart';

import 'login_ctr.dart';

class LoginRequest {
  LoginCtr con = new LoginCtr();

  Future<Worker?> getLogin(String username, String password) {
    var result = con.getLogin(username, password);
    return result;
  }
}
