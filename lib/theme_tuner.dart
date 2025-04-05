import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_tuner/repository/theme_repository.dart';
import 'package:theme_tuner/screen/home_screen.dart';

import 'bloc/theme/theme_bloc.dart';
import 'bloc/theme/theme_event.dart';
import 'bloc/theme/theme_state.dart';

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
        child: const AppView(),
      ),
    );
  }
}

// First, create an AnimatedTheme wrapper in your AppView:
class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        if (state is ThemeLoaded) {
          return MaterialApp(
            title: 'Flutter Theme Demo with BLoC',
            home: AnimatedThemeBuilder(
              themeData: state.themeModel.themeData,
              child: const HomePage(),
            ),
          );
        }
        // Fallback
        return MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}

// Create the AnimatedThemeBuilder class:
class AnimatedThemeBuilder extends StatelessWidget {
  final ThemeData themeData;
  final Widget child;
  final Duration duration;

  const AnimatedThemeBuilder({
    super.key,
    required this.themeData,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      data: themeData,
      duration: duration,
      child: child,
    );
  }
}