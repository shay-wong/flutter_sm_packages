import 'dart:ui';

import 'package:get/get.dart';

class LocaleController extends GetxController {
  final supportLocales = [
    const Locale('en', 'US'),
    const Locale.fromSubtags(
      languageCode: 'ar',
    ),
  ];
}
