import 'package:flutter/material.dart';

import '../../app_localizations.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppLocalizations.of(context).translate('hello'),
          style: const TextStyle(fontSize: 30.0),
        ),
      ),
    );
  }
}
