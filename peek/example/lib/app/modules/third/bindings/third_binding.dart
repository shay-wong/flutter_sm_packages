import 'package:get/get.dart';

import '../controllers/third_controller.dart';

class ThirdBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<ThirdController>(
        () => ThirdController(),
      ),
    ];
  }
}
