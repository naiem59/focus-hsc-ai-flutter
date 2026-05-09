import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_strings.dart';
import '../models/study_routine.dart';
import '../providers/routine_provider.dart';
import '../utils/date_utils.dart' as date_utils;
import '../widgets/custom_widgets.dart';
import '../widgets/feature_widgets.dart';

class RoutineScreen extends ConsumerStatefulWidget {
  const RoutineScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends ConsumerState<RoutineScreen> {
  @override
  void initState() {
    super.initState();
    _loadRoutine();
  }

  void _loadRoutine() async {
    await ref.read(routineProvider.notifier).loadTodayRoutine();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(routineProvider);
    final stats = ref.watch(routineStatsProvider);
    final daysLeft = date_utils.DateUtils.getDaysUntilExam();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.studyRoutine),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exam Countdown
            CountdownTimer(
              daysLeft: daysLeft,
              examName: 'HSC 1st Year Arts 2026',
            ),
            const SizedBox(height: 20),

            // Progress Stats
            Row(
              children: [
                Expanded(
                  child: PremiumCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${stats.completedTasks}/${stats.totalTasks}',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tasks Completed',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PremiumCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${stats.remainingDuration}m',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Time Remaining',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: stats.totalTasks == 0
                    ? 0
                    : stats.completedTasks / stats.totalTasks,
                minHeight: 10,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF10B981),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Daily Checklist
            Text(
              AppStrings.dailyChecklist,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            if (tasks.isEmpty)
              Center(
                child: EmptyStateWidget(
                  icon: Icons.checklist_outlined,
                  title: 'No tasks for today',
                  message: 'Create a new study plan to get started',
                  actionLabel: 'Generate Plan',
                  onActionPressed: () {
                    _generateDailyRoutine();
                  },
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RoutineTaskTile(
                      title: task.title,
                      subject: task.subject,
                      duration: task.duration,
                      isCompleted: task.isCompleted,
                      onTap: () {
                        // Navigate to subject study
                      },
                      onCompleteToggle: () {
                        if (!task.isCompleted) {
                          ref
                              .read(routineProvider.notifier)
                              .markTaskAsCompleted(task.id);
                        }
                      },
                      onDelete: () {
                        ref.read(routineProvider.notifier).deleteTask(task.id);
                      },
                    ),
                  );
                },
              ),

            const SizedBox(height: 20),

            // Add Task Button
            if (tasks.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _showAddTaskDialog();
                  },
                  child: const Text(AppStrings.addTask),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _generateDailyRoutine() async {
    // Sample tasks
    final sampleTasks = [
      StudyRoutineTask(
        id: const Uuid().v4(),
        title: 'English Grammar Practice',
        subject: 'ইংরেজি ১ম পত্র',
        description: 'Complete grammar exercises',
        duration: 45,
        createdDate: DateTime.now(),
        priority: 1,
      ),
      StudyRoutineTask(
        id: const Uuid().v4(),
        title: 'MCQ Practice',
        subject: 'বাংলা ১ম পত্র',
        description: 'Solve 20 MCQs',
        duration: 30,
        createdDate: DateTime.now(),
        priority: 1,
      ),
      StudyRoutineTask(
        id: const Uuid().v4(),
        title: 'History Review',
        subject: 'ইতিহাস',
        description: 'Review important dates',
        duration: 40,
        createdDate: DateTime.now(),
        priority: 2,
      ),
    ];

    for (var task in sampleTasks) {
      await ref.read(routineProvider.notifier).addTask(task);
    }
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.addTask),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Task Title'),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(labelText: 'Subject'),
              ),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task added successfully')),
              );
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }
}
