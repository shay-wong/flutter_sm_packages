import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_page.dart';
import '../modules/second/bindings/second_binding.dart';
import '../modules/second/views/second_page.dart';
import '../modules/third/bindings/third_binding.dart';
import '../modules/third/views/third_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.second,
      page: () => const SecondPage(),
      binding: SecondBinding(),
    ),
    GetPage(
      name: _Paths.third,
      page: () => const ThirdPage(),
      binding: ThirdBinding(),
    ),
  ];
}
