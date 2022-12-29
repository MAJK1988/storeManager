import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../l10n/L10n.dart';
import 'locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final flag = L10n.getFlag(locale.languageCode);

    return Center(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 72,
        child: Text(
          flag,
          style: TextStyle(fontSize: 80),
        ),
      ),
    );
  }
}

class LanguagePickerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale ?? Locale('en');

    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: locale,
        icon: Container(width: 12),
        items: L10n.all.map(
          (locale) {
            final flag = L10n.getFlag(locale.languageCode);

            return DropdownMenuItem(
              child: Center(
                child: Text(
                  flag,
                  style: TextStyle(fontSize: 32),
                ),
              ),
              value: locale,
              onTap: () {
                final provider =
                    Provider.of<LocaleProvider>(context, listen: false);

                provider.setLocale(locale);
              },
            );
          },
        ).toList(),
        onChanged: (_) {},
      ),
    );
  }
}

class Language extends StatelessWidget {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.language),
        ),
        body: SettingsList(sections: [
          SettingsSection(
            title: Text('Security'),
            tiles: <SettingsTile>[
              for (var locale in L10n.all)
                SettingsTile.switchTile(
                  onPressed: (context) {},
                  initialValue:
                      (Provider.of<LocaleProvider>(context, listen: false)
                              .getLocale() ==
                          locale),
                  //leading: Icon(Icons.),
                  title: Text(
                    L10n.getFlag(locale.languageCode),
                    style: const TextStyle(fontSize: 32),
                  ),
                  onToggle: (bool value) {
                    final provider =
                        Provider.of<LocaleProvider>(context, listen: false);
                    if (value) {
                      provider.setLocale(locale);
                    } else {
                      provider.clearLocale();
                    }
                    Navigator.of(context).pop();
                  },
                )
            ],
          )
        ]));
  }
}
