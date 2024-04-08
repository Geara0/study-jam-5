import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_generator/dto/template/template_dto.dart';

class TemplatePreview extends StatelessWidget {
  const TemplatePreview({
    required this.index,
    required this.template,
    required this.onDelete,
    super.key,
  });

  final int index;
  final TemplateDto template;
  final void Function(BuildContext context) onDelete;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: MemoryImage(template.previewBytes),
          fit: BoxFit.cover,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: () {
          HapticFeedback.lightImpact();
          showModalBottomSheet(
            showDragHandle: true,
            enableDrag: false,
            context: context,
            builder: (context) {
              return SafeArea(
                child: Wrap(
                  children: [
                    InkWell(
                      onTap: () => onDelete(context),
                      child: SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Icon(
                              Icons.delete,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'main.delete'.tr(),
                                maxLines: 1,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40, width: 1),
                  ],
                ),
              );
            },
          );
        },
        onTap: () {
          context.go('/edit', extra: (index, template));
        },
      ),
    );
  }
}
