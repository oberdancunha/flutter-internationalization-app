import 'dart:ui';

import 'package:meta/meta.dart';

import '../../core/locale/i_locale_repository.dart';

class LocaleRepository implements ILocaleRepository {
  @override
  List<Locale> listLocalesAvailableInAssets({
    @required Map<String, dynamic> files,
    @required String fileExtension,
  }) {
    final extensionToSearch = fileExtension.contains('.') ? fileExtension : '.$fileExtension';
    return files.keys.where(
      (filePathkey) {
        return filePathkey.contains(extensionToSearch);
      },
    ).map(
      (filePath) {
        final separateDirectoriesAndFile = filePath.split('/');
        final fileNameExtension = separateDirectoriesAndFile.last;
        final fileName = fileNameExtension.replaceAll(extensionToSearch, '');
        if (fileName.contains('-')) {
          final fileNameLocale = fileName.split('-');
          final languageCode = fileNameLocale.first;
          final countryCode = fileNameLocale.last;
          return Locale(languageCode, countryCode);
        }
        return Locale(fileName);
      },
    ).toList();
  }

  @override
  Locale findAppLocalePreferredInDevice({
    @required Locale preferredLocaleDevice,
    @required List<Locale> appLocales,
  }) {
    final appLocalesPreferredInDevice = _findLocaleByLanguageAndCountryCode(
      preferredLocaleDevice: preferredLocaleDevice,
      appLocales: appLocales,
    );
    return appLocalesPreferredInDevice ??
        _findFirstLocaleByLanguageCode(
          preferredLocaleDevice: preferredLocaleDevice,
          appLocales: appLocales,
        );
  }

  Locale _findLocaleByLanguageAndCountryCode({
    @required Locale preferredLocaleDevice,
    @required List<Locale> appLocales,
  }) {
    final appLocalesPreferredInDevice = appLocales.firstWhere(
      (appLocale) {
        if (preferredLocaleDevice.countryCode != null) {
          return appLocale.languageCode == preferredLocaleDevice.languageCode &&
              appLocale.countryCode == preferredLocaleDevice.countryCode;
        }
        return false;
      },
      orElse: () => null,
    );
    return appLocalesPreferredInDevice;
  }

  Locale _findFirstLocaleByLanguageCode({
    @required Locale preferredLocaleDevice,
    @required List<Locale> appLocales,
  }) {
    Locale localeByLanguageAndDifferentCountry;
    final appLocalesPreferredInDevice = appLocales.singleWhere(
      (appLocale) {
        if (appLocale.languageCode == preferredLocaleDevice.languageCode) {
          if (appLocale.countryCode == null ||
              appLocale.languageCode == appLocale.countryCode.toLowerCase()) {
            return true;
          } else {
            localeByLanguageAndDifferentCountry ??= appLocale;
          }
        }
        return false;
      },
      orElse: () => localeByLanguageAndDifferentCountry,
    );
    return appLocalesPreferredInDevice;
  }

  @override
  Locale getPreferredOrFallbackLocale({
    @required Locale appLocale,
    @required Locale fallbackLocale,
  }) {
    return appLocale ?? fallbackLocale;
  }
}
