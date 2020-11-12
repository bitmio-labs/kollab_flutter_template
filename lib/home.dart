import 'kollab_bloc.dart';
import 'sidebar.dart';
import 'pages/helpers.dart';

import 'api.dart';
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
  final KollabBloc bloc;
  final AppState appState;
  final Function() reloadState;
  final String route;

  LoggedIn(
      {@required this.bloc,
      @required this.appState,
      this.reloadState,
      this.route});

  @override
  State<StatefulWidget> createState() {
    final tabs = bloc.model.theme.tabs
        .map((e) => Tab(
            name: e.title,
            route: e.url,
            icon: iconFromName(e.icon),
            body: (state) => widgetFromType(e, state, bloc)))
        .toList();

    return _LoggedInState(currentRoute: route, tabs: tabs);
  }
}

class _LoggedInState extends State<LoggedIn> {
  String currentRoute;
  BitmioTheme get theme => widget.bloc.model.theme;
  API get api => widget.bloc.model.api;

  _LoggedInState({this.currentRoute, this.tabs});
  final NavigationService _navigationService = locator<NavigationService>();

  final List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(bloc: widget.bloc, appState: widget.appState),
      appBar: AppBar(
        title: Text(tabForRoute(currentRoute).name),
      ),
      body: tabForRoute(currentRoute).body(widget.appState),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: StyleGuide().tabIconColor,
        onTap: onTabTapped,
        currentIndex: indexForRoute(currentRoute),
        unselectedFontSize: 12,
        selectedFontSize: 12,
        iconSize: 30,
        items: tabs
            .map((each) => BottomNavigationBarItem(
                  icon: Icon(each.icon),
                  label: each.name,
                ))
            .toList(),
      ),
    );
  }

  int indexForRoute(String route) {
    final idx = tabs.indexWhere((element) => element.route == route);

    if (idx == -1) {
      return 0;
    }

    return idx;
  }

  Tab tabForRoute(String route) {
    return tabs.firstWhere((element) => element.route == route,
        orElse: () => tabs.first);
  }

  void onTabTapped(int index) {
    widget.reloadState();
    final tab = tabs[index];
    _navigationService.navigateTo(tab.route);
  }
}
