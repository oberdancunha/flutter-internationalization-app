import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internationalizationapp/device/utils/device_locale.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  DeviceLocale deviceLocale;
  const listPreferredLocales = [
    Locale('en'),
    Locale('pt'),
  ];
  const preferredLocale = Locale('en');

  setUp(() {
    deviceLocale = DeviceLocale();
  });

  void setUpMockDevicelocale() {
    const MethodChannel(
      'uk.spiralarm.flutter/devicelocale',
    ).setMockMethodCallHandler(
      (_) async => [
        'en',
        'pt',
      ],
    );
  }

  test(
    'Should test if listPreferredLocales returns the correct preferred locale list',
    () async {
      setUpMockDevicelocale();
      final locales = await deviceLocale.listPreferredLocales();
      expect(locales, equals(listPreferredLocales));
    },
  );

  test(
    'Should test if getPreferredLocale returns the correct preferred locale',
    () async {
      setUpMockDevicelocale();
      final language = await deviceLocale.getPreferredLocale();
      expect(language, equals(preferredLocale));
    },
  );
}
