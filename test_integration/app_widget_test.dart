import 'dart:ui';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:internationalizationapp/core/locale/i_locale_repository.dart';
import 'package:internationalizationapp/infrastructure/locale/get_preferred_locale.dart';
import 'package:internationalizationapp/presentation/core/app_module.dart';
import 'package:internationalizationapp/presentation/core/app_widget.dart';
import 'package:internationalizationapp/presentation/home/home_page.dart';
import 'package:mockito/mockito.dart';

class MockLocaleRepository extends Mock implements ILocaleRepository {}

class MockGetPreferredLocale extends Mock implements GetPreferredLocale {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  MockGetPreferredLocale mockGetPreferredLocale;
  MockLocaleRepository mockLocaleRepository;
  const appLocales = [
    Locale('de', 'DE'),
    Locale('en', 'US'),
    Locale('es'),
    Locale('fr', 'FR'),
    Locale('it'),
    Locale('pt', 'BR'),
    Locale('pt', 'PT'),
  ];
  const preferredLocale = Locale('pt', 'PT');

  setUp(() {
    mockGetPreferredLocale = MockGetPreferredLocale();
    mockLocaleRepository = MockLocaleRepository();
    initModule(
      AppModule(),
      initialModule: true,
      changeBinds: [
        Bind<ILocaleRepository>(
          (i) => mockLocaleRepository,
        ),
        Bind<GetPreferredLocale>(
          (i) => mockGetPreferredLocale,
        )
      ],
    );
  });

  testWidgets(
    'Test locale integration app',
    (WidgetTester tester) async {
      when(
        mockLocaleRepository.listLocalesAvailableInAssets(
          files: anyNamed('files'),
          fileExtension: anyNamed('fileExtension'),
        ),
      ).thenReturn(appLocales);
      when(
        mockGetPreferredLocale(
          appLocales: anyNamed('appLocales'),
          fallbackLocale: anyNamed('fallbackLocale'),
        ),
      ).thenAnswer(
        (_) async => preferredLocale,
      );
      await tester.pumpWidget(AppWidget());
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    },
  );
}
