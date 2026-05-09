import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/app_constants.dart';
import '../models/chat_message.dart';

class GeminiAIService {
  final Dio _dio;
  final Logger _logger = Logger();

  GeminiAIService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: AppConstants.geminiApiBaseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
            ));

  Future<String> askQuestion({
    required String question,
    required String subject,
    String? conversationHistory,
  }) async {
    try {
      _logger.i('Asking AI: $question | Subject: $subject');

      final prompt = conversationHistory != null
          ? '$conversationHistory\n\nStudent: $question'
          : question;

      final response = await _dio.post(
        '${AppConstants.geminiModelName}:generateContent',
        queryParameters: {
          'key': AppConstants.geminiApiKey,
        },
        data: {
          'contents': [
            {
              'role': 'user',
              'parts': [
                {
                  'text': '''${ AppConstants.aiSystemPrompt}

Subject: $subject

Question: $prompt

Please provide a clear, exam-focused answer in appropriate language (Bangla or English based on the question).'''
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        },
      );

      if (response.statusCode == 200) {
        final text = response.data['candidates'][0]['content']['parts'][0]['text'];
        _logger.i('AI Response received');
        return text;
      } else {
        throw Exception('Failed to get AI response');
      }
    } on DioException catch (e) {
      _logger.e('DioException in askQuestion: $e');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      _logger.e('Error in askQuestion: $e');
      throw Exception('Error: $e');
    }
  }

  Future<String> generateCQAnswer({
    required String question,
    required String subject,
  }) async {
    try {
      _logger.i('Generating CQ answer for: $question');

      final response = await _dio.post(
        '${AppConstants.geminiModelName}:generateContent',
        queryParameters: {
          'key': AppConstants.geminiApiKey,
        },
        data: {
          'contents': [
            {
              'role': 'user',
              'parts': [
                {
                  'text': '''${AppConstants.aiSystemPrompt}

Subject: $subject

Please generate a CQ (Creative Question) answer for the following question. Provide:

1. SHORT ANSWER (1-2 sentences)
2. FULL BOARD EXAM ANSWER (3-4 paragraphs with proper structure)
3. KEY POINTS (5-7 bullet points)

Question: $question

Format your response with clear sections marked as [SHORT ANSWER], [FULL ANSWER], and [KEY POINTS].'''
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 2048,
          }
        },
      );

      if (response.statusCode == 200) {
        final text = response.data['candidates'][0]['content']['parts'][0]['text'];
        _logger.i('CQ Answer generated');
        return text;
      } else {
        throw Exception('Failed to generate CQ answer');
      }
    } on DioException catch (e) {
      _logger.e('DioException in generateCQAnswer: $e');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      _logger.e('Error in generateCQAnswer: $e');
      throw Exception('Error: $e');
    }
  }

  Future<String> getMCQExplanation({
    required String question,
    required List<String> options,
    required int correctAnswerIndex,
    required String subject,
  }) async {
    try {
      _logger.i('Getting MCQ explanation for subject: $subject');

      final optionsText = options.asMap().entries.map((e) {
        return '${String.fromCharCode(65 + e.key)}) ${e.value}${e.key == correctAnswerIndex ? ' (Correct)' : ''}';
      }).join('\n');

      final response = await _dio.post(
        '${AppConstants.geminiModelName}:generateContent',
        queryParameters: {
          'key': AppConstants.geminiApiKey,
        },
        data: {
          'contents': [
            {
              'role': 'user',
              'parts': [
                {
                  'text': '''${AppConstants.aiSystemPrompt}

Subject: $subject

Please provide a brief explanation for this MCQ question:

Question: $question

Options:
$optionsText

Explain why the correct answer is correct and why others might be wrong. Keep it concise.'''
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.5,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 512,
          }
        },
      );

      if (response.statusCode == 200) {
        final text = response.data['candidates'][0]['content']['parts'][0]['text'];
        _logger.i('MCQ explanation generated');
        return text;
      } else {
        throw Exception('Failed to get explanation');
      }
    } on DioException catch (e) {
      _logger.e('DioException in getMCQExplanation: $e');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      _logger.e('Error in getMCQExplanation: $e');
      throw Exception('Error: $e');
    }
  }

  Future<String> generateStudyTips({
    required String subject,
    required String chapter,
  }) async {
    try {
      _logger.i('Generating study tips for: $subject - $chapter');

      final response = await _dio.post(
        '${AppConstants.geminiModelName}:generateContent',
        queryParameters: {
          'key': AppConstants.geminiApiKey,
        },
        data: {
          'contents': [
            {
              'role': 'user',
              'parts': [
                {
                  'text': '''${AppConstants.aiSystemPrompt}

Subject: $subject
Chapter: $chapter

Please provide 5 key study tips for this chapter that will help with HSC exam preparation. 
Format as numbered list with brief, actionable tips.'''
                }
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 512,
          }
        },
      );

      if (response.statusCode == 200) {
        final text = response.data['candidates'][0]['content']['parts'][0]['text'];
        _logger.i('Study tips generated');
        return text;
      } else {
        throw Exception('Failed to generate study tips');
      }
    } on DioException catch (e) {
      _logger.e('DioException in generateStudyTips: $e');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      _logger.e('Error in generateStudyTips: $e');
      throw Exception('Error: $e');
    }
  }
}
