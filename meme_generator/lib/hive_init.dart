part of 'main.dart';

Future<void> _openBoxes() {
  return Future.wait([
    Hive.openBox<TemplateDto>('templates'),
  ]);
}

void _registerAdapters() {
  Hive.registerAdapter(TemplateTypeAdapter());
  Hive.registerAdapter(TemplatePartDtoAdapter());
  Hive.registerAdapter(TemplateTextDtoAdapter());
  Hive.registerAdapter(TemplateCircleDtoAdapter());
  Hive.registerAdapter(TemplateDtoAdapter());
}
