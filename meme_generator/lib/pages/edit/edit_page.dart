import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_generator/dto/template/template_dto.dart';

class EditPage extends StatefulWidget {
  const EditPage({required this.template, super.key});

  final TemplateDto template;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Image.memory(widget.template.bytes)),
    );
  }
}
