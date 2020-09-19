import 'package:flutter/material.dart';
import 'package:kollab_template/kollab_bloc.dart';
import 'package:kollab_template/theme.dart';

class AppSwitcher extends StatelessWidget {
  final KollabBloc bloc;
  List<AppDirectoryItemModel> get apps => bloc.model.appDirectory.items;
  final double width;

  AppSwitcher({this.bloc, this.width});

  @override
  Widget build(BuildContext context) {
    final appItems =
        apps.map((e) => AppSwitcherItem(model: e, bloc: bloc)).toList();

    final appItemWrap = Wrap(
      spacing: 10,
      direction: Axis.vertical,
      children: appItems,
    );

    final appSwitcher = ListView(children: [
      SizedBox(height: 10),
      Center(child: appItemWrap),
      SizedBox(
        height: 20,
      ),
      Icon(
        Icons.add,
        color: Colors.white70,
      )
    ]);

    return Container(
        width: width,
        alignment: Alignment.center,
        color: Colors.black87,
        child: appSwitcher);
  }
}

class AppSwitcherItem extends StatelessWidget {
  final KollabBloc bloc;
  final AppDirectoryItemModel model;
  final appTitleFont = TextStyle(fontSize: 12, color: Colors.white70);

  AppSwitcherItem({this.model, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(model.logo_url),
              ),
            ),
            child: FlatButton(
                padding: EdgeInsets.all(0.0), onPressed: onTap, child: null)),
        SizedBox(height: 6),
        Container(
          alignment: Alignment.center,
          width: 90,
          child: Text(
            model.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: appTitleFont,
          ),
        )
      ],
    );
  }

  onTap() {
    bloc.launchApp(model);
  }
}
