import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_strings.dart';
import '../providers/weak_topics_provider.dart';
import '../widgets/custom_widgets.dart';
import '../widgets/feature_widgets.dart';

class WeakTopicsScreen extends ConsumerStatefulWidget {
  const WeakTopicsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WeakTopicsScreen> createState() => _WeakTopicsScreenState();
}

class _WeakTopicsScreenState extends ConsumerState<WeakTopicsScreen> {
  @override
  void initState() {
    super.initState();
    _loadWeakTopics();
  }

  void _loadWeakTopics() async {
    await ref.read(weakTopicsProvider.notifier).loadWeakTopics();
  }

  @override
  Widget build(BuildContext context) {
    final topics = ref.watch(weakTopicsProvider);
    final topicsByPriority =
        topics.where((t) => t.priority <= 2).toList()
        ..sort((a, b) => a.priority.compareTo(b.priority));

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.weakTopics),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Card
            PremiumCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outlined,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'These are topics where you need more practice. Review them regularly to improve your score.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Priority List
            Text(
              AppStrings.priorityList,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            if (topicsByPriority.isEmpty)
              Center(
                child: EmptyStateWidget(
                  icon: Icons.star_outline,
                  title: 'No weak topics',
                  message: 'Keep practicing and you\'ll master all topics!',
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topicsByPriority.length,
                itemBuilder: (context, index) {
                  final topic = topicsByPriority[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: WeakTopicCard(
                      subject: topic.subject,
                      chapter: topic.chapter,
                      accuracy: topic.accuracyPercentage,
                      priority: topic.priority,
                      onTap: () {
                        _showRevisionPlan(topic);
                      },
                    ),
                  );
                },
              ),

            if (topics.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                AppStrings.suggestedRevision,
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
                      'Daily Revision Plan',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...[
                      'Review ${topicsByPriority.length} weak topics',
                      'Practice 10 MCQs per topic',
                      'Focus on high-priority topics first',
                      'Revisit after 2 days',
                    ].asMap().entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${entry.key + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Revision plan activated!'),
                            ),
                          );
                        },
                        child: const Text(AppStrings.reviseNow),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showRevisionPlan(dynamic topic) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${topic.subject} - ${topic.chapter}',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Text('Accuracy: ${topic.accuracyPercentage.toStringAsFixed(1)}%'),
            const SizedBox(height: 10),
            Text(
              'Answered: ${topic.totalQuestionsAnswered} | Wrong: ${topic.wrongAnswersCount}',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening revision mode...')),
                  );
                },
                child: const Text('Start Revision'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
