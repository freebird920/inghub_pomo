import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inghub_pomo/app/page.dart';
import 'package:inghub_pomo/app/profiles/page.dart';
import 'package:inghub_pomo/app/set_pomo/page.dart';
import 'package:inghub_pomo/app/settings/page.dart';
import 'package:inghub_pomo/app/utils/keys.dart';
import 'package:inghub_pomo/classes/ing_route_class.dart';

final List<IngRoute> ingRoutes = [
  IngRoute(
    path: "/",
    pathName: "홈",
    icon: const Icon(Icons.home),
    route: GoRoute(
      path: "/",
      builder: (context, state) => const HomePage(),
    ),
  ),
  IngRoute(
    path: "/profiles",
    pathName: "프로필",
    route: GoRoute(
      path: "/profiles",
      builder: (context, state) => const ProfilesPage(),
    ),
    icon: const Icon(Icons.person),
  ),
  IngRoute(
      path: "/set_pomo",
      pathName: "Pomo 설정",
      route: GoRoute(
          path: "/set_pomo", builder: (context, state) => const SetPomoPage()),
      icon: const Icon(Icons.ac_unit)),
  IngRoute(
    path: "/settings",
    pathName: "설정",
    icon: const Icon(Icons.settings),
    route: GoRoute(
      path: "/settings",
      builder: (context, state) => const SettingsPage(),
    ),
  ),
];

final List<RouteBase> _routes = ingRoutes
    .map(
      (element) => element.route,
    )
    .toList();

final GoRouter ingHubRouter = GoRouter(
  routes: _routes,
  navigatorKey: navigatorKey,
);
