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
  theme_tuner: ^0.0.1

```

## 🚀 Basic Usage
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
## 🎛️ Changing Themes

Dispatch the appropriate event to the ThemeBloc:

```
context.read<ThemeBloc>().add(ThemeChangedEvent(ThemeType.light));
context.read<ThemeBloc>().add(ThemeChangedEvent(ThemeType.dark));
context.read<ThemeBloc>().add(ThemeChangedEvent(ThemeType.green));
context.read<ThemeBloc>().add(ThemeChangedEvent(ThemeType.purple));
context.read<ThemeBloc>().add(ThemeFollowSystemEvent());
context.read<ThemeBloc>().add(CustomThemeEvent(primaryColor: Colors.orange));
```

## 🧪 Theme Settings Page Example

```
class ThemeSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Light Theme'),
            leading: const Icon(Icons.light_mode),
            onTap: () => context.read<ThemeBloc>().add(ThemeChangedEvent(ThemeType.light)),
          ),
          ListTile(
            title: const Text('Dark Theme'),
            leading: const Icon(Icons.dark_mode),
            onTap: () => context.read<ThemeBloc>().add(ThemeChangedEvent(ThemeType.dark)),
          ),
          ListTile(
            title: const Text('System Theme'),
            leading: const Icon(Icons.brightness_auto),
            onTap: () => context.read<ThemeBloc>().add(ThemeFollowSystemEvent()),
          ),
        ],
      ),
    );
  }
}
```

## 🎨 Custom Theme with Color Picker

```
void showColorPicker(BuildContext context) {
  Color pickerColor = Theme.of(context).primaryColor;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Pick a theme color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) {
              pickerColor = color;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ThemeBloc>().add(CustomThemeEvent(primaryColor: pickerColor));
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      );
    },
  );
}
```

## 🖥️ System Theme Integration
When users select the System Theme option, ThemeTuner will automatically adapt between light and dark themes based on the OS settings.

## ⚙️ Advanced Configuration
### Custom Theme Definitions

```
static final ThemeModel customRed = ThemeModel(
  type: ThemeType.custom,
  themeData: ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.red,
  ),
);
```

### Theme Extensions
```
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color specialColor;
  final BorderRadius borderRadius;

  CustomThemeExtension({
    required this.specialColor,
    required this.borderRadius,
  });

  @override
  CustomThemeExtension copyWith({
    Color? specialColor,
    BorderRadius? borderRadius,
  }) {
    return CustomThemeExtension(
      specialColor: specialColor ?? this.specialColor,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  CustomThemeExtension lerp(ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) return this;
    return CustomThemeExtension(
      specialColor: Color.lerp(specialColor, other.specialColor, t)!,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
    );
  }
}

```
Add to your theme:

```
themeData: ThemeData().copyWith(
  extensions: [
    CustomThemeExtension(
      specialColor: Colors.amber,
      borderRadius: BorderRadius.circular(8),
    ),
  ],
);

```

Use in widgets:
```
final customTheme = Theme.of(context).extension<CustomThemeExtension>()!;
Container(
  decoration: BoxDecoration(
    color: customTheme.specialColor,
    borderRadius: customTheme.borderRadius,
  ),
);
```


## Connect with me

#### If you have any bugs or issues , If you want to explain my code please contact me on :

<div align="center">
 <br><b>MAIL ME</b>&nbsp;
  <a href="mailto:nimeshpiyumantha11@gmail.com">
      <img width="20px" src="https://github.com/NimeshPiyumantha/red-alpha/blob/main/gmail.svg" />
  </a></p>

 </div>

<p align="center">
<a href="https://twitter.com/NPiyumantha60"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/twitter.svg" alt="__NimeshPiyumantha__" height="30" width="40" /></a>
<a href="https://www.linkedin.com/in/nimesh-piyumantha-33736a222" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg" alt="https://www.linkedin.com/public-profile/settings?trk=d_flagship3_profile_self_view_public_profile" height="30" width="40" /></a>
<a href="https://www.facebook.com/profile.php?id=100025931563090" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/facebook.svg" alt="Nimesh Piyumantha" height="30" width="40" /></a>
<a href="https://www.instagram.com/_.nimmaa._/" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/instagram.svg" alt="_.nimmaa._" height="30" width="40" /></a>
</p>

##

<div align="center">

![repo license](https://img.shields.io/github/license/NimeshPiyumantha/theme_tuner?&labelColor=black&color=3867d6&style=for-the-badge)
![repo size](https://img.shields.io/github/repo-size/NimeshPiyumantha/theme_tuner?label=Repo%20Size&style=for-the-badge&labelColor=black&color=20bf6b)
![GitHub forks](https://img.shields.io/github/forks/NimeshPiyumantha/theme_tuner?&labelColor=black&color=0fb9b1&style=for-the-badge)
![GitHub stars](https://img.shields.io/github/stars/NimeshPiyumantha/theme_tuner?&labelColor=black&color=f7b731&style=for-the-badge)
![GitHub LastCommit](https://img.shields.io/github/last-commit/NimeshPiyumantha/theme_tuner?logo=github&labelColor=black&color=d1d8e0&style=for-the-badge)

</div>

<div align="center">

#### @2025 [Nimesh Piyumantha](https://github.com/NimeshPiyumantha/), Inc.All rights reserved

</div>
