import 'package:flutter/material.dart';

import '../l10n/L10n.dart';

class LocaleProvider extends ChangeNotifier {
  late Locale _locale = L10n.all.first;

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = L10n.all.first;
    notifyListeners();
  }

  Locale getLocale() {
    return _locale;
  }
}
