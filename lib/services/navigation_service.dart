import 'package:flutter/material.dart';
// import '../API.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    _navigationKey.currentState.pop();
  }

  void logNavigation(String routeName) {
    print("navigate $routeName");
    // TODO: re-add route logging
    //API.shared.logEvent(routeName);
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    logNavigation(routeName);

    return _navigationKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamed(String routeName, {dynamic arguments}) {
    logNavigation(routeName);

    return _navigationKey.currentState.pushNamed(routeName);
  }
}
