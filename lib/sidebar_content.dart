import 'shared/section_title.dart';
import 'model/AppState.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'helpers/locator.dart';
import 'services/navigation_service.dart';

import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'API.dart';

String gravatarURL(String email) {
  final emailHash = md5.convert(utf8.encode(email)).toString();

  return 'https://www.gravatar.com/avatar/$emailHash?s=200&d=mp';
}

class SidebarContent extends StatelessWidget {
  final API api;
  final SettingsModel model;
  final NavigationService _navigationService = locator<NavigationService>();

  SidebarContent({this.model, this.api});

  @override
  Widget build(BuildContext context) {
    return ListView(
      //padding: EdgeInsets.zero,
      children: <Widget>[
        SidebarSectionHeader('Account'),
        if (api.isLoggedIn)
          ListTile(
              title: Text(model.email), leading: Icon(Icons.account_circle)),
        if (api.isLoggedIn)
          ListTile(
            title: Text('Passwort ändern'),
            leading: Icon(Icons.lock),
            trailing: Icon(Icons.chevron_right),
            onTap: () => openUrl(model.change_password_url),
          ),
        ListTile(
          title: Text('Ausloggen'),
          leading: Icon(Icons.exit_to_app),
          trailing: Icon(Icons.chevron_right),
          onTap: () => logout(context),
        ),
        SidebarSectionHeader('Folge uns'),
        ListTile(
          title: Text('Facebook'),
          leading: Icon(MdiIcons.facebook),
          trailing: Icon(Icons.chevron_right),
          onTap: () => openUrl(model.facebook_url),
        ),
        ListTile(
          title: Text('Instagram'),
          leading: Icon(MdiIcons.instagram),
          trailing: Icon(Icons.chevron_right),
          onTap: () => openUrl(model.instagram_url),
        ),
        SidebarSectionHeader('Rechtliches'),
        ListTile(
          title: Text('Impressum'),
          trailing: Icon(Icons.chevron_right),
          onTap: () => openUrl(model.legal_url),
        ),
        ListTile(
          title: Text('Datenschutz'),
          trailing: Icon(Icons.chevron_right),
          onTap: () => openUrl(model.privacy_url),
        )
      ],
    );
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

  logout(BuildContext context) {
    api.accessToken = null;
    _navigationService.navigateTo('/onboarding');
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