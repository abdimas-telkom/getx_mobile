import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/form_field_with_label.dart';
import 'package:ujian_sd_babakan_ciparay/widgets/switch_row.dart';
import '../controllers/teacher_quiz_create_controller.dart';

class TeacherQuizCreateView extends GetView<TeacherQuizCreateController> {
  const TeacherQuizCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Ujian'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormFieldWithLabel(
                label: 'Judul Ujian',
                child: TextField(
                  onChanged: (v) => controller.title.value = v,
                  decoration: InputDecoration(hintText: 'Masukkan Judul Ujian'),
                ),
                isRequired: true,
              ),
              const SizedBox(height: 24),
              FormFieldWithLabel(
                label: 'Deskripsi Ujian',
                child: TextField(
                  onChanged: (v) => controller.description.value = v,
                  decoration: InputDecoration(
                    hintText: 'Masukkan deskripsi dari Ujianmu disini',
                  ),
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 24),
              SwitchRow(
                title: 'Gunakan Kode Kustom',
                subtitle: 'Buat Kode yang mudah diingat untuk murid',
                value: controller.useCustom.value,
                onChanged: (v) => controller.useCustom.value = v,
              ),
              if (controller.useCustom.value) ...[
                const SizedBox(height: 16),
                TextField(
                  onChanged: (v) => controller.code.value = v,
                  decoration: InputDecoration(hintText: 'e.g., MTK101'),
                  maxLength: 8,
                ),
              ],
              const SizedBox(height: 24),
              FormFieldWithLabel(
                label: 'Durasi Ujian',
                child: TextField(
                  onChanged: (v) =>
                      controller.timeLimit.value = int.tryParse(v),
                  decoration: InputDecoration(
                    hintText: 'Satuan Menit, Minimal 10 menit',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                isRequired: true,
              ),
              const SizedBox(height: 24),
              SwitchRow(
                title: 'Aktifkan Ujian',
                subtitle: 'Murid bisa langsung masuk ketika kuis aktif',
                value: controller.isActive.value,
                onChanged: (v) => controller.isActive.value = v,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submit,
                  child: const Text('Buat Ujian'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
