import 'package:kollab_contacts/kollab_contacts.dart';

import 'StyleGuide.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'services/navigation_service.dart';
import 'locator.dart';

import 'Activities.dart';
import 'Dashboard.dart';
import 'Timeline.dart';
import 'DocumentsList.dart';
import 'globals.dart';
import 'model/AppState.dart';

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

  _LoggedInState({this.currentIndex});
  final NavigationService _navigationService = locator<NavigationService>();

  final tabs = [
    Tab(
        name: "Home",
        route: '/home',
        icon: OMIcons.home,
        body: (state) => DashboardTab(model: state.dashboard)),
    Tab(
        name: "Schritte",
        route: '/cards',
        icon: Icons.check_circle_outline,
        body: (state) => TimelineTab(phases: state.phases)),
    Tab(
        name: "Aktivitäten",
        route: '/activities',
        icon: Icons.notifications_none,
        body: (state) => ActivitiesTab(
              activities: state.activities,
            )),
    Tab(
      name: "Dokumente",
      route: '/files',
      icon: OMIcons.insertDriveFile,
      body: (state) => DocumentsScene(documents: state.documents),
    ),
    Tab(
        name: "Team",
        route: '/contacts',
        icon: Icons.person_outline,
        body: (state) => ContactsScene(contacts: state.contacts, theme: theme))
  ];

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
//
//    setState(() {
//      currentIndex = index;
//    });
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
