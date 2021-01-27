import 'dart:ui';

abstract class IDeviceLocale {
  Future<List<Locale>> listPreferredLocales();
  Future<Locale> getPreferredLocale();
}
