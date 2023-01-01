import 'package:flutter/material.dart';
import '../auth/Screens/Login/components/body.dart';

import '../utils/objects.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePassword extends StatefulWidget {
  final Worker worker;
  const ChangePassword({super.key, required this.worker});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.change_password),
      ),
      body: const BodyLogin(forChangePassword: true),
    );
  }
}
