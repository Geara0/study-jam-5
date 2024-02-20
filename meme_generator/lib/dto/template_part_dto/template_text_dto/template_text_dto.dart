import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'template_text_dto.g.dart';

@HiveType(typeId: 2)
class TemplateTextDto {
  @HiveField(0)
  String text;
  @HiveField(1)
  bool isBald;
  @HiveField(2)
  bool isItalic;
  @HiveField(3)
  late int colorValue;
  @HiveField(4)
  double size;

  TemplateTextDto({
    required this.text,
    this.isBald = false,
    this.isItalic = false,
    Color color = Colors.black,
    this.size = 20,
  }) {
    colorValue = color.value;
  }

  Color get color => Color(colorValue);
}
