import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:meme_generator/dto/template_part_dto/template_part_dto.dart';

part 'template_dto.g.dart';

@HiveType(typeId: 0)
class TemplateDto {
  @HiveField(0)
  Uint8List bytes;
  @HiveField(1)
  List<TemplatePartDto> parts;
  @HiveField(2)
  Uint8List previewBytes;

  TemplateDto({
    required this.bytes,
    required this.previewBytes,
    this.parts = const [],
  });
}
