import 'package:flutter/material.dart';

const colors = [
  Colors.black,
  Colors.white,
  Colors.red,
  Colors.blue,
  Colors.purple
];

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    required this.selectedColor,
    super.key,
  });

  final ValueNotifier<Color> selectedColor;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Wrap(
        spacing: 10,
        runSpacing: 5,
        alignment: WrapAlignment.center,
        children: [
          for (var i = 0; i < colors.length; i++)
            ValueListenableBuilder(
              valueListenable: widget.selectedColor,
              builder: (context, value, child) {
                Widget res = CircleAvatar(
                  key: ValueKey('$i inner'),
                  maxRadius: value == colors[i] ? 12 : 14,
                  backgroundColor: colors[i],
                );

                res = CircleAvatar(
                  key: ValueKey('$i outer'),
                  maxRadius: 14,
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  child: res,
                );

                res = SizedBox(
                  width: 28,
                  height: 28,
                  child: GestureDetector(
                    onTap: () => widget.selectedColor.value = colors[i],
                    child: res,
                  ),
                );

                return res;
              },
              child: CircleAvatar(
                maxRadius: 14,
                backgroundColor: colors[i],
              ),
            ),
        ],
      ),
    );
  }
}
