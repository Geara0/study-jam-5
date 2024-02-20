part of 'main.dart';

final _theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: SchedulerBinding.instance.platformDispatcher.platformBrightness,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(),
  ),
  expansionTileTheme: ExpansionTileThemeData(
    shape: Border.all(color: Colors.transparent),
    childrenPadding: const EdgeInsets.all(10),
  ),
  cardTheme: const CardTheme(margin: EdgeInsets.zero),
  popupMenuTheme: PopupMenuThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  useMaterial3: true,
);
