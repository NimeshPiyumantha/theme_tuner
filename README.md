# Theme Tuner

A Flutter package for easily managing multiple themes in your application using the BLoC pattern.

## Features

- Light and dark theme support
- Custom theme creation
- System theme detection and automatic switching
- Theme persistence using SharedPreferences
- Smooth theme transitions with animations
- BLoC state management for clean architecture

## Installation

Add `theme_tuner` to your `pubspec.yaml`:

```yaml
dependencies:
  theme_tuner: ^0.1.0

```

import 'package:flutter/material.dart';
import 'package:theme_tuner/theme_tuner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ThemeRepository(),
      child: BlocProvider(
        create: (context) => ThemeBloc(
          themeRepository: context.read<ThemeRepository>(),
        )..add(ThemeInitialEvent()),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            if (state is ThemeLoaded) {
              return MaterialApp(
                title: 'My App',
                theme: state.themeModel.themeData,
                home: const HomePage(),
              );
            }
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          },
        ),
      ),
    );
  }
}

```
// Switch to light theme
context.read<ThemeBloc>().add(ThemeChangedEvent(ThemeType.light));

// Switch to dark theme
context.read<ThemeBloc>().add(ThemeChangedEvent(ThemeType.dark));

// Follow system theme
context.read<ThemeBloc>().add(ThemeFollowSystemEvent());

// Use custom theme
context.read<ThemeBloc>().add(CustomThemeEvent(primaryColor: Colors.purple));

## Step 5: Add License

Create a LICENSE file with an appropriate license (MIT is a common choice for open-source packages).

## Step 6: Test Your Package

Write some tests in the `test` directory:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_tuner/theme_tuner.dart';
import 'package:flutter/material.dart';

void main() {
  group('ThemeModel', () {
    test('should create light theme model', () {
      final theme = AppThemes.light;
      expect(theme.type, ThemeType.light);
      expect(theme.themeData.brightness, Brightness.light);
    });

    test('should create dark theme model', () {
      final theme = AppThemes.dark;
      expect(theme.type, ThemeType.dark);
      expect(theme.themeData.brightness, Brightness.dark);
    });
  });
}