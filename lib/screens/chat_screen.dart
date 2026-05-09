import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/chat_provider.dart';
import '../widgets/feature_widgets.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final subject = ref.read(currentChatSubjectProvider);
    final aiService = ref.read(geminiAIServiceProvider);

    ref.read(chatLoadingProvider.notifier).state = true;
    ref.read(chatMessagesProvider.notifier).sendMessage(message, subject, aiService);

    _messageController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 2), () {
      ref.read(chatLoadingProvider.notifier).state = false;
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);
    final isLoading = ref.watch(chatLoadingProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.aiChat),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Subject Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: isDarkMode ? AppColors.cardDark : Colors.grey[100],
            child: DropdownButton<String>(
              value: ref.watch(currentChatSubjectProvider),
              items: AppStrings.subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(currentChatSubjectProvider.notifier).state = value;
                }
              },
              isExpanded: true,
              underline: const SizedBox(),
            ),
          ),
          // Messages
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      AppStrings.noMessages,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(
                        message: messages[index],
                        isLoading: isLoading && index == messages.length - 1 && !messages[index].isUser,
                      );
                    },
                  ),
          ),
          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDarkMode ? AppColors.dividerDark : AppColors.dividerLight,
                ),
              ),
            ),
            child: Row(
              children: [
                // Mic Button
                IconButton(
                  icon: const Icon(Icons.mic_outlined),
                  onPressed: () {
                    // TODO: Implement voice input
                  },
                ),
                // Text Input
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: AppStrings.askQuestion,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 8),
                // Send Button
                FloatingActionButton(
                  mini: true,
                  onPressed: isLoading ? null : _sendMessage,
                  child: isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
