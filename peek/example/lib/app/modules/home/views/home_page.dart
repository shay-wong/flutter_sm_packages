import 'package:example/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peek/peek.dart';

import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Peek.toggle();
          },
          icon: const Icon(
            Icons.troubleshoot_rounded,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Get.toNamed(Routes.locale);
            },
            icon: const Icon(
              Icons.language_rounded,
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'HomePage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(
            Routes.second,
            arguments: {
              'name': 'Second',
              'age': 20,
            },
          );
        },
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}
