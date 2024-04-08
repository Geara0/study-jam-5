import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meme_generator/dto/template/template_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_circle_dto/template_circle_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_part_dto.dart';
import 'package:meme_generator/dto/template_part_dto/template_part_dto_type.dart';
import 'package:meme_generator/dto/template_part_dto/template_text_dto/template_text_dto.dart';
import 'package:meme_generator/widgets/color_picker/color_picker.dart';
import 'package:meme_generator/widgets/template_part_builder/template_part_builder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

part 'edit_page_actions.dart';

class EditPage extends StatefulWidget {
  const EditPage({
    required this.index,
    required this.template,
    super.key,
  });

  final int index;
  final TemplateDto template;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> with _EditPageActions {
  final _templates = Hive.box<TemplateDto>('templates');

  @override
  late final List<TemplatePartDto> _movingParts =
      List<TemplatePartDto>.from(widget.template.parts);

  final _imageKey = GlobalKey();

  late final screenshotController = ScreenshotController();

  Color get _defaultBorderColor => Theme.of(context).colorScheme.tertiary;
  late var _borderColor = _defaultBorderColor;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() {});
      });
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) setState(() {});
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
    super.didChangeDependencies();
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

    final outlineTextStyle = TextStyle(
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.15
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Theme.of(context).colorScheme.background,
    );
    final fillTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
    );

    Widget getText(String text) {
      return Stack(
        children: [
          Text(text, style: fillTextStyle),
          Text(text, style: outlineTextStyle),
        ],
      );
    }

    res = Scaffold(
      resizeToAvoidBottomInset: false,
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
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.up,
        distance: 60,
        childrenOffset: const Offset(0, -10),
        overlayStyle: ExpandableFabOverlayStyle(blur: 20),
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.save),
          fabSize: ExpandableFabSize.regular,
        ),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
          heroTag: 'deleteFab',
          child: const Icon(Icons.close),
          fabSize: ExpandableFabSize.small,
        ),
        children: [
          Row(
            children: [
              getText('edit.share'.tr()),
              const SizedBox(width: 10),
              FloatingActionButton(
                heroTag: 'shareFab',
                onPressed: _share,
                child: Icon(Icons.adaptive.share),
              ),
            ],
          ),
          Row(
            children: [
              getText('edit.save'.tr()),
              const SizedBox(width: 20),
              FloatingActionButton.small(
                heroTag: 'saveFab',
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onSecondaryContainer,
                onPressed: _save,
                child: const Icon(Icons.save),
              ),
            ],
          ),
          Row(
            children: [
              getText('edit.saveNew'.tr()),
              const SizedBox(width: 20),
              FloatingActionButton.small(
                heroTag: 'saveNewFab',
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                foregroundColor:
                    Theme.of(context).colorScheme.onSecondaryContainer,
                onPressed: () => _save(true),
                child: const Icon(Icons.save_as),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(child: res),
    );

    return res;
  }

  void _save([bool saveAs = false]) async {
    setState(() => currentIndex = -1);

    final preview = await screenshotController.capture();
    if (saveAs) {
      _templates.add(TemplateDto(
        bytes: widget.template.bytes,
        previewBytes: preview!,
        parts: _movingParts,
      ));
    } else {
      _templates.putAt(
          widget.index,
          TemplateDto(
            bytes: widget.template.bytes,
            previewBytes: preview!,
            parts: _movingParts,
          ));
    }

    if (context.mounted) {
      context.pop();
    }
  }

  void _share() async {
    // remove selection to capture template
    final tmpCurrent = currentIndex;
    setState(() => currentIndex = -1);
    final bytes = await screenshotController.capture();
    // add selection back to capture template
    setState(() => currentIndex = tmpCurrent);
    if (bytes == null) return;

    // idk why we need to save first. Some XFile issues (I guess)
    final tmpDir = await getTemporaryDirectory();
    final path = '${tmpDir.path}/template.png';
    final saveFile = XFile.fromData(bytes);
    saveFile.saveTo(path);
    final memFile = XFile(path);

    // wait for file to open???
    await Future.delayed(const Duration(milliseconds: 100));

    Share.shareXFiles([memFile]);
  }
}
