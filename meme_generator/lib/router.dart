import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:meme_generator/dto/template/template_dto.dart';
import 'package:meme_generator/pages/edit/edit_page.dart';
import 'package:meme_generator/pages/main/main_page.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => MainPage(key: state.pageKey),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) {
              final (index, template) = state.extra as (int, TemplateDto);
              return OrientationBuilder(
                key: state.pageKey,
                builder: (context, orientation) {
                  return EditPage(
                    index: index,
                    template: template,
                  );
                },
              );
            },
          ),
        ]),
  ],
);
