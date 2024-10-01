import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IngRoute {
  final String path;
  final String? pathName;
  final Icon icon;
  final GoRoute route;
  final List<RouteBase>? routes;
  const IngRoute({
    required this.path,
    required this.route,
    required this.icon,
    this.pathName,
    this.routes,
  });
}
