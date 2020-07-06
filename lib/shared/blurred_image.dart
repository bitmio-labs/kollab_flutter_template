import 'package:flutter/material.dart';
import 'dart:ui';

class BlurredImage extends StatelessWidget {
  final Image image;

  BlurredImage(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          image: DecorationImage(image: image.image, fit: BoxFit.cover),
        ),
        child: ClipRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ))));
  }
}

class BlurredBox extends StatelessWidget {
  final Widget child;

  BlurredBox({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: new BoxDecoration(
          color: Colors.black.withOpacity(0.5),
        ),
        child: ClipRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: child)));
  }
}
