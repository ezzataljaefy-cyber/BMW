import '../entities/chat_message.dart';

abstract class ChatRepository {
  Stream<String> postChatMessage({
    required String message,
    bool includeDeviceInfo,
    bool includeArticleContext,
    // In a real app, you might pass an articleId or other context
  });
}
