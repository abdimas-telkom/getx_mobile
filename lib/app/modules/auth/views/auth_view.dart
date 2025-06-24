import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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

                Obx(
                  () => TextField(
                    controller: controller.passwordController,
                    obscureText: controller.obscurePassword.value,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: textMutedColor,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => Row(
                        children: [
                          Checkbox(
                            value: controller.rememberMe.value,
                            onChanged: (value) {
                              controller.rememberMe.value = value ?? false;
                            },
                            activeColor: primaryColor,
                          ),
                          GestureDetector(
                            onTap: () => controller.rememberMe.toggle(),
                            child: const Text('Ingat Saya'),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.dialog<bool>(
                          AlertDialog(
                            title: const Text('Lupa Kata Sandi?'),
                            content: const Text(
                              'Silahkan hubungi admin atau pihak sekolah untuk mengubah kata sandi.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text('Kembali'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Lupa kata sandi?'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.handleAuth,
                    child: const Text('Masuk'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
