import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';

part 'template_dto.g.dart';

@HiveType(typeId: 0)
class TemplateDto {
  @HiveField(0)
  Uint8List bytes;

  TemplateDto({required this.bytes});
}
