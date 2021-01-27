import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:internationalizationapp/core/device/utils/i_device_locale.dart';
import 'package:internationalizationapp/core/locale/i_locale_repository.dart';
import 'package:internationalizationapp/infrastructure/locale/get_preferred_locale.dart';
import 'package:mockito/mockito.dart';

class MockDeviceLocale extends Mock implements IDeviceLocale {}

class MockLocaleRepository extends Mock implements ILocaleRepository {}

void main() {
  MockDeviceLocale mockDeviceLocale;
  MockLocaleRepository mockLocaleRepository;
  GetPreferredLocale getPreferredLocale;
  const devicePreferredLocale = Locale('pt', 'BR');
  const appLocales = [
    Locale('pt', 'BR'),
    Locale('en', 'US'),
  ];
  const appPreferredLocale = Locale('pt', 'BR');
  const fallbackLocale = Locale('en', 'US');

  setUp(() {
    mockDeviceLocale = MockDeviceLocale();
    mockLocaleRepository = MockLocaleRepository();
    getPreferredLocale = GetPreferredLocale(
      deviceLocale: mockDeviceLocale,
      localeRepository: mockLocaleRepository,
    );
  });

  void setUpMockGetPreferredDeviceLocale() {
    when(mockDeviceLocale.getPreferredLocale()).thenAnswer(
      (_) async => devicePreferredLocale,
    );
  }

  void setUpMockFindAppLocalePreferredInDevice() {
    when(mockLocaleRepository.findAppLocalePreferredInDevice(
      preferredLocaleDevice: anyNamed('preferredLocaleDevice'),
      appLocales: anyNamed('appLocales'),
    )).thenReturn(
      appPreferredLocale,
    );
  }

  void setUpMockGetPreferredLocale() {
    when(mockLocaleRepository.getPreferredOrFallbackLocale(
      appLocale: anyNamed('appLocale'),
      fallbackLocale: anyNamed('fallbackLocale'),
    )).thenReturn(
      appPreferredLocale,
    );
  }

  void setUpMockGetFallbackLocale() {
    when(mockLocaleRepository.getPreferredOrFallbackLocale(
      appLocale: anyNamed('appLocale'),
      fallbackLocale: anyNamed('fallbackLocale'),
    )).thenReturn(
      fallbackLocale,
    );
  }

  test(
    'Should get locale according preferred in device',
    () async {
      setUpMockGetPreferredDeviceLocale();
      setUpMockFindAppLocalePreferredInDevice();
      setUpMockGetPreferredLocale();
      final preferredLocale = await getPreferredLocale(
        appLocales: appLocales,
        fallbackLocale: fallbackLocale,
      );
      expect(preferredLocale, equals(appLocales.first));
    },
  );

  test(
    'Should get fallbackLocale when preferred locale in device not found',
    () async {
      setUpMockGetPreferredDeviceLocale();
      setUpMockFindAppLocalePreferredInDevice();
      setUpMockGetFallbackLocale();
      final preferredLocale = await getPreferredLocale(
        appLocales: appLocales,
        fallbackLocale: fallbackLocale,
      );
      expect(preferredLocale, equals(fallbackLocale));
    },
  );
}
