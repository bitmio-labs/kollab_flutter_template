import 'package:kollab_contacts/kollab_contacts.dart';

import 'Dashboard.dart';
import 'StyleGuide.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'model/AppState.dart';
import 'services/navigation_service.dart';
import 'locator.dart';

import 'Activities.dart';
import 'Timeline.dart';
import 'DocumentsList.dart';
import 'globals.dart';
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

final iconDict = {
  'omi.home': OMIcons.home,
  'check_circle_outline': Icons.check_circle_outline,
  'notifications_none': Icons.notifications_none,
  'omi.insertDriveFile': OMIcons.insertDriveFile,
  'person_outline': Icons.person_outline
};

IconData iconFromName(String name) {
  final icon = iconDict[name];

  if (icon == null) {
    return Icons.home;
  }

  return icon;
}

Widget widgetFromType(String type, AppState state) {
  switch (type) {
    case 'dashboard':
      return DashboardTab(model: state.dashboard);
    case 'card_list':
      return TimelineTab(phases: state.phases);
    case 'activity_list':
      return ActivitiesTab(activities: state.activities);
    case 'document_list':
      return DocumentsScene(documents: state.documents);
    case 'contact_list':
      return ContactsScene(contacts: state.contacts, theme: theme);
    default:
      return PlaceholderWidget('Unknown widget of type $type');
  }
}

class _LoggedInState extends State<LoggedIn> {
  int currentIndex;
  final theme = BitmioTheme.shared;

  _LoggedInState({this.currentIndex});
  final NavigationService _navigationService = locator<NavigationService>();

  final tabs = BitmioTheme.shared.tabs
      .map((e) => Tab(
          name: e.name,
          route: '/${e.id}',
          icon: iconFromName(e.icon),
          body: (state) => widgetFromType(e.widget.type, state)))
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

class PlaceholderWidget extends StatelessWidget {
  final String title;

  PlaceholderWidget(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}
