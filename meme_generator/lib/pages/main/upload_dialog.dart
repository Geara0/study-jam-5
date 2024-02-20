part of 'main_page.dart';

const _imageTypes = ['jpg', 'jpeg', 'png', 'svg', 'gif'];

class _UploadDialog extends StatefulWidget {
  const _UploadDialog(this.box);

  final Box<TemplateDto> box;

  @override
  State<_UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<_UploadDialog> {
  final _formKey = GlobalKey<FormState>();
  final _textFieldKey = GlobalKey<FormFieldState>();
  final _image = ValueNotifier<ImageProvider?>(null);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.storage),
                label: const Text('main.upload.memory').tr(),
              ),
              const SizedBox(height: 5),
              const Text('main.upload.or').tr(),
              const SizedBox(height: 5),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: TextFormField(
                  key: _textFieldKey,
                  decoration: InputDecoration(
                    hintText: 'main.upload.network'.tr(),
                  ),
                  validator: _loadImage,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _image,
                builder: (context, value, child) {
                  if (value == null) return const SizedBox.shrink();
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Image(
                        image: value,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return Center(
                            child: CircularProgressIndicator.adaptive(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, child) {
                          return Text(
                            'main.upload.error'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Theme.of(context).colorScheme.error),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      FilledButton(
                        onPressed: _uploadImage,
                        child: const Text('main.new').tr(),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    final bytes = await image?.readAsBytes();

    if (bytes == null) return;

    _image.value = MemoryImage(bytes);
  }

  String? _loadImage(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!value.startsWith(RegExp(r'https?://'))) {
      return 'main.upload.invalidUrl'.tr();
    }

    final url = value.split('://')[1];

    try {
      final uri = Uri.parse(url);
      final uriLower = uri.path.toLowerCase();

      final type = _imageTypes.firstWhere(
        (e) => uriLower.endsWith(e),
        orElse: () => '',
      );

      if (type.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          _image.value = NetworkImage(value);
        });
        return null;
      }
    } catch (_) {}

    return 'main.upload.invalidUrl'.tr();
  }

  void _uploadImage() async {
    if (_image.value is NetworkImage) {
      final image = _image.value as NetworkImage;
      final img = await http.get(Uri.parse(image.url));
      widget.box.add(TemplateDto(
        bytes: img.bodyBytes,
        previewBytes: img.bodyBytes,
      ));
    } else if (_image.value is MemoryImage) {
      final image = _image.value as MemoryImage;
      widget.box.add(TemplateDto(
        bytes: image.bytes,
        previewBytes: image.bytes,
      ));
    }

    if (mounted) {
      context.pop();
    }
  }
}
