import '../styleguide.dart';
import 'package:flutter/material.dart';

class TabHeader extends StatelessWidget {
  final String title;

  TabHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 25, top: 25, right: 25, bottom: 25),
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.centerLeft,
        child: Text(title.toUpperCase(), style: StyleGuide().tabBannerStyle));
  }
}
