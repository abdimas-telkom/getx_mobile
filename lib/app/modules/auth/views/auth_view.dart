import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50),
                Center(
                  child: Image.asset('assets/images/login_background.png'),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'SDN 227 Margahayu Utara',
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Selamat Datang!', style: textTheme.displaySmall),
                const SizedBox(height: 8),
                const Text(
                  'Silakan masukkan Username dan Password untuk mengakses akun Anda.',
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  // Decoration is also inherited from the theme
                  decoration: const InputDecoration(labelText: 'Kata Sandi'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.handleAuth,
                    child: const Text('Masuk'),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    print('Lupa kata sandi?');
                  },
                  child: const Text('Lupa kata sandi?'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
