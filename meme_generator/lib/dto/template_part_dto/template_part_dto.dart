import 'package:hive_flutter/hive_flutter.dart';
import 'package:meme_generator/dto/template_part_dto/template_circle_dto/template_circle_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_text_dto/template_text_dto.dart';

import 'template_part_dto_type.dart';

part 'template_part_dto.g.dart';

@HiveType(typeId: 1)
class TemplatePartDto {
  @HiveField(0)
  dynamic value;
  @HiveField(1)
  late TemplateType type;
  @HiveField(2)
  double dx;
  @HiveField(3)
  double dy;

  TemplatePartDto({
    required this.dx,
    required this.dy,
    required this.value,
  }) {
    type = switch (value) {
      TemplateTextDto() => TemplateType.text,
      TemplateCircleDto() => TemplateType.circle,
      _ => throw 'unknown type',
    };
  }
}
