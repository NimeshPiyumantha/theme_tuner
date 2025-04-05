import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme/theme_bloc.dart';
import '../bloc/theme/theme_event.dart';
import '../bloc/theme/theme_state.dart';
import '../model/theme_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Switcher with BLoC'),
      ),
      body: Center(
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            if (state is ThemeLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current Theme: ${state.themeModel.type.toString().split('.').last}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _themeButton(
                        context: context,
                        themeType: ThemeType.light,
                        color: Colors.blue,
                        label: 'Light Theme',
                      ),
                      _themeButton(
                        context: context,
                        themeType: ThemeType.dark,
                        color: Colors.grey[800]!,
                        label: 'Dark Theme',
                      ),
                    ],
                  ),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _themeButton({
    required BuildContext context,
    required ThemeType themeType,
    required Color color,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: () {
        context.read<ThemeBloc>().add(ThemeChangedEvent(themeType));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(label),
    );
  }
}
