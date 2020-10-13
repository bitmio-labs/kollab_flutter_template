// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/AppState.dart';
import 'package:kollab_auth/kollab_auth.dart';

class API {
  final String id;
  final String stateUrl;

  String get AUTH_TOKEN_KEY {
    return 'bitmio_${id}_auth_token_v1';
  }

  String get APP_STATE_KEY {
    return 'bitmio_${id}_app_state_v1';
  }

  API({this.id, this.stateUrl});

  String get APP_STATE_ROUTE {
    return stateUrl ?? 'https://api.bitmio.com/v1/$id/bits/state';
  }

  String get DEMO_STATE_ROUTE {
    return 'https://api.bitmio.com/v1/$id/bits/demo_state';
  }

  String get SIGNUP_ROUTE {
    return 'https://api.bitmio.com/v1/$id/signup';
  }

  String get LOGIN_ROUTE {
    return 'https://api.bitmio.com/v1/$id/login';
  }

  String get EVENTS_ROUTE {
    return 'https://api.bitmio.com/v1/$id/events';
  }

  CachedChecklistState state;

  SharedPreferences prefs;

  bool get isLoggedIn {
    return accessToken != null;
  }

  String get accessToken {
    return prefs.getString(AUTH_TOKEN_KEY);
  }

  set accessToken(String accessToken) {
    prefs.setString(AUTH_TOKEN_KEY, accessToken);
  }

  AppState get cachedAppState {
    String data = cachedAppStateJSON;

    if (data == null) {
      return null;
    }

    return AppState.fromJson(json.decode(data));
  }

  String get cachedAppStateJSON {
    return prefs.getString(APP_STATE_KEY);
  }

  set cachedAppStateJSON(String json) {
    prefs.setString(APP_STATE_KEY, json);
  }

  setup() async {
    prefs = await SharedPreferences.getInstance();
    state = CachedChecklistState(id: id);
    await state.setup();
  }

  Future<AppState> fetchState(String firebaseToken) async {
    if (accessToken == null) {
      return fetchDemoState();
    }

    print('Loading logged-in app state $accessToken');

    final headers = {'Authorization': 'Bearer $accessToken'};

    final url = '$APP_STATE_ROUTE?firebase_token=$firebaseToken';

    print(url);
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      try {
        AppState state = AppState.fromJson(json.decode(response.body));
        cachedAppStateJSON = response.body;

        return state;
      } catch (err) {
        print(err);

        return null;
      }
    } else {
      // If that response was not OK, throw an error.
      print(response.body);
      throw Exception('Failed to load AppState');
    }
  }

  Future<AppState> fetchDemoState() async {
    print('Loading demo app state');

    final response = await http.get(DEMO_STATE_ROUTE);

    if (response.statusCode == 200) {
      return AppState.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load demo AppState');
    }
  }

  Future<bool> signup(SignupModel data) async {
    final body = {'email': data.email, 'password': data.password};

    final headers = {"content-type": "application/json"};
    final bodyEncoded = json.encode(body);
    print(bodyEncoded);

    final response =
        await http.post(SIGNUP_ROUTE, headers: headers, body: bodyEncoded);

    if (response.statusCode != 200) {
      return false;
    }

    final signupResponse = SignupResponse.fromJson(json.decode(response.body));

    if (signupResponse.access_token == null) {
      return false;
    }

    accessToken = signupResponse.access_token;

    return true;
  }

  Future<bool> login(LoginModel data) async {
    final body = {'email': data.email, 'password': data.password};

    final headers = {"content-type": "application/json"};
    var bodyEncoded = json.encode(body);

    final response =
        await http.post(LOGIN_ROUTE, headers: headers, body: bodyEncoded);

    if (response.statusCode != 200) {
      return false;
    }

    final signupResponse = SignupResponse.fromJson(json.decode(response.body));

    if (signupResponse.access_token == null) {
      return false;
    }

    accessToken = signupResponse.access_token;

    return true;
  }

  Future<bool> logEvent(String event) async {
    // await analytics.logEvent(
    //   name: event,
    //   parameters: {},
    // );

    if (accessToken == null) {
      print('Log event failed without accessToken $event');
      return true;
    }

    print('Log event $event');

    final body = [
      {'event_type_id': event}
    ];

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'content-type': 'application/json'
    };

    var bodyEncoded = json.encode(body);

    final response =
        await http.post(EVENTS_ROUTE, headers: headers, body: bodyEncoded);

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }
}

class CachedChecklistState {
  final String id;

  String get USER_STATE_KEY {
    return 'bitmio_${id}_user_state_v1';
  }

  SharedPreferences prefs;

  CachedState _cachedState;

  CachedState get cachedState {
    if (_cachedState != null) {
      return _cachedState;
    }

    final encoded = prefs.getString(USER_STATE_KEY);

    if (encoded == null) {
      return CachedState(checklist_items: []);
    }

    final state = CachedState.fromJson(json.decode(encoded));

    _cachedState = state;

    if (state != null) {
      return state;
    }

    return CachedState(checklist_items: []);
  }

  set cachedState(CachedState state) {
    _cachedState = state;

    final jsonData = state.toJson();

    final encoded = json.encode(jsonData);

    prefs.setString(USER_STATE_KEY, encoded);
  }

  CachedChecklistState({@required this.id});

  setup() async {
    prefs = await SharedPreferences.getInstance();
  }

  toggle(String id, bool value) async {
    final currentState = cachedState;
    final newItemState = CachedChecklistItemState(id: id, value: value);
    final idx =
        currentState.checklist_items.indexWhere((each) => each.id == id);

    if (idx != -1) {
      currentState.checklist_items[idx] = newItemState;
    } else {
      currentState.checklist_items.add(newItemState);
    }

    cachedState = currentState;
  }

  bool isToogled(String checklistItemId) {
    final idx = cachedState.checklist_items
        .indexWhere((each) => each.id == checklistItemId);

    if (idx == -1) {
      return false;
    }

    return cachedState.checklist_items[idx].value;
  }
}
