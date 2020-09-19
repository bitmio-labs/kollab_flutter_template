import 'package:flutter/material.dart';
import 'package:kollab_template/kollab_bloc.dart';
import 'package:kollab_template/model/AppState.dart';

import 'app_switcher.dart';
import 'sidebar_content.dart';

class Sidebar extends StatelessWidget {
  final KollabAppModel appModel;
  final AppState appState;

  Sidebar({this.appModel, this.appState});

  @override
  Widget build(BuildContext context) {
    final drawerContent =
        SidebarContent(model: appState.settings, api: appModel.api);

    final screenWidth = MediaQuery.of(context).size.width;
    final appSwitcherWidth = 110.0;
    final maxMenuWidth = 250.0;
    final showAppSwitcher = appModel.theme.has_app_switcher;
    final maxWidth = maxMenuWidth + (showAppSwitcher ? appSwitcherWidth : 0);
    final drawerWidth = screenWidth < maxWidth ? screenWidth : maxWidth;

    final drawerColumns = Row(children: [
      if (showAppSwitcher)
        AppSwitcher(apps: appModel.appDirectory.items, width: appSwitcherWidth),
      Expanded(child: drawerContent)
    ]);

    return SizedBox(width: drawerWidth, child: Drawer(child: drawerColumns));
  }
}
