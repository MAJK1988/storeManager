import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:store_manager/AddObject/add_supplier.dart';
import 'package:store_manager/home.dart';
import 'package:store_manager/lang_provider/page/localization_app_page.dart';
import 'package:store_manager/lang_provider/page/localization_system_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'AddObject/add_item.dart';
import 'auth/Screens/Login/login_screen.dart';
import 'l10n/L10n.dart';
import 'lang_provider/locale_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Localization';

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.deepPurple.shade100,
              primaryColor: Colors.deepPurpleAccent,
            ),
            initialRoute: '/',
            routes: {
              // Navigate back to the first screen by popping the current route
              // off the stack.
              // Navigator.pop(context);
              // When navigating to the "/" route, build the FirstScreen widget.
              '/': (context) => const LoginScreenApp(),
              // When navigating to the "/second" route, build the SecondScreen widget.
              '/home': (context) => const Home(),
              '/AddItem': (context) => const AddItem(),
              '/AddSupplier': (context) => const AddSupplier(title: ''),
            },
            locale: provider.locale,
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
          );
        },
      );
}
