import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meme_generator/dto/template/template_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_part_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_part_dto_type.dart';
import 'package:meme_generator/dto/template_part_dto/template_text_dto/template_text_dto.dart';
import 'package:meme_generator/router.dart';

part 'theme.dart';
part 'hive_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _registerAdapters();

  await Future.wait([
    EasyLocalization.ensureInitialized(),
    Hive.initFlutter().then((_) => _openBoxes()),
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: _theme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: router,
    );
  }
}
