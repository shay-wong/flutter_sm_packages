import 'package:get/get.dart';

import '../controllers/locale_controller.dart';

class LocaleBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<LocaleController>(
        () => LocaleController(),
      ),
    ];
  }
}
