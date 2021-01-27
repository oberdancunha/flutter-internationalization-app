import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/device/utils/i_device_locale.dart';
import '../../core/locale/i_locale_repository.dart';
import '../../device/utils/device_locale.dart';
import '../../infrastructure/locale/get_preferred_locale.dart';
import '../../infrastructure/locale/locale_repository.dart';
import '../home/home_page.dart';
import 'app_widget.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind<IDeviceLocale>(
          (i) => DeviceLocale(),
        ),
        Bind<ILocaleRepository>(
          (i) => LocaleRepository(),
        ),
        Bind<GetPreferredLocale>(
          (i) => GetPreferredLocale(
            deviceLocale: i.get<IDeviceLocale>(),
            localeRepository: i.get<ILocaleRepository>(),
          ),
        )
      ];

  @override
  Widget get bootstrap => AppWidget();

  @override
  List<ModularRouter> get routers => [
        ModularRouter(
          '/',
          child: (_, __) => HomePage(),
        ),
      ];
}
