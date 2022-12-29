import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_manager/utils/objects.dart';

import '../../../../home.dart';
import '../../../../setting/setting.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/rounded_button.dart';
import '../../../components/rounded_input_field.dart';
import '../../../components/rounded_password_field.dart';
import '../../../services/Login/login_response.dart';
import '../../../services/Login/login_utile.dart';
import '../../../services/auth.dart';
import '../../../services/validotrs.dart';
import '../../Signup/signup_screen.dart';
import 'background.dart';
import 'package:store_manager/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BodyLogin extends StatefulWidget {
  final bool forChangePassword;
  const BodyLogin({Key? key, required this.forChangePassword})
      : super(key: key);

  @override
  State<BodyLogin> createState() => _BodyLoginState();
}

class _BodyLoginState extends State<BodyLogin> implements LoginCallBack {
  late String tag = "Login";

  late BuildContext ctx;
  bool forChangePassWord = false;

  late String email = '', passWord = '', passWord1 = '';
  late bool setText = true;
  late int count = 0;
  late LoginResponse response;
  _BodyLoginState() {
    response = LoginResponse(this);
  }
  @override
  void initState() {
    //SharedPreferences.setMockInitialValues({});
    if (!widget.forChangePassword) {
      () async {
        SharedPreferences _pref = await SharedPreferences.getInstance();
        Log(tag: tag, message: "Try to login to app!!!");

        String email = _pref.getString("email") ?? "";
        String password = _pref.getString("password") ?? "";
        Log(tag: tag, message: "email: $email, password: $password");
        if (email != "" && password != "") {
          response.doLogin(email, password);
        }
      }();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!setText && count != 0) {
      setState(() {
        setText = true;
      });
    } else if (!setText && count == 0)
      setState(() {
        count++;
      });
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
                visible: !widget.forChangePassword,
                child: const Text(
                  "Welcome back",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: kPrimaryColor),
                )),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            Visibility(
                visible: !forChangePassWord,
                child: RoundedInputField(
                  hintText: AppLocalizations.of(context)!.email,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  inputText: setText,
                )),
            RoundedPasswordField(
              onChanged: (value) {
                setState(() {
                  passWord = value;
                });
              },
              hintText: AppLocalizations.of(context)!.password,
              inputText: setText,
            ),
            Visibility(
                visible: forChangePassWord,
                child: RoundedPasswordField(
                  onChanged: (value) {
                    setState(() {
                      passWord1 = value;
                    });
                  },
                  hintText: AppLocalizations.of(context)!.password1,
                  inputText: setText,
                )),
            RoundedButton(
              text: !widget.forChangePassword
                  ? AppLocalizations.of(context)!.login
                  : !forChangePassWord
                      ? AppLocalizations.of(context)!.change_password
                      : AppLocalizations.of(context)!.validate_new_password,
              press: () {
                Log(tag: tag, message: "Test login callBack");
                //response.doLogin("email", "passWord");
                if (!Validator.checkEmpty(email, passWord, passWord)) {
                  setState(() {
                    email = '';
                    passWord = '';
                    setText = false;
                    count = 0;
                  });
                } else {
                  if (!widget.forChangePassword) {
                    Log(tag: tag, message: "Try to login");
                    response.doLogin(email, passWord);
                  } else {
                    if (!forChangePassWord) {
                      Log(tag: tag, message: "Try to validate email Password");
                      response.doLogin(email, passWord);
                    } else {
                      Log(tag: tag, message: "Try to validate new password");
                      if (passWord == passWord1) {
                        Log(tag: tag, message: "Password has been changed");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          // ignore: use_build_context_synchronously
                          AppLocalizations.of(context)!.change_password,
                        )));
                        Navigator.pushReplacement<void, void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const SettingWidget(),
                          ),
                        );
                      } else {
                        Log(tag: tag, message: "Error in new password!!!");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          // ignore: use_build_context_synchronously
                          AppLocalizations.of(context)!.error_password,
                        )));
                        setState(() {
                          passWord = '';
                          passWord1 = '';
                        });
                      }
                    }
                  }
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            Visibility(
                visible: !widget.forChangePassword,
                child: AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  @override
  void onLoginError(String error) {
    Log(tag: tag, message: "error: $error");
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      // ignore: use_build_context_synchronously
      AppLocalizations.of(context)!.error_login,
    )));
    setState(() {
      email = '';
      passWord = '';
    });
    // TODO: implement onLoginError
  }

  @override
  void onLoginSuccess(Worker user) async {
    if (user != null) {
      Log(tag: tag, message: "Has login!!!!");
      Log(tag: tag, message: "user name is ${user.name}");
      SharedPreferences _pref = await SharedPreferences.getInstance();
      if (email.isNotEmpty && passWord.isNotEmpty) {
        setState(() {
          _pref.setString("email", email).then((value) {
            Log(tag: tag, message: "email is saved? $value,  $email");
          });
          _pref.setString("password", passWord).then((value) {
            Log(tag: tag, message: "password is saved? $value,  $passWord");
          });
        });
      }
      if (!widget.forChangePassword) {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const Home(),
          ),
        );
      } else {
        if (!forChangePassWord) {
          setState(() {
            forChangePassWord = true;
          });
        }
      }
    } else {
      Log(tag: tag, message: "result is empty no user");
    }
    // TODO: implement onLoginSuccess
  }
}
