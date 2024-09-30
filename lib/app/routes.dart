import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inghub_pomo/app/page.dart';
import 'package:inghub_pomo/app/profiles/page.dart';
import 'package:inghub_pomo/app/settings/page.dart';
import 'package:inghub_pomo/app/settings/set_profiles/page.dart';
import 'package:inghub_pomo/app/utils/keys.dart';
import 'package:inghub_pomo/classes/ing_route_class.dart';

final List<IngRoute> ingRoutes = [
  IngRoute(
    path: "/",
    pathName: "홈",
    builder: (context, state) => const HomePage(),
    icon: const Icon(Icons.home),
  ),
  IngRoute(
    path: "/profiles",
    pathName: "프로필",
    builder: (context, state) => const ProfilesPage(),
    icon: const Icon(Icons.person),
  ),
  IngRoute(
    path: "/settings",
    pathName: "설정",
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

final GoRouter ingHubRouter = GoRouter(
  routes: _routes,
  navigatorKey: navigatorKey,
);
