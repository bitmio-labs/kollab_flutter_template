import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final double height;
  final double logoHeight;
  final Image background;
  final Image logo;

  Header({this.height, this.logoHeight, this.background, this.logo});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        child: Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          right: 0,
          height: height - logoHeight / 2,
          child: background,
        ),
        if (logo != null) Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(12),
                color: Theme.of(context).canvasColor,
                height: logoHeight,
                width: logoHeight,
                child: logo,
              ),
            ))
        ,
      ],));
  }
}