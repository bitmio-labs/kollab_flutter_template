import 'package:kollab_template/tabs/helpers.dart';

import 'Settings.dart';
import 'styleguide.dart';
import 'package:flutter/material.dart';
import 'model/AppState.dart';
import 'services/navigation_service.dart';
import 'helpers/locator.dart';
import 'theme.dart';

class Tab {
  String name;
  String route;
  IconData icon;
  Widget Function(AppState state) body;
  Tab({this.name, this.route, this.icon, this.body});
}

class LoggedIn extends StatefulWidget {
  final AppState appState;
  final Function() reloadState;
  final int index;

  LoggedIn({this.appState, this.reloadState, this.index});

  @override
  State<StatefulWidget> createState() {
    return _LoggedInState(currentIndex: index);
  }
}

class AppModel {
  String logo;
  String name;

  AppModel({this.logo, this.name});
}

class _LoggedInState extends State<LoggedIn> {
  int currentIndex;
  final theme = BitmioTheme.shared;

  _LoggedInState({this.currentIndex});
  final NavigationService _navigationService = locator<NavigationService>();

  final tabs = BitmioTheme.shared.tabs
      .map((e) => Tab(
          name: e.title,
          route: e.url,
          icon: iconFromName(e.icon),
          body: (state) => widgetFromType(e, state)))
      .toList();

  @override
  Widget build(BuildContext context) {
    final drawerContent = DrawerContent(model: widget.appState.settings);
    final apps = [
      AppModel(
          name: 'Bien-Zenker Service Center',
          logo: 'http://api.bitmio.com/icons/bienzenker_logo.png'),
      AppModel(
          name: 'Living Haus Baucockpit',
          logo: 'http://api.bitmio.com/icons/livinghaus_logo.png'),
      AppModel(
          name: 'Bitmio Maker',
          logo:
              'https://pbs.twimg.com/profile_images/876542796924166144/g2HzOhOE_400x400.jpg')
    ];

    final appItems = apps
        .map((e) => Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      e.logo,
                      width: 60,
                      height: 60,
                    )),
                SizedBox(height: 6),
                Container(
                  alignment: Alignment.center,
                  width: 90,
                  child: Text(
                    e.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                )
              ],
            ))
        .toList();

    final appItemWrap = Wrap(
      spacing: 10,
      direction: Axis.vertical,
      children: appItems,
    );

    final appSwitcher = ListView(children: [
      SizedBox(height: 10),
      Center(child: appItemWrap),
      SizedBox(
        height: 20,
      ),
      Icon(
        Icons.add,
        color: Colors.white70,
      )
    ]);

    final screenWidth = MediaQuery.of(context).size.width;
    final appSwitcherWidth = 110.0;
    final maxMenuWidth = 250.0;
    final showAppSwitcher = false;
    final maxWidth = maxMenuWidth + (showAppSwitcher ? appSwitcherWidth : 0);
    final drawerWidth = screenWidth < maxWidth ? screenWidth : maxWidth;

    final drawerColumns = Row(children: [
      if (showAppSwitcher)
        Container(
            width: appSwitcherWidth,
            alignment: Alignment.center,
            color: Colors.black87,
            child: appSwitcher),
      Expanded(child: drawerContent)
    ]);

    return Scaffold(
      drawer: SizedBox(width: drawerWidth, child: Drawer(child: drawerColumns)),
      appBar: AppBar(
        title: Text(tabs[currentIndex].name),
      ),
      body: tabs[currentIndex].body(widget.appState),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: StyleGuide().tabIconColor,
        onTap: onTabTapped,
        currentIndex: currentIndex,
        unselectedFontSize: 12,
        selectedFontSize: 12,
        iconSize: 30,
        items: tabs
            .map((each) => BottomNavigationBarItem(
                  icon: Icon(each.icon),
                  title: new Text(each.name),
                ))
            .toList(),
      ),
    );
  }

  void onTabTapped(int index) {
    widget.reloadState();
    final tab = tabs[index];
    _navigationService.navigateTo(tab.route);
  }
}
