import 'package:equatable/equatable.dart';

import '../../model/theme_model.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

// Initial loading state
class ThemeInitial extends ThemeState {}

// State when theme is loaded
class ThemeLoaded extends ThemeState {
  final ThemeModel themeModel;

  const ThemeLoaded(this.themeModel);

  @override
  List<Object> get props => [themeModel];
}
