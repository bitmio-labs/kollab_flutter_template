import 'shared/onboarding.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class BZOnboarding extends StatelessWidget {
  final BitmioTheme theme;

  BZOnboarding({this.theme});

  @override
  Widget build(BuildContext context) {
    final model = theme.onboarding.items
        .asMap()
        .map((i, e) => MapEntry(
            i,
            OnboardingPageModel(
                title: e.title,
                description: e.subtitle,
                backgroundImage: e.background_image_url != null
                    ? Image.network(e.background_image_url)
                    : Image.asset('images/onboarding${i + 1}.jpg'))))
        .values
        .toList();

    return Onboarding(
      model: model,
      completionRoute: '/welcome',
      continueLabel: theme.onboarding.continue_label,
      skipLabel: theme.onboarding.skip_label,
      startLabel: theme.onboarding.start_label,
    );
  }
}
