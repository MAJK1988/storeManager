import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'package:store_manager/auth/Screens/Signup/components/or_divider.dart';
import 'package:store_manager/auth/Screens/Signup/components/social_icon.dart';
import 'package:store_manager/auth/services/signup/signup_response.dart';
import 'package:store_manager/utils/objects.dart';
import 'package:store_manager/utils/utils.dart';

import '../../../components/already_have_an_account_acheck.dart';
import '../../../components/rounded_button.dart';
import '../../../components/rounded_input_field.dart';
import '../../../components/rounded_password_field.dart';
import '../../../services/Login/login_utile.dart';
import '../../../services/auth.dart';
import '../../../services/validotrs.dart';
import '../../Login/login_screen.dart';
import 'background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodydState();
}

class _BodydState extends State<Body> implements SignUpCallBack {
  late String tag = "SignUp";
  late SignUpResponse response;
  _BodydState() {
    response = SignUpResponse(this);
  }
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  void dispose() {
    super.dispose();
  }

  late String email = '',
      passWord = '',
      passWordConfirm = '',
      name = '',
      phone = '';
  bool setText = true;
  late int count = 0;

  get kPrimaryColor => null;

  @override
  Widget build(BuildContext context) {
    if (!setText && count != 0) {
      setState(() {
        setText = true;
      });
    } else if (!setText && count == 0) {
      setState(() {
        count++;
      });
    }

    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.05),
            Text(
              "Register",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  fontSize: 22.0),
            ),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            //type your name
            RoundedInputField(
              hintText: "type your Name",
              controll: 'name',
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              inputText: setText,
            ),

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
              hintText: "Password",
              onChanged: (value) {
                setState(() {
                  passWord = value;
                });
              },
              inputText: setText,
            ),
            RoundedPasswordField(
              hintText: "Confirm Password",
              onChanged: (value) {
                setState(() {
                  passWordConfirm = value;
                });
              },
              inputText: setText,
            ),
            // type your phone number
            SizedBox(
              width: size.width * 0.8,
              child: InternationalPhoneNumberInput(
                autoValidateMode: AutovalidateMode.disabled,
                onInputChanged: (PhoneNumber value) {
                  phone = value.phoneNumber!;
                },
                onSaved: (PhoneNumber number) {
                  phone = number.phoneNumber!;
                },
              ),
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () async {
                Log(tag: tag, message: "test sign up callBack");
                response.doSignUp(initWorker());
                if (!Validator.checkAllInput(
                    email: email,
                    password: passWord,
                    passwordConfirm: passWordConfirm,
                    name: name,
                    phone: phone)) {
                  setState(() {
                    email = '';
                    passWord = '';
                    passWordConfirm = '';
                    phone = '';
                    setText = false;
                    count = 0;
                  });
                } else {
                  //process
                }
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreenApp();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocalIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocalIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void onSignUpError(String error) {
    Log(tag: tag, message: "Error: $error");
    // TODO: implement onLoginError
  }

  @override
  void onSignUpSuccess(int id) {
    Log(tag: tag, message: "sign up has been validated!!!!");
    // TODO: implement onLoginSuccess
  }
}
