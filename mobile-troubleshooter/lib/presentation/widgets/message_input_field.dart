import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/localization/app_localizations.dart';
import '../providers/chat_providers.dart';

class MessageInputField extends ConsumerStatefulWidget {
  const MessageInputField({Key? key}) : super(key: key);

  @override
  ConsumerState<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends ConsumerState<MessageInputField> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      ref.read(chatMessagesProvider.notifier).sendMessage(text);
      _textController.clear();
    }
  }

  Future<void> _uploadScreenshot() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // In a real app, you would upload this image to a server and get a URL,
      // then perhaps send that URL in the chat message.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Screenshot selected: ${image.name}. Upload not implemented.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      elevation: 5,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Screenshot upload button
              IconButton(
                icon: const Icon(Icons.add_a_photo_outlined),
                tooltip: l10n.translate('uploadScreenshot'),
                onPressed: _uploadScreenshot,
              ),
              // Text input field
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: l10n.translate('typeYourMessage'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              // Send button
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
