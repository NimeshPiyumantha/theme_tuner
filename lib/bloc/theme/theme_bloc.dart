import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_tuner/bloc/theme/theme_event.dart';
import 'package:theme_tuner/bloc/theme/theme_state.dart';
import '../../model/theme_model.dart';
import '../../repository/theme_repository.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository themeRepository;

  ThemeBloc({required this.themeRepository}) : super(ThemeInitial()) {
    on<ThemeInitialEvent>(_onThemeInitialEvent);
    on<ThemeChangedEvent>(_onThemeChangedEvent);
  }

  Future<void> _onThemeInitialEvent(
      ThemeInitialEvent event, Emitter<ThemeState> emit) async {
    // Load saved theme
    final ThemeType savedThemeType = await themeRepository.getTheme();
    final themeModel = AppThemes.getThemeFromType(savedThemeType);
    emit(ThemeLoaded(themeModel));
  }

  Future<void> _onThemeChangedEvent(
      ThemeChangedEvent event, Emitter<ThemeState> emit) async {
    // Save new theme
    await themeRepository.saveTheme(event.themeType);
    final themeModel = AppThemes.getThemeFromType(event.themeType);
    emit(ThemeLoaded(themeModel));
  }
}
