part of 'edit_page.dart';

mixin _EditPageActions<T extends StatefulWidget> on State<T> {
  List<TemplatePartDto> get _movingParts;
  int currentIndex = -1;

  _addText({int? replace}) {
    final controller = TextEditingController();
    final colors = [
      Colors.black,
      Colors.white,
      Colors.red,
      Colors.blue,
      Colors.purple
    ];

    final selectedColor = ValueNotifier(colors.first);

    final isBald = ValueNotifier(false);
    final isItalic = ValueNotifier(false);

    final size = ValueNotifier(20.0);

    void dispose() {
      controller.dispose();
      selectedColor.dispose();
      isBald.dispose();
      isItalic.dispose();
      size.dispose();
    }

    if (replace != null) {
      final replaceDto = _movingParts[replace].value as TemplateTextDto;
      controller.text = replaceDto.text;
      isBald.value = replaceDto.isBald;
      isItalic.value = replaceDto.isItalic;
      selectedColor.value = replaceDto.color;
    }

    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'edit.addText'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: TextField(controller: controller),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 28,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: colors.length,
                      itemBuilder: (context, i) {
                        return ValueListenableBuilder(
                          valueListenable: selectedColor,
                          builder: (context, value, child) {
                            Widget res = CircleAvatar(
                              key: ValueKey('$i inner'),
                              maxRadius: value == colors[i] ? 12 : 14,
                              backgroundColor: colors[i],
                            );

                            res = CircleAvatar(
                              key: ValueKey('$i outer'),
                              maxRadius: 14,
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              child: res,
                            );

                            res = SizedBox(
                              width: 28,
                              height: 28,
                              child: GestureDetector(
                                onTap: () => selectedColor.value = colors[i],
                                child: res,
                              ),
                            );

                            return res;
                          },
                          child: CircleAvatar(
                            maxRadius: 14,
                            backgroundColor: colors[i],
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 5),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: size,
                    builder: (context, value, child) {
                      return Slider(
                        min: 1,
                        max: 100,
                        value: value,
                        onChanged: (newValue) => size.value = newValue,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
                    valueListenable: isBald,
                    builder: (context, value, child) {
                      return CheckboxListTile(
                        title: const Text('edit.text.bald').tr(),
                        value: value,
                        onChanged: (_) => setState(() {
                          isBald.value = !value;
                        }),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: isItalic,
                    builder: (context, value, child) {
                      return CheckboxListTile(
                        title: const Text('edit.text.italic').tr(),
                        value: value,
                        onChanged: (_) => setState(() {
                          isItalic.value = !value;
                        }),
                      );
                    },
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FilledButton.tonal(
                          onPressed: () {
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () => dispose(),
                            );
                            context.pop();
                          },
                          child: const Text('edit.modal.no').tr(),
                        ),
                        const SizedBox(width: 5),
                        FilledButton.tonal(
                          onPressed: () {
                            var dx = .0;
                            var dy = .0;

                            if (replace != null) {
                              final replaceDto = _movingParts[replace];
                              dx = replaceDto.dx;
                              dy = replaceDto.dy;
                            }

                            final part = TemplatePartDto(
                              value: TemplateTextDto(
                                text: controller.text,
                                color: selectedColor.value,
                                isBald: isBald.value,
                                isItalic: isItalic.value,
                                size: size.value,
                              ),
                              dx: dx,
                              dy: dy,
                            );

                            setState(() {
                              if (replace != null) {
                                _movingParts[replace] = part;
                              } else {
                                _movingParts.add(part);
                              }
                            });

                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () => dispose(),
                            );
                            context.pop();
                          },
                          child: const Text('edit.modal.ok').tr(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _edit() {
    if (currentIndex == -1) return;

    final type = _movingParts[currentIndex].type;
    if (type == TemplateType.text) {
      _addText(replace: currentIndex);
    }
  }

  void _delete() {
    if (currentIndex == -1) return;

    setState(() => _movingParts.removeAt(currentIndex));
  }
}
