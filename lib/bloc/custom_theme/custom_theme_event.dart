import 'package:flutter/material.dart';

import '../theme/theme_event.dart';

class CustomThemeEvent extends ThemeEvent {
  final Color primaryColor;
  final String? name;

  const CustomThemeEvent({
    required this.primaryColor,
    this.name,
  });

  @override
  List<Object> get props => [primaryColor];
}
