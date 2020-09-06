// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'helpers/locator.dart';
import 'services/navigation_service.dart';
import 'theme.dart';

import 'onboarding.dart';
import 'settings.dart';
import 'styleguide.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'model/AppState.dart';
import 'API.dart';
import 'home.dart';
import 'package:kollab_auth/kollab_auth.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  final BitmioTheme theme = BitmioTheme.shared;

  final API api = API.shared;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final NavigationService _navigationService = locator<NavigationService>();

  AppState appState = API.shared.cachedAppState ?? AppState(isLoggedIn: false);

  var isLoading = false;
  bool _isConfigured = false;

  @override
  Widget build(BuildContext context) {
    final background = Image.asset(
      'images/welcome.jpg',
      fit: BoxFit.cover,
    );
    final BitmioTheme theme = BitmioTheme.shared;

    final logoImage = Image.asset('images/logo.png');

    FirebaseAnalytics analytics = FirebaseAnalytics();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: BitmioTheme.shared.primary_color_obj,
        fontFamily: "OpenSans",
        backgroundColor: Colors.red,
        textTheme: TextTheme(
            headline5: TextStyle(fontSize: 30, color: Colors.black),
            bodyText2: StyleGuide().textStyle,
            subtitle1: StyleGuide().checklistStyle),
        buttonTheme: ButtonThemeData(
          padding: EdgeInsets.only(left: 60, right: 60, top: 15, bottom: 15),
          buttonColor: BitmioTheme.shared.primary_color_obj, //  <-- dark color
          textTheme:
              ButtonTextTheme.primary, //  <-- this auto selects the right color
        ),
      ),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      navigatorKey: locator<NavigationService>().navigationKey,
      initialRoute: api.isLoggedIn ? '/home' : '/onboarding',
      routes: {
        '/': (context) => Placeholder(),
        '/welcome': (context) => WelcomeWidget(
              loginLabel: theme.welcome.login_button_title,
              discoverLabel: theme.welcome.discover_button_title,
              heroText: theme.welcome.hero_title,
              registerLabel: theme.welcome.signup_button_title,
              backgroundImage: background,
              logo: logoImage,
            ),
        '/login': (context) => HeaderDetailWidget(
            detail: LoginForm(
              onCompletion: (data, cb) => login(data, cb, context),
              passwordLabel: 'Passwort',
              signupLabel: theme.login.login_button_title,
              forgotLoginLabel: theme.login.forgot_login_button_title,
              forgotLoginUrl: '${theme.domain}/forgot-login',
            ),
            background: background,
            logo: logoImage),
        '/signup': (context) => HeaderDetailWidget(
            detail: SignupForm(
              onCompletion: (data, cb) => signup(data, cb, context),
              passwordLabel: 'Passwort',
              signupLabel: theme.signup.signup_button_title,
              dataPolicyLabel: theme.signup.privacy_link_title,
              dataPolicyURL: theme.signup.privacy_link,
            ),
            background: background,
            logo: logoImage),
        '/explore': (context) =>
            LoggedIn(appState: appState, reloadState: fetchState, index: 0),
        '/onboarding': (context) => BZOnboarding(),
        '/settings': (context) => SettingsWidget(model: appState.settings)
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoggedIn(
                    appState: appState, reloadState: fetchState, index: 0),
                transitionDuration: Duration(seconds: 0));
          case '/cards':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoggedIn(
                    appState: appState, reloadState: fetchState, index: 1),
                transitionDuration: Duration(seconds: 0));
          case '/activities':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoggedIn(
                    appState: appState, reloadState: fetchState, index: 2),
                transitionDuration: Duration(seconds: 0));
          case '/files':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoggedIn(
                    appState: appState, reloadState: fetchState, index: 3),
                transitionDuration: Duration(seconds: 0));
          case '/contacts':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoggedIn(
                    appState: appState, reloadState: fetchState, index: 4),
                transitionDuration: Duration(seconds: 0));
          default:
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => Placeholder(),
                transitionDuration: Duration(seconds: 0));
        }
      },
//        initialRoute: appState.isLoggedIn ? '/home' : '/login'
    );
  }

  @override
  void initState() {
    super.initState();

    fetchState();
  }

  fetchState() async {
    print("Fetching state");
    if (isLoading) {
      print('Cancel fetching');
      return;
    }

    if (api.isLoggedIn) {
      _firebaseMessaging.requestNotificationPermissions();
      if (!_isConfigured) {
        configureFcm();
      }
      _isConfigured = true;
    }

    final token = await _firebaseMessaging.getToken();

    isLoading = true;
    api.fetchState(token).then((state) {
      print("State fetched");
      isLoading = false;

      if (this.mounted) {
        setState(() {
          this.appState = state;
        });
      }
    });
  }

  void configureFcm() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
      if (api.isLoggedIn) {
        _navigationService.navigateTo('/activities');
      } else {
        _navigationService.navigateTo('/login');
      }
    },
        // called when the app has been closed and it's opened
        // from the push notification directly
        onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch: $message');
      if (api.isLoggedIn) {
        _navigationService.navigateTo('/activities');
      } else {
        _navigationService.navigateTo('/login');
      }
    },
        // called when the app is in the background and it's opened from the
        // push notification
        onResume: (Map<String, dynamic> message) async {
      print('onResume: $message');
      if (api.isLoggedIn) {
        _navigationService.navigateTo('/activities');
      } else {
        _navigationService.navigateTo('/login');
      }
    });
  }

  login(LoginModel data, Function callback, BuildContext context) async {
    final success = await api.login(data);

    if (!success) {
      showAlert(context, 'Login fehlgeschlagen', 'Versuchen Sie es erneut.');
      callback();
      return;
    }

    fetchState();

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  signup(SignupModel data, Function callback, BuildContext context) async {
    final success = await api.signup(data);

    if (!success) {
      showAlert(
          context, 'Registrierung fehlgeschlagen', 'Versuchen Sie es erneut.');
      callback();
      return;
    }

    fetchState();

    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> showAlert(BuildContext context, String title, String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class MyLogin extends StatefulWidget {
  @override
  _MyLoginState createState() {
    return _MyLoginState();
  }
}

class _MyLoginState extends State<MyLogin> {
  @override
  Widget build(BuildContext context) {
    return LoginForm(
      onCompletion: (data, callback) => {},
    );
  }
}
