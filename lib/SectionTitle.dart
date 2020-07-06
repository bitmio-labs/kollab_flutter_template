
import 'package:flutter/material.dart';

import 'StyleGuide.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title.toUpperCase(), style: StyleGuide().sectionTitleStyle);
  }
}