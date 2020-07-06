import 'shared/onboarding.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class BZOnboarding extends StatelessWidget {
  final BitmioTheme theme = BitmioTheme.shared;

  @override
  Widget build(BuildContext context) {
    final model = theme.onboarding.items
        .asMap()
        .map((i, e) => MapEntry(
            i,
            OnboardingPageModel(
                title: e.title,
                description: e.subtitle,
                backgroundImage: Image.asset('images/onboarding${i + 1}.jpg'))))
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
