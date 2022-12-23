import '../../../utils/objects.dart';
import 'signup_request.dart';

abstract class SignUpCallBack {
  void onSignUpSuccess(int id);
  void onSignUpError(String error);
}

class SignUpResponse {
  SignUpCallBack _callBack;
  SignUpRequest signUpRequest = SignUpRequest();
  SignUpResponse(this._callBack);

  doSignUp(Worker user) {
    signUpRequest
        .getSignUp(user)
        .then((user) => _callBack.onSignUpSuccess(user!))
        .catchError((onError) => _callBack.onSignUpError(onError.toString()));
  }
}
