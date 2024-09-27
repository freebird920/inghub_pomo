import 'package:go_router/go_router.dart';
import 'package:inghub_pomo/app/page.dart';
import 'package:inghub_pomo/app/settings/page.dart';

final List<RouteBase> _routes = [
  GoRoute(
    path: "/",
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: "/settings",
    builder: (context, state) => const SettingsPage(),
  ),
];

final GoRouter ingHubRouter = GoRouter(routes: _routes);
