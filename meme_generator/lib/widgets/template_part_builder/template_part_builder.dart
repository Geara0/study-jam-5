import 'package:flutter/material.dart';
import 'package:meme_generator/dto/template_part_dto/template_circle_dto/template_circle_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_part_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_part_dto_type.dart';
import 'package:meme_generator/dto/template_part_dto/template_text_dto/template_text_dto.dart';

class TemplatePartBuilder extends StatelessWidget {
  const TemplatePartBuilder({
    required this.part,
    required this.onDragEnd,
    super.key,
  });

  final TemplatePartDto part;
  final DragEndCallback? onDragEnd;

  @override
  Widget build(BuildContext context) {
    switch (part.type) {
      case TemplateType.text:
        final value = part.value as TemplateTextDto;
        final style = TextStyle(
          color: value.color,
          fontSize: value.size,
          fontStyle: value.isItalic ? FontStyle.italic : FontStyle.normal,
          fontWeight: value.isBald ? FontWeight.w700 : null,
        );

        if (onDragEnd == null) {
          return Text(value.text, style: style);
        }

        return Draggable(
          feedback: DefaultTextStyle(
            style: style,
            child: Text(value.text),
          ),
          onDragEnd: onDragEnd,
          childWhenDragging: const SizedBox.shrink(),
          child: Text(
            value.text,
            style: style,
          ),
        );
      case TemplateType.circle:
        final value = part.value as TemplateCircleDto;

        final res = Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: value.color),
          ),
          height: value.radius * 2,
          width: value.radius * 2,
        );

        return Draggable(
          feedback: res,
          onDragEnd: onDragEnd,
          childWhenDragging: const SizedBox.shrink(),
          child: res,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
