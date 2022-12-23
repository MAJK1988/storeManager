import '../../../utils/objects.dart';
import '../Login/login_ctr.dart';

class SignUpRequest {
  LoginCtr con = new LoginCtr();

  Future<int?> getSignUp(Worker worker) {
    var result = con.saveUser(worker);
    return result;
  }
}
