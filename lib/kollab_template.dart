library kollab_template;

import 'theme.dart';
import 'package:flutter/material.dart';
import 'API.dart';
import 'app.dart';
import 'helpers/locator.dart' as di;
import 'globals.dart';

void runKollab() async {
  WidgetsFlutterBinding.ensureInitialized();

  di.setupLocator();
  await BitmioTheme.setup();
  await API.shared.setup();
  await setupGlobals();

  runApp(Home());
}
