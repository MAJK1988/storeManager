import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_manager/utils/objects.dart';

import '../../../../home.dart';
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
import 'dart:async';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> implements LoginCallBack {
  late String tag = "Login";

  late BuildContext ctx;
  bool _isLoading = false;

  late String email = '', passWord = '';
  late bool setText = true;
  late int count = 0;
  late LoginResponse response;
  _BodyState() {
    response = LoginResponse(this);
  }
  @override
  void initState() {
    //SharedPreferences.setMockInitialValues({});

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
            const Text(
              "Welcome back",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  color: kPrimaryColor),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              inputText: setText,
            ),
            RoundedPasswordField(
              onChanged: (value) {
                setState(() {
                  passWord = value;
                });
              },
              hintText: 'Password',
              inputText: setText,
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Log(tag: tag, message: "Test login callBack");
                response.doLogin("email", "passWord");
                if (!Validator.checkEmpty(email, passWord, passWord)) {
                  setState(() {
                    email = '';
                    passWord = '';
                    setText = false;
                    count = 0;
                  });
                } else {
                  response.doLogin(email, passWord);
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onLoginError(String error) {
    Log(tag: tag, message: "error: $error");
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
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const Home(),
        ),
      );
    } else {
      Log(tag: tag, message: "result is empty no user");
    }
    // TODO: implement onLoginSuccess
  }
}
