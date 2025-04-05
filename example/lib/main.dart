import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:theme_tuner/bloc/theme/theme_bloc.dart';
import 'package:theme_tuner/bloc/theme/theme_event.dart';
import 'package:theme_tuner/bloc/theme/theme_state.dart';
import 'package:theme_tuner/model/theme_model.dart';
import 'package:theme_tuner/repository/theme_repository.dart';

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
                title: 'Theme Tuner Demo',
                theme: state.themeModel.themeData,
                home: const HomePage(),
                debugShowCheckedModeBanner: false,
              );
            }
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Tuner Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Theme Type:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                if (state is ThemeLoaded) {
                  return Text(
                    state.themeModel.type.toString().split('.').last,
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<ThemeBloc>()
                        .add(ThemeChangedEvent(ThemeType.light));
                  },
                  child: const Text('Light'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<ThemeBloc>()
                        .add(ThemeChangedEvent(ThemeType.dark));
                  },
                  child: const Text('Dark'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<ThemeBloc>().add(ThemeFollowSystemEvent());
                  },
                  child: const Text('System'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
