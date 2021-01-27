import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:internationalizationapp/infrastructure/locale/locale_repository.dart';

import '../../data/json_reader.dart';

void main() {
  LocaleRepository localeRepository;
  List<Locale> appLocales;
  final filesInAssets = jsonReader('assets.json');

  setUp(() {
    localeRepository = LocaleRepository();
    appLocales = const [
      Locale('de', 'DE'),
      Locale('en', 'US'),
      Locale('es', 'AR'),
      Locale('es'),
      Locale('pt', 'BR'),
      Locale('pt', 'PT'),
    ];
  });

  group('listLocalesAvailableInAssets\n', () {
    test(
      '\tShould list all locales available in assets/i18n',
      () async {
        final locales = localeRepository.listLocalesAvailableInAssets(
          files: filesInAssets,
          fileExtension: 'json',
        );
        expect(locales, equals(appLocales));
      },
    );

    test(
      '''\tShould list locales available in assets/i18n using dot before extension 
      in fileExtension parameter''',
      () async {
        final locales = localeRepository.listLocalesAvailableInAssets(
          files: filesInAssets,
          fileExtension: '.json',
        );
        expect(locales, equals(appLocales));
      },
    );

    test(
      '\tShould not found none locale when file extension not exists',
      () async {
        final locales = localeRepository.listLocalesAvailableInAssets(
          files: filesInAssets,
          fileExtension: 'xml',
        );
        expect(locales.length, isZero);
      },
    );
  });

  group(
    'findAppLocalesPreferredInDevice\n',
    () {
      group('\tLocales found\n', () {
        void testLocalesFound(Locale preferredLocaleDevice) {
          final appLocalesPreferredInDevice = localeRepository.findAppLocalePreferredInDevice(
            preferredLocaleDevice: preferredLocaleDevice,
            appLocales: appLocales,
          );
          expect(appLocalesPreferredInDevice, isNot(null));
        }

        test(
          '''\t\tShould find locales in the app according to the preference on the device, 
          verifying the language code and the country code''',
          () {
            testLocalesFound(const Locale('pt', 'BR'));
          },
        );

        test(
          '''\t\tShould find locales in the app according to the preference on the device, 
          verifying the language code and the country code, but finding only by language 
          code''',
          () {
            final appLocalesPreferredInDevice = localeRepository.findAppLocalePreferredInDevice(
              preferredLocaleDevice: const Locale('es', 'CO'),
              appLocales: appLocales,
            );
            expect(appLocalesPreferredInDevice, equals(const Locale('es')));
          },
        );

        test(
          '''\t\tShould find locales in the app according to the preference on the device, 
          verifying only language code''',
          () {
            testLocalesFound(const Locale('es'));
          },
        );
      });

      group('\tLocales not found\n', () {
        void testLocaleNotFound(Locale preferredLocaleDevice) {
          final appLocalesPreferredInDevice = localeRepository.findAppLocalePreferredInDevice(
            preferredLocaleDevice: preferredLocaleDevice,
            appLocales: appLocales,
          );
          expect(appLocalesPreferredInDevice, equals(null));
        }

        test(
          '''\t\tShould not find locale in the app according to the preference on the 
          device, verifying the language code and the country code''',
          () {
            testLocaleNotFound(const Locale('fr', 'FR'));
          },
        );

        test(
          '''\t\tShould not find locale in the app according to the preference on the 
          device, verifying only language code''',
          () {
            testLocaleNotFound(const Locale('fr'));
          },
        );
      });
    },
  );

  group(
    'getPreferredOrFallbackLocale\n',
    () {
      test(
        '''\tShould get app locale when device preferred locale was found''',
        () {
          const appLocale = Locale('pt', 'BR');
          final preferredLocale = localeRepository.getPreferredOrFallbackLocale(
            appLocale: appLocale,
            fallbackLocale: const Locale('en', 'US'),
          );
          expect(preferredLocale, equals(appLocale));
        },
      );

      test(
        '''\tShould get fallback locale when device preferred locale not found in 
        app locale''',
        () {
          const fallbackLocale = Locale('en', 'US');
          final preferredLocale = localeRepository.getPreferredOrFallbackLocale(
            appLocale: null,
            fallbackLocale: fallbackLocale,
          );
          expect(preferredLocale, equals(fallbackLocale));
        },
      );
    },
  );
}
