import 'package:flutter/material.dart';
import 'package:meme_generator/dto/template_part_dto/template_circle_dto/template_circle_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_part_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_part_dto_type.dart';
import 'package:meme_generator/dto/template_part_dto/template_text_dto/template_text_dto.dart';

class TemplatePartBuilder extends StatelessWidget {
  const TemplatePartBuilder({
    required this.part,
    this.onDragStart,
    required this.onDragEnd,
    required this.sizeDecoder,
    super.key,
  }) : assert(
          onDragStart == null || onDragEnd != null,
          'you cant pass onStart without onEnd',
        );

  final TemplatePartDto part;
  final VoidCallback? onDragStart;
  final DragEndCallback? onDragEnd;
  final Size Function(double widthPercent, double heightPercent) sizeDecoder;

  @override
  Widget build(BuildContext context) {
    switch (part.type) {
      case TemplateType.text:
        final value = part.value as TemplateTextDto;
        final size = sizeDecoder(value.size, value.size).width;
        final style = TextStyle(
          color: value.color,
          fontSize: size,
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
          onDragStarted: onDragStart,
          onDragEnd: onDragEnd,
          childWhenDragging: const SizedBox.shrink(),
          child: Text(
            value.text,
            style: style,
          ),
        );
      case TemplateType.circle:
        final value = part.value as TemplateCircleDto;
        final size = sizeDecoder(value.radius * 2, value.radius * 2);
        final border = sizeDecoder(value.borderWidth, value.borderWidth);

        final res = Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: value.color, width: border.width),
          ),
          height: size.height,
          width: size.width,
        );

        return Draggable(
          feedback: res,
          onDragStarted: onDragStart,
          onDragEnd: onDragEnd,
          childWhenDragging: const SizedBox.shrink(),
          child: res,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
