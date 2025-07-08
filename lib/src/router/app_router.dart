import 'package:auto_route/auto_route.dart';
import 'package:flutter_tv_sample/src/ui/home.dart';
import 'package:flutter_tv_sample/src/ui/login.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, initial: true),
        AutoRoute(page: HomeRoute.page, path: '/home')
      ];
}
