import 'dart:ui';

import 'package:meta/meta.dart';

abstract class ILocaleRepository {
  List<Locale> listLocalesAvailableInAssets({
    @required Map<String, dynamic> files,
    @required String fileExtension,
  });
  Locale findAppLocalePreferredInDevice({
    @required Locale preferredLocaleDevice,
    @required List<Locale> appLocales,
  });
  Locale getPreferredOrFallbackLocale({
    @required Locale appLocale,
    @required Locale fallbackLocale,
  });
}
