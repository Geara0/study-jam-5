import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'template_circle_dto.g.dart';

@HiveType(typeId: 4)
class TemplateCircleDto {
  @HiveField(0)
  double radius;
  @HiveField(1)
  late int colorValue;
  @HiveField(2)
  double borderWidth;

  TemplateCircleDto({
    required this.radius,
    required this.borderWidth,
    Color color = Colors.black,
  }) {
    colorValue = color.value;
  }

  Color get color => Color(colorValue);
}
