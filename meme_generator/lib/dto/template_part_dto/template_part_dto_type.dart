import 'package:hive_flutter/hive_flutter.dart';

part 'template_part_dto_type.g.dart';

@HiveType(typeId: 3)
enum TemplateType {
  @HiveField(0)
  text,
}
