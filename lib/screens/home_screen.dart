import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../utils/date_utils.dart' as date_utils;
import '../widgets/custom_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysLeft = date_utils.DateUtils.getDaysUntilExam();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            elevation: 0,
            expandedHeight: 0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppStrings.home,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Card
                    PremiumCard(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.goodMorning,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ready to ace your HSC exams? Let\'s study smart!',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Study Progress
                    ProgressIndicatorCard(
                      title: AppStrings.studyProgress,
                      percentage: 65,
                      subtitle: 'Continue your streak!',
                      progressColor: AppColors.successGreen,
                    ),
                    const SizedBox(height: 20),

                    // Today's Study Plan Card
                    CountdownTimer(
                      daysLeft: daysLeft,
                      examName: 'HSC 1st Year Arts 2026',
                    ),
                    const SizedBox(height: 20),

                    // Quick Actions Title
                    Text(
                      AppStrings.quickActions,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Quick Actions Grid
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        QuickActionButton(
                          label: AppStrings.aiChat,
                          icon: Icons.chat_bubble_outline,
                          onTap: () {
                            Navigator.pushNamed(context, '/chat');
                          },
                        ),
                        QuickActionButton(
                          label: AppStrings.mcqPractice,
                          icon: Icons.quiz_outlined,
                          onTap: () {
                            Navigator.pushNamed(context, '/mcq');
                          },
                        ),
                        QuickActionButton(
                          label: AppStrings.cqHelper,
                          icon: Icons.edit_outlined,
                          onTap: () {
                            Navigator.pushNamed(context, '/cq_helper');
                          },
                        ),
                        QuickActionButton(
                          label: AppStrings.pomodoroTimer,
                          icon: Icons.timer_outlined,
                          onTap: () {
                            // Show Pomodoro bottom sheet
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Continue Study Section
                    Text(
                      AppStrings.continueStudy,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    PremiumCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ইংরেজি ১ম পত্র - Chapter 3',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: 0.65,
                              minHeight: 8,
                              backgroundColor: AppColors.dividerLight.withOpacity(0.5),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primaryLight,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '13/20 MCQs',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/mcq');
                                },
                                child: const Text('Continue'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
