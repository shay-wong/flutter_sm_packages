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
          isAdsorb: true,
          isHiding: true,
        ),
        routeOptions: RouteOptions(
          getNavigatorKey: () => Get.key,
        ),
      ),
      child: GetMaterialApp(
        title: "Application",
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        // builder: Peek.init(
        //   options: PeekOptions(
        //     enable: true,
        //     entryOptions: EntryOptions(
        //       isAdsorb: true,
        //       isHiding: true,
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
