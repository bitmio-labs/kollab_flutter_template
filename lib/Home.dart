import 'package:kollab_template/tabs/helpers.dart';

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
          body: (state) => widgetFromType(e.widget, state)))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: currentIndex == 0
            ? IconButton(
                icon: new Icon(Icons
                    .settings /*, color: StyleGuide().navigationBarButtonColor*/),
                onPressed: () {
                  _navigationService.pushNamed('/settings');
                },
              )
            : null,
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
