import 'package:flutter/material.dart';

import '../../utils/utils.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccountCheck({
    this.login = true,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login
              ? AppLocalizations.of(context)!.no_account
              : AppLocalizations.of(context)!.has_account,
          style: const TextStyle(color: kPrimaryColor),
        ),
        GestureDetector(
          onTap: () => press(),
          child: Text(
            login
                ? AppLocalizations.of(context)!.sign_up
                : AppLocalizations.of(context)!.sign_in,
            style: const TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
