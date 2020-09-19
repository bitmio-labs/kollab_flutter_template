import 'package:flutter/material.dart';
import 'package:kollab_template/theme.dart';

class AppSwitcher extends StatelessWidget {
  final List<AppDirectoryItemModel> apps;
  final double width;
  final appTitleFont = TextStyle(fontSize: 12, color: Colors.white70);

  AppSwitcher({this.apps, this.width});

  @override
  Widget build(BuildContext context) {
    final appItems = apps
        .map((e) => Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      e.logo_url,
                      width: 60,
                      height: 60,
                    )),
                SizedBox(height: 6),
                Container(
                  alignment: Alignment.center,
                  width: 90,
                  child: Text(
                    e.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: appTitleFont,
                  ),
                )
              ],
            ))
        .toList();

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
