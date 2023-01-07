import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_manager/setting/account_management.dart';
import 'package:store_manager/setting/add_account.dart';
import 'package:store_manager/setting/change_password.dart';
import 'package:store_manager/setting/setting_item.dart';

import '../auth/Screens/Login/login_screen.dart';
import '../auth/services/Login/login_ctr.dart';
import '../lang_provider/language_picker_widget.dart';

import 'package:provider/provider.dart';

import '../l10n/L10n.dart';
import '../lang_provider/locale_provider.dart';
import '../utils/objects.dart';
import '../utils/utils.dart';

class SettingWidget extends StatefulWidget {
  const SettingWidget({super.key});

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  late String? email = "", passWord = "", phone = "";
  late int userPosition = 0;
  Worker worker = initWorker();

  @override
  void initState() {
    // TODO: implement initState
    () async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      LoginCtr con = LoginCtr();
      Worker? workerRes = await LoginCtr()
          .getLogin(pref.getString("email")!, pref.getString("password")!);
      if (workerRes != null) {
        setState(() {
          email = workerRes!.email;
          phone = workerRes.phoneNumber;
          worker = workerRes;
          userPosition = workerRes.userIndex;
        });
      }
    }();

    super.initState();
  }

  bool useCustomTheme = false, emailIsVisible = false, phoneIsVisible = false;
  final platformsMap = <DevicePlatform, String>{
    DevicePlatform.device: 'Default',
    DevicePlatform.android: 'Android',
    DevicePlatform.iOS: 'iOS',
    DevicePlatform.web: 'Web',
    DevicePlatform.fuchsia: 'Fuchsia',
    DevicePlatform.linux: 'Linux',
    DevicePlatform.macOS: 'MacOS',
    DevicePlatform.windows: 'Windows',
  };
  DevicePlatform selectedPlatform = DevicePlatform.device;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: SettingsList(
        platform: selectedPlatform,
        lightTheme: !useCustomTheme
            ? null
            : const SettingsThemeData(
                dividerColor: Colors.red,
                tileDescriptionTextColor: Colors.yellow,
                leadingIconsColor: Colors.pink,
                settingsListBackground: Colors.white,
                settingsSectionBackground: Colors.green,
                settingsTileTextColor: Colors.tealAccent,
                tileHighlightColor: Colors.blue,
                titleTextColor: Colors.cyan,
                trailingTextColor: Colors.deepOrangeAccent,
              ),
        darkTheme: !useCustomTheme
            ? null
            : const SettingsThemeData(
                dividerColor: Colors.pink,
                tileDescriptionTextColor: Colors.blue,
                leadingIconsColor: Colors.red,
                settingsListBackground: Colors.grey,
                settingsSectionBackground: Colors.tealAccent,
                settingsTileTextColor: Colors.green,
                tileHighlightColor: Colors.yellow,
                titleTextColor: Colors.cyan,
                trailingTextColor: Colors.orange,
              ),
        sections: [
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.common),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.language),
                title: Text(AppLocalizations.of(context)!.language),
                value: Text(
                  L10n.getFlag(
                      Provider.of<LocaleProvider>(context, listen: false)
                          .getLocale()
                          .languageCode),
                  style: const TextStyle(fontSize: 32),
                ),
                onPressed: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Language(),
                    ),
                  );
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.phone),
                title: Text(AppLocalizations.of(context)!.phone),
                onPressed: (context) {
                  setState(() {
                    phoneIsVisible = !phoneIsVisible;
                  });
                },
                value: Visibility(
                  visible: phoneIsVisible,
                  child: Text(phone!),
                ),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.mail),
                title: Text(AppLocalizations.of(context)!.email),
                onPressed: (context) {
                  setState(() {
                    emailIsVisible = !emailIsVisible;
                  });
                },
                value: Visibility(
                  visible: emailIsVisible,
                  child: Text(email!),
                ),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.logout),
                title: Text(AppLocalizations.of(context)!.log_out),
                onPressed: (context) async {
                  await logOut(context: context);
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.security),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.lock),
                title: Text(AppLocalizations.of(context)!.change_password),
                onPressed: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChangePassword(
                        worker: worker,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          userPosition == 1
              ? SettingsSection(
                  title: Text(AppLocalizations.of(context)!.manager),
                  tiles: <SettingsTile>[
                    SettingsTile.navigation(
                      leading: const Icon(Icons.manage_search_sharp),
                      title: Text(AppLocalizations.of(context)!.manager_item),
                      onPressed: (context) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const SettingItem()),
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(Icons.person_add),
                      title: Text(AppLocalizations.of(context)!.add_account),
                      onPressed: (context) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const AddAccount()),
                        );
                      },
                    ),
                    SettingsTile.navigation(
                      leading: const Icon(Icons.people),
                      title:
                          Text(AppLocalizations.of(context)!.manager_account),
                      onPressed: (context) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const AccountManagement()),
                        );
                      },
                    ),
                  ],
                )
              : SettingsSection(
                  title: Text(""),
                  tiles: <SettingsTile>[SettingsTile(title: const Text(""))]),
        ],
      ),
    );
  }
}
