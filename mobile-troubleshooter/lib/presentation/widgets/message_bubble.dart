import 'package:flutter/material.dart';
import '../../domain/entities/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final theme = Theme.of(context);
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isUser ? theme.colorScheme.primary : theme.colorScheme.secondary.withOpacity(0.5);
    final textColor = isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSecondary;

    return Container(
      alignment: alignment,
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          message.text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
