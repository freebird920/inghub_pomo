import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inghub_pomo/app/page.dart';
import 'package:inghub_pomo/app/settings/page.dart';
import 'package:inghub_pomo/classes/ing_route_class.dart';

final List<IngRoute> ingRoutes = [
  IngRoute(
    path: "/",
    pathName: "홈",
    builder: (context, state) => const HomePage(),
    icon: const Icon(Icons.home),
  ),
  IngRoute(
    path: "/settings",
    pathName: "설정",
    builder: (context, state) => const SettingsPage(),
    icon: const Icon(Icons.settings),
    routes: <RouteBase>[
      GoRoute(
        path: "profiles",
        builder: (context, state) => const SettingsPage(),
      )
    ],
  ),
  IngRoute(
    path: "/settings2",
    pathName: "설정2",
    builder: (context, state) => const SettingsPage(),
    icon: const Icon(Icons.settings),
  ),
];

final List<RouteBase> _routes = ingRoutes
    .map(
      (element) => GoRoute(
        path: element.path,
        builder: element.builder,
        routes: element.routes ?? [],
      ),
    )
    .toList();

final GoRouter ingHubRouter = GoRouter(routes: _routes);
