part of 'main.dart';

Future<void> _openBoxes() {
  return Future.wait([
    Hive.openBox<TemplateDto>('templates'),
  ]);
}

void _registerAdapters() {
  Hive.registerAdapter(TemplateDtoAdapter());
}
