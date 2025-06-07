import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peek/peek.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    Peek(
      options: PeekOptions(
        enable: true,
        entryOptions: EntryOptions(
          adsorb: true,
          autoHide: true,
        ),
        menuOptions: MenuOptions(
          enable: true,
          autoHide: true,
        ),
        routeOptions: RouteOptions(
          getNavigatorKey: () => Get.key,
        ),
      ),
      child: GetMaterialApp(
        title: "Application",
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        navigatorObservers: [
          CustomObservers(),
        ],
        // builder: Peek.builder(
        //   options: PeekOptions(
        //     enable: true,
        //     entryOptions: EntryOptions(
        //       adsorb: true,
        //       autoHide: true,
        //     ),
        //     routeOptions: RouteOptions(
        //       getNavigatorKey: () => Get.key,
        //     ),
        //   ),
        // ),
      ),
    ),
  );
}

class CustomObservers extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    // ignore: avoid_print
    print('didPush');
    super.didPush(route, previousRoute);
  }
}
