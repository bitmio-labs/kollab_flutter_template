import 'dart:ui';

import 'package:kollab_template/kollab_bloc.dart';
import 'package:kollab_template/pages/helpers.dart';
import 'package:kollab_template/theme.dart';

import 'shared/section_title.dart';
import 'model/AppState.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'helpers/locator.dart';
import 'services/navigation_service.dart';

import 'API.dart';

class SidebarContent extends StatelessWidget {
  final KollabBloc bloc;
  API get api => bloc.model.api;
  final AppState model;

  SidebarContent({this.model, this.bloc});

  @override
  Widget build(BuildContext context) {
    final sections = bloc.model.theme.sidebar
        .map((e) => SidebarSection(bloc: bloc, model: e, appState: model))
        .toList();
    return ListView(children: sections);
  }
}

class SidebarSectionHeader extends StatelessWidget {
  final String title;

  SidebarSectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12, top: 20, bottom: 10),
      child: SectionTitle(title),
    );
  }
}

class SidebarSection extends StatelessWidget {
  final KollabBloc bloc;
  final NavigationSection model;
  final AppState appState;

  SidebarSection({this.bloc, this.model, this.appState});

  @override
  Widget build(BuildContext context) {
    final items = model.items
        .map((e) => showItem(e, appState)
            ? SidebarItem(bloc: bloc, model: e, appState: appState)
            : null)
        .toList();

    items.removeWhere((e) => e == null);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SidebarSectionHeader(model.title), ...items]);
  }

  bool showItem(PageModel item, AppState appState) {
    if (item.data == null) return true;

    final data = appState.dataForKey(item.data);

    return data != null;
  }
}

class SidebarItem extends StatelessWidget {
  final KollabBloc bloc;
  final PageModel model;
  final AppState appState;
  final NavigationService _navigationService = locator<NavigationService>();

  String get title {
    switch (model.url) {
      case '/account_details':
        return appState.account.email;
      default:
        return model.title;
    }
  }

  bool get showArrow {
    switch (model.url) {
      case '/account_details':
        return false;
      default:
        return true;
    }
  }

  SidebarItem({this.bloc, this.model, this.appState});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      title: Text(
        title,
        style: TextStyle(fontSize: 14),
      ),
      visualDensity: VisualDensity.compact,
      leading: model.icon != null ? Icon(iconFromName(model.icon)) : null,
      trailing: showArrow ? Icon(Icons.chevron_right) : null,
      onTap: () => onTap(context),
    );
  }

  onTap(BuildContext context) {
    switch (model.url) {
      case '/account_details':
        return;
      case '/logout':
        return logout(context);
      case '/change_password':
        return openUrl(appState.account.change_password_url);
      default:
        openUrl(model.url);
    }
  }

  logout(BuildContext context) {
    bloc.model.api.accessToken = null;
    _navigationService.navigateTo('/onboarding');
  }

  openUrl(String url) async {
    print("Opening url $url");
    if (await canLaunch(url)) {
      print("Can open url $url");
      await launch(url);
    } else {
      print("Cannot open url $url");
      throw 'Could not launch $url';
    }
  }
}
