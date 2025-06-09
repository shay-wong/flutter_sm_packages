import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/locale_controller.dart';

class LocalePage extends GetView<LocaleController> {
  const LocalePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalePage'),
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: controller.supportLocales.length,
        itemBuilder: (context, index) {
          final locale = controller.supportLocales[index];
          return ListTile(
            title: Text(locale.toString()),
            trailing: Checkbox(
              value: locale == Get.locale,
              onChanged: (value) async {
                await Get.updateLocale(locale);
              },
            ),
          );
        },
      ),
    );
  }
}
