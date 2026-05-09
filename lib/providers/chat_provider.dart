import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../models/chat_message.dart';
import '../services/gemini_ai_service.dart';
import 'package:uuid/uuid.dart';

final geminiAIServiceProvider = Provider((ref) {
  return GeminiAIService();
});

// Chat messages provider
final chatMessagesProvider =
    StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier();
});

// Chat loading provider
final chatLoadingProvider = StateProvider<bool>((ref) => false);

// Current subject provider
final currentChatSubjectProvider = StateProvider<String>((ref) => 'General');

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  final Logger _logger = Logger();

  ChatNotifier() : super([]);

  Future<void> sendMessage(String content, String subject, GeminiAIService aiService) async {
    try {
      // Add user message
      final userMessage = ChatMessage(
        id: const Uuid().v4(),
        content: content,
        isUser: true,
        timestamp: DateTime.now(),
        subject: subject,
      );

      state = [...state, userMessage];
      _logger.d('User message added: $content');

      // Get AI response
      final conversationHistory = _buildConversationHistory();
      final aiResponse = await aiService.askQuestion(
        question: content,
        subject: subject,
        conversationHistory: conversationHistory.isEmpty ? null : conversationHistory,
      );

      // Add AI message
      final aiMessage = ChatMessage(
        id: const Uuid().v4(),
        content: aiResponse,
        isUser: false,
        timestamp: DateTime.now(),
        subject: subject,
      );

      state = [...state, aiMessage];
      _logger.d('AI message added');
    } catch (e) {
      _logger.e('Error sending message: $e');
      // Add error message
      final errorMessage = ChatMessage(
        id: const Uuid().v4(),
        content: 'Sorry, I encountered an error. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
        subject: subject,
      );
      state = [...state, errorMessage];
    }
  }

  void clearMessages() {
    state = [];
    _logger.d('Chat messages cleared');
  }

  String _buildConversationHistory() {
    return state.map((msg) {
      return msg.isUser ? 'Student: ${msg.content}' : 'AI: ${msg.content}';
    }).join('\n');
  }

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }
}
