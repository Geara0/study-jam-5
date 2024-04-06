import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meme_generator/dto/template/template_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_circle_dto/template_circle_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_part_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_part_dto_type.dart';
import 'package:meme_generator/dto/template_part_dto/template_text_dto/template_text_dto.dart';
import 'package:meme_generator/widgets/color_picker/color_picker.dart';
import 'package:meme_generator/widgets/template_part_builder/template_part_builder.dart';
import 'package:screenshot/screenshot.dart';

part 'edit_page_actions.dart';

class EditPage extends StatefulWidget {
  const EditPage({required this.template, super.key});

  final TemplateDto template;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> with _EditPageActions {
  final _templates = Hive.box<TemplateDto>('templates');

  @override
  late final _movingParts = List<TemplatePartDto>.from(widget.template.parts);

  final _imageKey = GlobalKey();

  late final screenshotController = ScreenshotController();

  Color get _defaultBorderColor => Theme.of(context).colorScheme.tertiary;
  late var _borderColor = _defaultBorderColor;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EditPage oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  Size _sizeDecoder(double widthPercent, double heightPercent) {
    final imgSize = imageSize;

    final res = Size(
      widthPercent * imgSize.width,
      heightPercent * imgSize.height,
    );

    return res;
  }

  @override
  Size _sizeEncoder(double widthGlobal, double heightGlobal) {
    final imgSize = imageSize;

    final res = Size(
      widthGlobal / imgSize.width,
      heightGlobal / imgSize.height,
    );

    return res;
  }

  Size get imageSize {
    Size? imageSize;

    try {
      imageSize =
          (_imageKey.currentContext?.findRenderObject() as RenderBox?)?.size;
    } catch (_) {}

    return imageSize ?? Size.zero;
  }

  @override
  Widget build(BuildContext context) {
    Widget res = Center(
      child: GestureDetector(
        onTap: () => setState(() => currentIndex = -1),
        child: Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              Image.memory(
                widget.template.bytes,
                key: _imageKey,
              ),
              for (var i = 0; i < _movingParts.length; i++) ...[
                Positioned(
                  left: _sizeDecoder(_movingParts[i].dx, _movingParts[i].dy)
                      .width,
                  top: _sizeDecoder(_movingParts[i].dx, _movingParts[i].dy)
                      .height,
                  child: Container(
                    decoration: currentIndex == i
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              strokeAlign: 1,
                              width: 3,
                              color: _borderColor,
                            ),
                          )
                        : null,
                    child: GestureDetector(
                      onLongPress: () => setState(() => currentIndex = i),
                      onTap: () => setState(() => currentIndex = i),
                      child: TemplatePartBuilder(
                        sizeDecoder: _sizeDecoder,
                        part: _movingParts[i],
                        onDragStart: () {
                          setState(() => _borderColor = Colors.transparent);
                        },
                        onDragEnd: (drag) {
                          final renderBox = _imageKey.currentContext
                              ?.findRenderObject() as RenderBox;

                          Offset offset = renderBox.globalToLocal(drag.offset);

                          final percentage = _sizeEncoder(offset.dx, offset.dy);

                          setState(() {
                            _borderColor = _defaultBorderColor;
                            _movingParts[i] = TemplatePartDto(
                              dx: percentage.width,
                              dy: percentage.height,
                              value: _movingParts[i].value,
                            );
                            currentIndex = i;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    res = Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _addText,
            icon: const Icon(Icons.text_increase),
          ),
          IconButton(
            onPressed: _addCircle,
            icon: const Icon(Icons.circle_outlined),
          ),
          IconButton(
            onPressed: currentIndex != -1 ? _edit : null,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: currentIndex != -1 ? _delete : null,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _save,
        label: const Text('edit.save').tr(),
        icon: const Icon(Icons.save),
      ),
      body: res,
    );

    return res;
  }

  void _save() async {
    setState(() => currentIndex = -1);

    final preview = await screenshotController.capture();
    _templates.add(TemplateDto(
      bytes: widget.template.bytes,
      previewBytes: preview!,
      parts: _movingParts,
    ));

    if (context.mounted) {
      context.pop();
    }
  }
}
