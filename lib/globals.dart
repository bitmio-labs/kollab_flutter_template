import 'package:kollab_theme/kollab_theme.dart';

KollabTheme theme;

setupGlobals() async {
  theme = await KollabTheme.defaultTheme;
}
