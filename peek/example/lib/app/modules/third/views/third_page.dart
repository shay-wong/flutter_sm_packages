import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/third_controller.dart';

class ThirdPage extends GetView<ThirdController> {
  const ThirdPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ThirdPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ThirdPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
