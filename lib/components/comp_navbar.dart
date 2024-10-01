import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inghub_pomo/app/routes.dart';

class CompNavbar extends StatefulWidget {
  const CompNavbar({super.key});
  @override
  State<CompNavbar> createState() => _CompNavbarState();
}

class _CompNavbarState extends State<CompNavbar> {
  // 현재 선택된 index를 저장할 변수
  late int _selectedIndex;

  // didChangeDependencies를 통해 현재 URI를 가져와서 해당 path의 index를 찾기 위한 변수
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 현재 URI를 가져와서 '/'를 기준으로 split
    final uri = GoRouter.of(context).routeInformationProvider.value.uri;
    final myUriSplit = uri.toString().split("/");
    final myUri = Uri.parse("/${myUriSplit[1]}");
    // ingRoutes에서 해당 path의 index를 찾음
    _selectedIndex =
        ingRoutes.indexWhere((element) => element.path == myUri.toString());
    // 만약 매칭되는 path가 없을 경우 기본값 0으로 설정
    if (_selectedIndex == -1) _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (int value) {
        final goRouter = GoRouter.of(context);
        // 선택된 index에 따라 이동할 path 설정
        final path = ingRoutes[value].path;
        goRouter.go(path);
      },
      items: ingRoutes
          .map(
            (element) => BottomNavigationBarItem(
              icon: element.icon,
              label: element.pathName ?? element.path,
            ),
          )
          .toList(),
    );
  }
}
