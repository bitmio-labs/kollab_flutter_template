import 'package:flutter/material.dart';
import 'package:kollab_contacts/kollab_contacts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import '../shared/placeholder_widget.dart';
import '../model/AppState.dart';
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
  'lock': Icons.lock,
  'chevron_right': Icons.chevron_right,
  'exit_to_app': Icons.exit_to_app,
  'facebook': MdiIcons.facebook,
  'instagram': MdiIcons.instagram
};

IconData iconFromName(String name) {
  final icon = iconDict[name];

  if (icon == null) {
    return Icons.home;
  }

  return icon;
}

Widget widgetFromType(PageModel page, AppState state) {
  switch (page.widget) {
    case 'dashboard':
      return DashboardTab(model: state.dashboard);
    case 'card_list':
      final json = state.dataForKey(page.data);
      final data = json != null
          ? TimelinePhases.fromJson(json)
          : TimelinePhases(items: []);
      return CardListTab(subtitle: page.subtitle, phases: data);
    case 'activity_list':
      return ActivitiesTab(activities: state.activities);
    case 'document_list':
      return DocumentsListTab(title: page.subtitle, documents: state.documents);
    case 'contact_list':
      return ContactsScene(contacts: state.contacts, theme: theme);
    default:
      return PlaceholderWidget('Unknown widget of type ${page.widget}');
  }
}
