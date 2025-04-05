import 'dart:ui';

import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_tuner/bloc/theme/theme_event.dart';
import 'package:theme_tuner/bloc/theme/theme_state.dart';
import '../../model/theme_model.dart';
import '../../repository/theme_repository.dart';
import '../custom_theme/custom_theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeRepository themeRepository;

  ThemeBloc({required this.themeRepository}) : super(ThemeInitial()) {
    on<ThemeInitialEvent>(_onThemeInitialEvent);
    on<ThemeChangedEvent>(_onThemeChangedEvent);
    on<CustomThemeEvent>(_onCustomThemeEvent);
    on<ThemeFollowSystemEvent>(_onThemeFollowSystemEvent);
  }

  // Add a variable to track system brightness
  Brightness? _currentSystemBrightness;

  // Create a method to get system brightness
  Brightness _getSystemBrightness() {
    return SchedulerBinding.instance.window.platformBrightness;
  }

  // Handle system theme events
  Future<void> _onThemeFollowSystemEvent(
      ThemeFollowSystemEvent event,
      Emitter<ThemeState> emit
      ) async {
    // Save system theme preference
    await themeRepository.saveUseSystemTheme(true);

    // Get current system brightness
    final brightness = _getSystemBrightness();
    _currentSystemBrightness = brightness;

    // Set theme based on system brightness
    final themeType = brightness == Brightness.dark
        ? ThemeType.dark
        : ThemeType.light;

    final themeModel = AppThemes.getThemeFromType(themeType);
    emit(ThemeLoaded(themeModel));

    // Set up listener for system theme changes
    _setupSystemThemeListener(emit);
  }

  // Set up a listener for system theme changes
  void _setupSystemThemeListener(Emitter<ThemeState> emit) {
    SchedulerBinding.instance.window.onPlatformBrightnessChanged = () {
      final newBrightness = _getSystemBrightness();

      // Only emit if brightness actually changed
      if (_currentSystemBrightness != newBrightness) {
        _currentSystemBrightness = newBrightness;

        // Check if we should be using system theme
        themeRepository.isUsingSystemTheme().then((useSystemTheme) {
          if (useSystemTheme) {
            final themeType = newBrightness == Brightness.dark
                ? ThemeType.dark
                : ThemeType.light;

            final themeModel = AppThemes.getThemeFromType(themeType);
            emit(ThemeLoaded(themeModel));
          }
        });
      }
    };
  }

  // Override close to dispose of listeners
  @override
  Future<void> close() {
    SchedulerBinding.instance.window.onPlatformBrightnessChanged = null;
    return super.close();
  }

  // Modify initial event handler to check for system theme
  Future<void> _onThemeInitialEvent(
      ThemeInitialEvent event,
      Emitter<ThemeState> emit
      ) async {
    final ThemeType savedThemeType = await themeRepository.getTheme();

    if (savedThemeType == ThemeType.system) {
      // Handle system theme
      add(ThemeFollowSystemEvent());
    } else {
      // Handle regular theme
      final themeModel = AppThemes.getThemeFromType(savedThemeType);
      emit(ThemeLoaded(themeModel));
    }
  }

  Future<void> _onThemeChangedEvent(
      ThemeChangedEvent event, Emitter<ThemeState> emit) async {
    // Save new theme
    await themeRepository.saveTheme(event.themeType);
    final themeModel = AppThemes.getThemeFromType(event.themeType);
    emit(ThemeLoaded(themeModel));
  }

  Future<void> _onCustomThemeEvent(
      CustomThemeEvent event,
      Emitter<ThemeState> emit
      ) async {
    // Generate a custom theme
    final customTheme = AppThemes.generateCustomTheme(
      event.primaryColor,
      name: event.name,
    );

    // Save custom theme information (you'll need to update your repository)
    await themeRepository.saveCustomTheme(event.primaryColor);

    emit(ThemeLoaded(customTheme));
  }
}
