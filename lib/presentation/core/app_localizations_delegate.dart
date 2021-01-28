import 'package:flutter/material.dart';

import 'app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(_) => true;

  @override
  Future<AppLocalizations> load(_) async {
    final AppLocalizations appLocalizations = AppLocalizations();
    await appLocalizations.load();
    return appLocalizations;
  }

  @override
  bool shouldReload(_) => false;
}
