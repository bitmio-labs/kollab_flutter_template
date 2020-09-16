import 'dart:async';
import 'API.dart';
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
  final String url;
  KollabAppModel model;
  final modelStream = StreamController<KollabAppModel>();

  KollabBloc({this.url, this.model});

  load() async {
    print('Loading bloc theme state');

    final loadingState = KollabAppModel(isLoading: true);
    updateModel(loadingState);

    final response = await http.get(url);
    final jsonData = json.decode(response.body);
    final theme = BitmioTheme.fromJson(jsonData);
    final api = API(id: theme.id);
    await api.setup();
    await CachedChecklistState.shared.setup();
    final loadedState =
        KollabAppModel(theme: theme, api: api, isLoading: false);
    updateModel(loadedState);
  }

  loadAppDirectory() async {
    print('Loading bloc app directory state');

    final response = await http.get(model.theme.app_directory_url);
    final jsonData = json.decode(response.body);
    final appDirectory = AppDirectoryModel.fromJson(jsonData);

    final newModel = KollabAppModel(
        theme: model.theme,
        api: model.api,
        isLoading: false,
        appDirectory: appDirectory);
    updateModel(newModel);
  }

  updateModel(KollabAppModel newModel) {
    model = newModel;
    modelStream.sink.add(newModel);
  }

  void dispose() {
    modelStream.close();
  }
}
