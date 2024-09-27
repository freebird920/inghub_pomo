import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IngRoute {
  final String path;
  final String? pathName;
  final Widget Function(BuildContext, GoRouterState)? builder;
  final Icon icon;
  const IngRoute({
    required this.path,
    this.pathName,
    required this.builder,
    required this.icon,
  });
}
