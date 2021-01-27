import 'dart:ui';

import 'package:devicelocale/devicelocale.dart';

import '../../core/device/utils/i_device_locale.dart';

class DeviceLocale implements IDeviceLocale {
  @override
  Future<List<Locale>> listPreferredLocales() async {
    final locales = await Devicelocale.preferredLanguagesAsLocales;
    return List<Locale>.from(locales);
  }

  @override
  Future<Locale> getPreferredLocale() async {
    final locales = await listPreferredLocales();
    return locales.first;
  }
}
