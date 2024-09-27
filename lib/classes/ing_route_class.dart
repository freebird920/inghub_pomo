import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IngRoute {
  final String path;
  final String? pathName;
  final Widget Function(BuildContext, GoRouterState)? builder;
  final Icon icon;
  final List<RouteBase>? routes;
  const IngRoute({
    required this.path,
    required this.builder,
    required this.icon,
    this.pathName,
    this.routes,
  });
}
