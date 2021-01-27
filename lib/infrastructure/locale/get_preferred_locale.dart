import 'dart:ui';

import 'package:meta/meta.dart';

import '../../core/device/utils/i_device_locale.dart';
import '../../core/locale/i_locale_repository.dart';

class GetPreferredLocale {
  final IDeviceLocale deviceLocale;
  final ILocaleRepository localeRepository;

  GetPreferredLocale({
    @required this.deviceLocale,
    @required this.localeRepository,
  });

  Future<Locale> call({
    @required List<Locale> appLocales,
    @required Locale fallbackLocale,
  }) async {
    final preferredLocaleDevice = await deviceLocale.getPreferredLocale();
    final appLocalePreferredInDevice = localeRepository.findAppLocalePreferredInDevice(
      preferredLocaleDevice: preferredLocaleDevice,
      appLocales: appLocales,
    );
    final preferredLocale = localeRepository.getPreferredOrFallbackLocale(
      appLocale: appLocalePreferredInDevice,
      fallbackLocale: fallbackLocale,
    );
    return preferredLocale;
  }
}
