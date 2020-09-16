library kollab_template;

import 'package:flutter/material.dart';
import 'package:kollab_template/kollab_bloc.dart';
import 'app.dart';
import 'helpers/locator.dart' as di;
import 'globals.dart';

void runKollab({url}) async {
  WidgetsFlutterBinding.ensureInitialized();

  di.setupLocator();
  await setupGlobals();

  final bloc = KollabBloc(url: url);
  bloc.load();

  runApp(KollabWrapper(bloc: bloc));
}
