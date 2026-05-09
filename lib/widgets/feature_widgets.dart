import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isLoading;

  const ChatBubble({
    Key? key,
    required this.message,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser
              ? AppColors.primaryLight
              : Theme.of(context).brightness == Brightness.dark
                  ? AppColors.cardDark
                  : AppColors.dividerLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment:
              message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isLoading)
              SizedBox(
                width: 24,
                height: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    3,
                    (index) => Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.white54,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              )
            else
              Text(
                message.content,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: message.isUser
                      ? Colors.white
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: GoogleFonts.inter(
                fontSize: 11,
                color: message.isUser ? Colors.white70 : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    if (now.day == dateTime.day &&
        now.month == dateTime.month &&
        now.year == dateTime.year) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}

class MCQOptionButton extends StatefulWidget {
  final String label;
  final String option;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback onTap;

  const MCQOptionButton({
    Key? key,
    required this.label,
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
  }) : super(key: key);

  @override
  State<MCQOptionButton> createState() => _MCQOptionButtonState();
}

class _MCQOptionButtonState extends State<MCQOptionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.95).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.transparent;
    Color borderColor = AppColors.dividerLight;

    if (widget.showResult) {
      if (widget.isCorrect) {
        backgroundColor = AppColors.successGreen.withOpacity(0.1);
        borderColor = AppColors.successGreen;
      } else if (widget.isSelected && !widget.isCorrect) {
        backgroundColor = AppColors.errorRed.withOpacity(0.1);
        borderColor = AppColors.errorRed;
      }
    } else if (widget.isSelected) {
      backgroundColor = AppColors.primaryLight.withOpacity(0.2);
      borderColor = AppColors.primaryLight;
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) {
          _animationController.forward();
        },
        onTapUp: (_) {
          _animationController.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          _animationController.reverse();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 2),
                  color: widget.isSelected ? borderColor : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    widget.label,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.isSelected ? Colors.white : borderColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.option,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (widget.showResult)
                Icon(
                  widget.isCorrect ? Icons.check_circle : Icons.close_circle,
                  color: widget.isCorrect
                      ? AppColors.successGreen
                      : AppColors.errorRed,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoutineTaskTile extends StatelessWidget {
  final String title;
  final String subject;
  final int duration;
  final bool isCompleted;
  final VoidCallback onTap;
  final VoidCallback onCompleteToggle;
  final VoidCallback? onDelete;

  const RoutineTaskTile({
    Key? key,
    required this.title,
    required this.subject,
    required this.duration,
    required this.isCompleted,
    required this.onTap,
    required this.onCompleteToggle,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: GestureDetector(
          onTap: onCompleteToggle,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    isCompleted ? AppColors.successGreen : AppColors.dividerLight,
                width: 2,
              ),
              color: isCompleted ? AppColors.successGreen : Colors.transparent,
            ),
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  )
                : null,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            decoration:
                isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              Icons.book,
              size: 14,
              color: AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 4),
            Text(subject),
            const SizedBox(width: 12),
            Icon(
              Icons.schedule,
              size: 14,
              color: AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 4),
            Text('$duration min'),
          ],
        ),
        trailing: onDelete != null
            ? GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.close),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}

class WeakTopicCard extends StatelessWidget {
  final String subject;
  final String chapter;
  final double accuracy;
  final int priority;
  final VoidCallback onTap;

  const WeakTopicCard({
    Key? key,
    required this.subject,
    required this.chapter,
    required this.accuracy,
    required this.priority,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color priorityColor;
    String priorityText;

    if (priority == 1) {
      priorityColor = AppColors.errorRed;
      priorityText = 'High Priority';
    } else if (priority <= 2) {
      priorityColor = AppColors.warningYellow;
      priorityText = 'Medium Priority';
    } else {
      priorityColor = AppColors.successGreen;
      priorityText = 'Low Priority';
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          chapter,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      priorityText,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: priorityColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: accuracy / 100,
                  minHeight: 6,
                  backgroundColor: AppColors.dividerLight.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    accuracy >= 70 ? AppColors.successGreen : AppColors.errorRed,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Accuracy: ${accuracy.toStringAsFixed(1)}%',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
