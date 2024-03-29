import 'package:flutter/material.dart';
import 'package:kollab_contacts/kollab_contacts.dart';
import 'package:kollab_template/kollab_bloc.dart';
import 'package:kollab_template/model/CardsModel.dart';
import 'package:kollab_template/model/DashboardModel.dart';
import 'package:kollab_template/model/DocumentsModel.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../shared/placeholder_widget.dart';
import '../model/AppState.dart';
import '../model/ActivitiesModel.dart';

import '../theme.dart';
import 'activity_list_tab.dart';
import 'card_list_tab.dart';
import 'dashboard_tab.dart';
import 'document_list_tab.dart';
import '../globals.dart';

final iconDict = {
  'omi.home': OMIcons.home,
  'check_circle_outline': Icons.check_circle_outline,
  'notifications_none': Icons.notifications_none,
  'omi.insertDriveFile': OMIcons.insertDriveFile,
  'person_outline': Icons.person_outline,
  'account_circle': Icons.account_circle,
  'settings': Icons.settings,
  'lock': Icons.lock,
  'chevron_right': Icons.chevron_right,
  'exit_to_app': Icons.exit_to_app,
  'facebook': MdiIcons.facebook,
  'instagram': MdiIcons.instagram,
  'add': Icons.add,
  'add_circle': Icons.add_circle,
  'apps': Icons.apps,
  'view_compact': Icons.view_compact
};

IconData iconFromName(String name) {
  final icon = iconDict[name];

  if (icon == null) {
    return Icons.home;
  }

  return icon;
}

Widget widgetFromType(PageModel page, AppState state, KollabBloc bloc) {
  switch (page.widget) {
    case 'dashboard':
      final json = state.dataForKey(page.data);
      final data = json != null ? DashboardModel.fromJson(json) : null;
      return DashboardTab(model: data, bloc: bloc);
    case 'card_list':
      final json = state.dataForKey(page.data);
      final data = json != null
          ? TimelinePhases.fromJson(json)
          : TimelinePhases(items: []);
      return CardListTab(subtitle: page.subtitle, phases: data, bloc: bloc);
    case 'activity_list':
      final json = state.dataForKey(page.data);
      final data = json != null
          ? ActivityListModel.fromJson(json)
          : ActivityListModel(items: []);
      return ActivitiesTab(activities: data, bloc: bloc);
    case 'document_list':
      final json = state.dataForKey(page.data);
      final data = json != null
          ? DocumentListModel.fromJson(json)
          : DocumentListModel(items: []);
      return DocumentsListTab(title: page.subtitle, documents: data);
    case 'contact_list':
      final json = state.dataForKey(page.data);
      final data = json != null ? Contacts.fromJson(json) : Contacts(items: []);
      return ContactsScene(contacts: data, theme: theme);
    case 'kollab_dashboard':
      // final json = state.dataForKey(page.data);
      // final data = json != null ? Contacts.fromJson(json) : Contacts(items: []);
      return PlaceholderWidget('Dashboard');
    default:
      print('No widget found for ${page.widget}');
      return PlaceholderWidget('Unknown widget of type ${page.widget}');
  }
}
