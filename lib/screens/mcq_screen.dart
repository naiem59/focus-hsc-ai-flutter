import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/mcq_question.dart';
import '../providers/mcq_provider.dart';
import '../providers/weak_topics_provider.dart';
import '../widgets/feature_widgets.dart';
import '../widgets/custom_widgets.dart';

class MCQScreen extends ConsumerStatefulWidget {
  const MCQScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MCQScreen> createState() => _MCQScreenState();
}

class _MCQScreenState extends ConsumerState<MCQScreen> {
  String? _selectedSubject;
  String? _selectedChapter;
  bool _showChapterSelection = false;
  int _totalQuestions = 0;
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _generateSampleMCQs();
  }

  void _generateSampleMCQs() {
    // Generate sample MCQs
    ref.read(mcqQuestionsProvider.notifier).generateSampleMCQs(
      _selectedSubject ?? 'ইংরেজি ১ম পত্র',
      _selectedChapter ?? 'Chapter 1',
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(mcqQuestionsProvider);
    final currentIndex = ref.watch(currentMCQIndexProvider);

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.mcqPractice)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.quiz_outlined,
                size: 64,
                color: AppColors.primaryLight,
              ),
              const SizedBox(height: 16),
              Text(
                'Select a subject to begin',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              _buildSubjectSelector(),
            ],
          ),
        ),
      );
    }

    if (currentIndex >= questions.length) {
      return _buildResultsScreen(questions);
    }

    final currentQuestion = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.mcqPractice),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentIndex + 1}/${questions.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${((currentIndex + 1) / questions.length * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.successGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / questions.length,
                  minHeight: 6,
                  backgroundColor: AppColors.dividerLight.withOpacity(0.5),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Question Card
              PremiumCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Difficulty Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(currentQuestion.difficulty)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        currentQuestion.difficulty,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getDifficultyColor(currentQuestion.difficulty),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Question Text
                    Text(
                      'Question',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currentQuestion.question,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Options
              ...List.generate(
                currentQuestion.options.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MCQOptionButton(
                    label: String.fromCharCode(65 + index),
                    option: currentQuestion.options[index],
                    isSelected: currentQuestion.userAnswerIndex == index,
                    isCorrect: index == currentQuestion.correctAnswerIndex,
                    showResult: currentQuestion.isAnswered(),
                    onTap: () {
                      if (!currentQuestion.isAnswered()) {
                        ref
                            .read(mcqQuestionsProvider.notifier)
                            .answerQuestion(currentIndex, index);

                        // Track weak topics
                        if (index != currentQuestion.correctAnswerIndex) {
                          ref
                              .read(weakTopicsProvider.notifier)
                              .trackWrongAnswer(
                                currentQuestion.subject,
                                currentQuestion.chapter,
                              );
                        }
                      }
                    },
                  ),
                ),
              ),

              // Explanation (if answered)
              if (currentQuestion.isAnswered()) ...[
                const SizedBox(height: 20),
                PremiumCard(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: currentQuestion.isAnsweredCorrectly()
                      ? AppColors.successGreen.withOpacity(0.1)
                      : AppColors.errorRed.withOpacity(0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            currentQuestion.isAnsweredCorrectly()
                                ? Icons.check_circle
                                : Icons.close_circle,
                            color: currentQuestion.isAnsweredCorrectly()
                                ? AppColors.successGreen
                                : AppColors.errorRed,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            currentQuestion.isAnsweredCorrectly()
                                ? AppStrings.correct
                                : AppStrings.incorrect,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (currentQuestion.explanation != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          AppStrings.explanation,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentQuestion.explanation!,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Next Button
              if (currentQuestion.isAnswered())
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(currentMCQIndexProvider.notifier).state =
                          currentIndex + 1;
                    },
                    child: Text(
                      currentIndex == questions.length - 1
                          ? AppStrings.submit
                          : AppStrings.next,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectSelector() {
    return Column(
      children: [
        DropdownButton<String>(
          isExpanded: true,
          value: _selectedSubject,
          hint: const Text(AppStrings.selectSubject),
          items: AppStrings.subjects.map((subject) {
            return DropdownMenuItem(
              value: subject,
              child: Text(subject),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSubject = value;
              _showChapterSelection = true;
              _selectedChapter = null;
            });
          },
        ),
        if (_showChapterSelection && _selectedSubject != null) ...[
          const SizedBox(height: 16),
          DropdownButton<String>(
            isExpanded: true,
            value: _selectedChapter,
            hint: const Text(AppStrings.selectChapter),
            items: [
              'Chapter 1',
              'Chapter 2',
              'Chapter 3',
            ].map((chapter) {
              return DropdownMenuItem(
                value: chapter,
                child: Text(chapter),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedChapter = value;
                _generateSampleMCQs();
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildResultsScreen(List<MCQQuestion> questions) {
    _correctAnswers =
        questions.where((q) => q.isAnsweredCorrectly()).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.results),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Score Card
              PremiumCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      AppStrings.score,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_correctAnswers}/${questions.length}',
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${((_correctAnswers / questions.length) * 100).toStringAsFixed(1)}% Accuracy',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.successGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats
              Row(
                children: [
                  Expanded(
                    child: PremiumCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.successGreen,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_correctAnswers',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppStrings.correctAnswers,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
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
                          Icon(
                            Icons.close_circle,
                            color: AppColors.errorRed,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${questions.length - _correctAnswers}',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            AppStrings.wrongAnswers,
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(currentMCQIndexProvider.notifier).state = 0;
                    ref.read(mcqQuestionsProvider.notifier).clearQuestions();
                    Navigator.pop(context);
                  },
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.successGreen;
      case 'hard':
        return AppColors.errorRed;
      default:
        return AppColors.warningYellow;
    }
  }
}
