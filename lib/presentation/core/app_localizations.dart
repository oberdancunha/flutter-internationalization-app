import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/number_symbols_data.dart';

import '../../core/locale/i_locale_repository.dart';
import '../../infrastructure/locale/get_preferred_locale.dart';
import 'app_localizations_delegate.dart';

class AppLocalizations {
  final localeRepository = Modular.get<ILocaleRepository>();
  final getPreferredLocale = Modular.get<GetPreferredLocale>();
  final _fileExtension = 'json';
  final _fallbackLocale = const Locale('en', 'US');
  Map<String, String> _localizedMessages;

  static AppLocalizations of(BuildContext context) => Localizations.of<AppLocalizations>(
        context,
        AppLocalizations,
      );

  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationsDelegate();

  Future<bool> load() async {
    final appLocales = await _getLocalesAvailableInAssets();
    final preferredLocale = await getPreferredLocale(
      appLocales: appLocales,
      fallbackLocale: _fallbackLocale,
    );
    await _loadPreferredLocale(preferredLocale);
    return true;
  }

  Future<List<Locale>> _getLocalesAvailableInAssets() async {
    final jsonFilesAssets = await rootBundle.loadString('AssetManifest.json');
    final filesInAssets = json.decode(jsonFilesAssets) as Map<String, dynamic>;
    final appLocales = localeRepository.listLocalesAvailableInAssets(
      files: filesInAssets,
      fileExtension: _fileExtension,
    );
    return appLocales;
  }

  Future<void> _loadPreferredLocale(Locale preferredLocale) async {
    final preferredLocaleAnyPlatform = preferredLocale.toString().replaceFirst('_', '-');
    final String jsonMessages = await rootBundle.loadString(
      'assets/i18n/$preferredLocaleAnyPlatform.$_fileExtension',
    );
    final jsonMessagesMap = json.decode(jsonMessages) as Map<String, dynamic>;
    _localizedMessages = jsonMessagesMap.map(
      (key, value) => MapEntry(key, value.toString()),
    );
  }

  String translate(String key) {
    return _localizedMessages[key];
  }

  static List<Locale> get supportedLocales => numberFormatSymbols.keys
          .where((languageAndCountryCode) => languageAndCountryCode.toString().contains('_'))
          .map((languageAndCountryCode) => languageAndCountryCode.toString().split('_'))
          .map(
        (languageAndCountryCode) {
          final languageCode = languageAndCountryCode[0];
          final countryCode = languageAndCountryCode[1];
          return Locale(languageCode, countryCode);
        },
      ).toList();
}
