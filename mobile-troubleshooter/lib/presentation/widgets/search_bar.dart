import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import '../../core/localization/app_localizations.dart';
import '../providers/article_providers.dart';

class SearchBarWidget extends ConsumerStatefulWidget {
  const SearchBarWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
  final _textController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Sync the text controller with the state provider if needed
    _textController.text = ref.read(searchQueryProvider);
  }

  @override
  void dispose() {
    _textController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchQueryProvider.notifier).state = query;
      if (query.isNotEmpty) {
        ref.read(analyticsServiceProvider).logSearch(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TextField(
      controller: _textController,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: l10n.translate('search'),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _textController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _textController.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
      ),
    );
  }
}
