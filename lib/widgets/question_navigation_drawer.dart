import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujian_sd_babakan_ciparay/app/modules/student_quiz/controllers/student_quiz_controller.dart';
import 'package:ujian_sd_babakan_ciparay/themes/colors.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

class QuestionNavigationDrawer extends StatelessWidget {
  const QuestionNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final StudentQuizController controller = Get.find();

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Navigasi Soal', style: headingSection),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Obx(
                    () => GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.questions.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemBuilder: (context, index) {
                        final question = controller.questions[index];
                        final isAnswered = controller.userAnswers.containsKey(
                          question.id,
                        );

                        return GestureDetector(
                          onTap: () {
                            controller.jumpToQuestion(index);
                            Get.back();
                          },
                          // *** FIX: Use a Column to stack the indicator below the box ***
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    // Use a simple, uniform border for all states
                                    border: Border.all(
                                      color: textMutedColor.withOpacity(0.5),
                                    ),
                                  ),
                                  child: Text('${index + 1}', style: cardTitle),
                                ),
                              ),
                              // TODO: fix container pas udah dijawab
                              if (isAnswered)
                                Container(
                                  height: 3.0,
                                  margin: const EdgeInsets.only(top: 4.0),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.submit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Selesai', style: buttonPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
