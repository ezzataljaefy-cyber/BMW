import 'dart:convert';
import 'package:dio/dio.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final Dio _dio;

  // In a real app, the base URL would come from an environment variable
  ChatRepositoryImpl({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000/api'));
  // Note: 10.0.2.2 is the standard address for the host machine's localhost from the Android emulator.

  @override
  Stream<String> postChatMessage({
    required String message,
    bool includeDeviceInfo = false,
    bool includeArticleContext = false,
  }) {
    final controller = StreamController<String>();

    _dio.post(
      '/ai/chat',
      data: {
        'message': message,
        'includeDeviceInfo': includeDeviceInfo,
        'includeArticleContext': includeArticleContext,
      },
      options: Options(
        responseType: ResponseType.stream, // Important for SSE
      ),
    ).then((response) {
      response.data.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) {
            if (line.startsWith('data:')) {
              final jsonString = line.substring(5);
              final jsonData = json.decode(jsonString);
              if (jsonData['event'] == 'done') {
                controller.close();
              } else if (jsonData['token'] != null) {
                controller.add(jsonData['token']);
              }
            }
          },
          onDone: () => controller.close(),
          onError: (error) => controller.addError(error),
        );
    }).catchError((error) {
      controller.addError(error);
    });

    return controller.stream;
  }
}
