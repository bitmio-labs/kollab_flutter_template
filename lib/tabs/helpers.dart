import 'package:flutter/material.dart';
import 'package:kollab_contacts/kollab_contacts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../shared/placeholder_widget.dart';
import '../model/AppState.dart';
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
      return CardListTab(phases: state.phases);
    case 'activity_list':
      return ActivitiesTab(activities: state.activities);
    case 'document_list':
      return DocumentsListTab(documents: state.documents);
    case 'contact_list':
      return ContactsScene(contacts: state.contacts, theme: theme);
    default:
      return PlaceholderWidget('Unknown widget of type $type');
  }
}
