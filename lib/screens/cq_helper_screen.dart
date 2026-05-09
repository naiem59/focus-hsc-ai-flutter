import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_strings.dart';
import '../providers/chat_provider.dart';
import '../widgets/custom_widgets.dart';

class CQHelperScreen extends ConsumerStatefulWidget {
  const CQHelperScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CQHelperScreen> createState() => _CQHelperScreenState();
}

class _CQHelperScreenState extends ConsumerState<CQHelperScreen> {
  late TextEditingController _questionController;
  String? _generatedAnswer;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _generateAnswer() async {
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a question')),
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final aiService = ref.read(geminiAIServiceProvider);
      final answer = await aiService.generateCQAnswer(
        question: question,
        subject: 'General',
      );

      setState(() {
        _generatedAnswer = answer;
        _isGenerating = false;
      });
    } catch (e) {
      setState(() => _isGenerating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.cqHelper),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question Input
            Text(
              AppStrings.enterQuestion,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _questionController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: AppStrings.enterQuestion,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 20),

            // Generate Button
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                label: AppStrings.generateAnswer,
                onPressed: _generateAnswer,
                isLoading: _isGenerating,
                isEnabled: !_isGenerating,
              ),
            ),
            const SizedBox(height: 24),

            // Generated Answer
            if (_generatedAnswer != null) ...[
              _buildAnswerSection(
                'Short Answer',
                'Write 1-2 sentences as a quick answer.',
              ),
              const SizedBox(height: 16),
              _buildAnswerSection(
                'Full Board Exam Answer',
                'Complete answer with proper structure (3-4 paragraphs).',
              ),
              const SizedBox(height: 16),
              _buildAnswerSection(
                'Key Points',
                'Main points to remember (5-7 bullets).',
              ),
            ] else if (!_isGenerating)
              Center(
                child: EmptyStateWidget(
                  icon: Icons.edit_outlined,
                  title: AppStrings.cqHelper,
                  message: 'Enter a CQ question and click generate to get AI-powered answers',
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerSection(String title, String hint) {
    return PremiumCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_outlined),
                    iconSize: 20,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    iconSize: 20,
                    onPressed: () {
                      // Share functionality
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This is a sample $title. The AI will generate a comprehensive answer based on your question.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
