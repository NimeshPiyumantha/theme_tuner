import 'package:equatable/equatable.dart';

import '../../model/theme_model.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

// Event to initialize theme from storage
class ThemeInitialEvent extends ThemeEvent {}

// Event to change the theme
class ThemeChangedEvent extends ThemeEvent {
  final ThemeType themeType;

  const ThemeChangedEvent(this.themeType);

  @override
  List<Object> get props => [themeType];
}

class ThemeFollowSystemEvent extends ThemeEvent {}
