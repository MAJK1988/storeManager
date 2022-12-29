import 'package:flutter/material.dart';

import 'components/body.dart';

class LoginScreenApp extends StatefulWidget {
  const LoginScreenApp({Key? key}) : super(key: key);

  @override
  State<LoginScreenApp> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenApp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BodyLogin(forChangePassword: false),
    );
  }
}
