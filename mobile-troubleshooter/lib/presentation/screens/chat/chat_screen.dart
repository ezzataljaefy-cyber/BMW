import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_localizations.dart';
import '../../providers/chat_providers.dart';
import '../../widgets/message_bubble.dart'; // To be created
import '../../widgets/message_input_field.dart'; // To be created

class ChatScreen extends ConsumerWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatMessagesProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('aiChat')),
      ),
      body: Column(
        children: [
          // Context Toggles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ContextToggle(
                  label: l10n.translate('includeDeviceInfo'),
                  provider: includeDeviceInfoProvider,
                ),
                _ContextToggle(
                  label: l10n.translate('includeArticleContext'),
                  provider: includeArticleContextProvider,
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Message List
          Expanded(
            child: ListView.builder(
              reverse: true, // To show latest messages at the bottom
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return MessageBubble(message: message);
              },
            ),
          ),

          // Message Input Field
          const MessageInputField(),
        ],
      ),
    );
  }
}

class _ContextToggle extends ConsumerWidget {
  final String label;
  final StateProvider<bool> provider;

  const _ContextToggle({required this.label, required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            ref.read(provider.notifier).state = newValue ?? false;
          },
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
