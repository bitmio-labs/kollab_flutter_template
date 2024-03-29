import 'dart:async';
import 'api.dart';
import 'theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KollabAppModel {
  BitmioTheme theme;
  API api;
  AppDirectoryModel appDirectory;

  bool isLoading;

  KollabAppModel({this.theme, this.api, this.appDirectory, this.isLoading});
}

class KollabBloc {
  String url;
  KollabAppModel model;
  final modelStream = StreamController<KollabAppModel>();

  KollabBloc({this.url, this.model});

  load() async {
    print('Loading bloc theme state');

    final loadingState = KollabAppModel(isLoading: true);

    updateModel(loadingState);

    final loadedState = await _fetchApp();

    updateModel(loadedState);
  }

  launchApp(AppDirectoryItemModel app) {
    url = app.url;
    load();
  }

  Future<KollabAppModel> _fetchApp() async {
    print('Fetching theme $url');

    final response = await http.get(url);
    final jsonData = json.decode(response.body);

    var theme;
    try {
      theme = BitmioTheme.fromJson(jsonData);
    } catch (err) {
      print(err);
      print(response.body);
    }

    print('Init API ${theme.id}, ${theme.state_url}');
    final api = API(id: theme.id, stateUrl: theme.state_url);

    print('Setting up API');
    await api.setup();

    await api.state.setup();
    print('Setting up state');

    if (theme.has_app_switcher != true) {
      return KollabAppModel(
          theme: theme, api: api, isLoading: false, appDirectory: null);
    }

    final appDirectory = await _fetchAppDirectory(theme.app_directory_url);

    return KollabAppModel(
        theme: theme, api: api, isLoading: false, appDirectory: appDirectory);
  }

  Future<AppDirectoryModel> _fetchAppDirectory(String url) async {
    print('Loading bloc app directory state');

    final response = await http.get(url);
    final jsonData = json.decode(response.body);

    return AppDirectoryModel.fromJson(jsonData);
  }

  updateModel(KollabAppModel newModel) {
    model = newModel;
    modelStream.sink.add(newModel);
  }

  void dispose() {
    modelStream.close();
  }
}
