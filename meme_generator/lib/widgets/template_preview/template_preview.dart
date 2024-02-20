import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_generator/dto/template/template_dto.dart';

class TemplatePreview extends StatelessWidget {
  const TemplatePreview(
    this.template, {
    super.key,
  });

  final TemplateDto template;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: MemoryImage(template.bytes),
          fit: BoxFit.cover,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.go('/edit', extra: template);
        },
      ),
    );
  }
}
