// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kollab_template/kollab_bloc.dart';
import 'helpers/locator.dart';
import 'services/navigation_service.dart';
import 'theme.dart';

import 'onboarding.dart';
import 'styleguide.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'model/AppState.dart';
import 'API.dart';
import 'home.dart';
import 'package:kollab_auth/kollab_auth.dart';

class KollabWrapper extends StatelessWidget {
  final KollabBloc bloc;

  KollabWrapper({this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<KollabAppModel>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;

            if (data.isLoading) {
              return LoadingApp();
            }

            return KollabApp(bloc: bloc);
          }

          return LoadingApp();
        },
        stream: bloc.modelStream.stream);
  }
}

class LoadingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Loading...'),
          SizedBox(height: 12),
          Center(child: CircularProgressIndicator())
        ],
      ),
    ));
  }
}

class KollabApp extends StatefulWidget {
  final KollabBloc bloc;

  KollabApp({this.bloc});

  @override
  State<StatefulWidget> createState() {
    return _KollabAppState();
  }
}

class _KollabAppState extends State<KollabApp> {
  FirebaseMessaging firebaseMessaging;

  KollabBloc get bloc => widget.bloc;
  BitmioTheme get theme => bloc.model.theme;
  API get api => bloc.model.api;

  final NavigationService _navigationService = locator<NavigationService>();

  AppState appState = AppState(isLoggedIn: false);

  var isLoading = false;
  bool _isConfigured = false;

  _KollabAppState() {
    if (!kIsWeb) {
      firebaseMessaging = FirebaseMessaging();
    }
  }

  @override
  Widget build(BuildContext context) {
    final BitmioTheme theme = bloc.model.theme;

    final background = theme.welcome.background_image_url != null
        ? Image.network(theme.welcome.background_image_url)
        : Image.asset(
            'images/welcome.jpg',
            fit: BoxFit.cover,
          );

    final logoImage = Image.network(theme.logo_url);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: theme.primary_color_obj,
        fontFamily: "OpenSans",
        backgroundColor: Colors.red,
        textTheme: TextTheme(
            headline5: TextStyle(fontSize: 30, color: Colors.black),
            bodyText2: StyleGuide().textStyle,
            subtitle1: StyleGuide().checklistStyle),
        buttonTheme: ButtonThemeData(
          padding: EdgeInsets.only(left: 60, right: 60, top: 15, bottom: 15),
          buttonColor: theme.primary_color_obj, //  <-- dark color
          textTheme:
              ButtonTextTheme.primary, //  <-- this auto selects the right color
        ),
      ),
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
        '/explore': (context) => LoggedIn(
            appState: appState, bloc: bloc, reloadState: fetchState, index: 0),
        '/onboarding': (context) => BZOnboarding(theme: theme)
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoggedIn(
                    appState: appState,
                    bloc: bloc,
                    reloadState: fetchState,
                    index: 0),
                transitionDuration: Duration(seconds: 0));
          case '/cards':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoggedIn(
                    appState: appState,
                    bloc: bloc,
                    reloadState: fetchState,
                    index: 1),
                transitionDuration: Duration(seconds: 0));
          case '/activities':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoggedIn(
                    appState: appState,
                    bloc: bloc,
                    reloadState: fetchState,
                    index: 2),
                transitionDuration: Duration(seconds: 0));
          case '/files':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoggedIn(
                    appState: appState,
                    bloc: bloc,
                    reloadState: fetchState,
                    index: 3),
                transitionDuration: Duration(seconds: 0));
          case '/contacts':
            return PageRouteBuilder(
                pageBuilder: (_, __, ___) => LoggedIn(
                    appState: appState,
                    bloc: bloc,
                    reloadState: fetchState,
                    index: 4),
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

    String token = '';

    if (api.isLoggedIn) {
      if (firebaseMessaging != null) {
        firebaseMessaging.requestNotificationPermissions();

        if (!_isConfigured) {
          configureFcm();
        }

        _isConfigured = true;

        token = await firebaseMessaging.getToken();
      }
    }

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
    firebaseMessaging.configure(
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
