import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_generator/dto/template/template_dto.dart';
import 'package:meme_generator/widgets/template_preview/template_preview.dart';
import 'package:http/http.dart' as http;

part 'upload_dialog.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final templates = Hive.box<TemplateDto>('templates');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('main.title').tr(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAdaptiveDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) {
                return Center(
                  child: _UploadDialog(templates),
                );
              });
        },
        label: const Text('main.new').tr(),
        icon: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: templates.listenable(),
        builder: (context, value, child) {
          final templates = value.values.toList(growable: false);
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final i = templates.length - 1 - index;
              return TemplatePreview(templates[i]);
            },
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
        },
      ),
    );
  }
}
