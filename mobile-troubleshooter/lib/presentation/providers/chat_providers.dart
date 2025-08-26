import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

// Provider for the ChatRepository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl();
});

// This provider will manage the list of chat messages
final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
  return ChatMessagesNotifier(ref);
});

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  final Ref _ref;
  StreamSubscription? _chatSubscription;

  ChatMessagesNotifier(this._ref) : super([]);

  Future<void> sendMessage(String text) async {
    // Add the user's message to the list immediately
    final userMessage = ChatMessage(
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );
    state = [...state, userMessage];

    // Cancel any existing stream subscription
    await _chatSubscription?.cancel();

    // Add a placeholder for the bot's response
    final botMessagePlaceholder = ChatMessage(
      text: '...',
      sender: MessageSender.bot,
      timestamp: DateTime.now(),
    );
    state = [...state, botMessagePlaceholder];

    final repository = _ref.read(chatRepositoryProvider);
    final responseStream = repository.postChatMessage(message: text);

    String fullResponse = '';

    _chatSubscription = responseStream.listen(
      (token) {
        // Append the new token to the full response
        fullResponse += token;
        // Update the last message (the bot's placeholder) with the new text
        state = [
          ...state.sublist(0, state.length - 1),
          ChatMessage(
            text: fullResponse,
            sender: MessageSender.bot,
            timestamp: botMessagePlaceholder.timestamp,
          ),
        ];
      },
      onError: (error) {
        state = [
          ...state.sublist(0, state.length - 1),
          ChatMessage(
            text: 'Error: Could not connect to the AI assistant.',
            sender: MessageSender.bot,
            timestamp: botMessagePlaceholder.timestamp,
          ),
        ];
      },
      onDone: () {
        // The stream is done, do nothing more.
      },
    );
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    super.dispose();
  }
}

// Providers for the UI toggles
final includeDeviceInfoProvider = StateProvider<bool>((ref) => false);
final includeArticleContextProvider = StateProvider<bool>((ref) => false);
