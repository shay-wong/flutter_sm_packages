import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:peek/peek.dart';

import 'app/routes/app_pages.dart';

bool showSemanticsDebugger = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    Peek.builder(
      builder: (context) {
        return GetMaterialApp(
          title: "Application",
          initialRoute: AppPages.initial,
          showSemanticsDebugger: showSemanticsDebugger,
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale.fromSubtags(
              languageCode: 'ar',
            ),
          ],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale('en', 'US'),
          getPages: AppPages.routes,
          navigatorObservers: [
            CustomObservers(),
          ],
        );
      },
      options: PeekOptions(
        enable: true,
        entryOptions: EntryOptions(
          adsorb: true,
          autoHide: true,
          showEntry: false,
        ),
        menuOptions: MenuOptions(
          enable: true,
          autoHide: true,
        ),
        routeOptions: RouteOptions(
          getNavigatorKey: () => Get.key,
        ),
        inspectorOptions: InspectorOptions(
          showSemanticsDebuggerCallback: (value) {
            showSemanticsDebugger = value;
          },
        ),
      ),
      // child: GetMaterialApp(
      //   title: "Application",
      //   initialRoute: AppPages.initial,
      //   showSemanticsDebugger: showSemanticsDebugger,
      //   supportedLocales: [
      //     const Locale('en', 'US'),
      //     const Locale.fromSubtags(
      //       languageCode: 'ar',
      //     ),
      //   ],
      //   localizationsDelegates: [
      //     GlobalMaterialLocalizations.delegate,
      //     GlobalWidgetsLocalizations.delegate,
      //     GlobalCupertinoLocalizations.delegate,
      //   ],
      //   locale: const Locale('en', 'US'),
      //   getPages: AppPages.routes,
      //   navigatorObservers: [
      //     CustomObservers(),
      //   ],
      //   // builder: Peek.transitionBuilder(
      //   //   options: PeekOptions(
      //   //     enable: true,
      //   //     entryOptions: EntryOptions(
      //   //       adsorb: true,
      //   //       autoHide: true,
      //   //       showEntry: false,
      //   //     ),
      //   //     menuOptions: MenuOptions(
      //   //       enable: true,
      //   //       autoHide: true,
      //   //     ),
      //   //     routeOptions: RouteOptions(
      //   //       getNavigatorKey: () => Get.key,
      //   //     ),
      //   //   ),
      //   // ),
      // ),
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
