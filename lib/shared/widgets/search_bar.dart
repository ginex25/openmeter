import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openmeter/shared/provider/is_searching.dart';

class SearchAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;
  final Function(String searchText)? onSearch;

  const SearchAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    required this.onSearch,
  });

  @override
  ConsumerState<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchAppBarState extends ConsumerState<SearchAppBar> with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();

  void _startSearch() {
    ref.read(isSearchingProvider.notifier).setState(true);

    setState(() {});
  }

  void _stopSearch() {
    _textController.clear();
    widget.onSearch?.call('');
    ref.read(isSearchingProvider.notifier).setState(false);
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = ref.watch(isSearchingProvider);

    return AppBar(
      title: isSearching
          ? SizedBox(
              height: 50,
              child: SearchBar(
                controller: _textController,
                autoFocus: true,
                hintText: 'Suchen',
                onChanged: (value) {
                  setState(() {});

                  widget.onSearch?.call(value);
                },
                leading: IconButton(
                  onPressed: () {
                    _stopSearch();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                trailing: _textController.text.isNotEmpty
                    ? {
                        IconButton(
                          iconSize: 20,
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _textController.clear();
                            widget.onSearch?.call('');
                            setState(() {});
                          },
                        ),
                      }
                    : null,
              ),
            )
          : Text(widget.title),
      actions: isSearching
          ? null
          : [
              IconButton(
                onPressed: () {
                  _startSearch();
                },
                icon: const Icon(Icons.search),
              ),
              ...widget.actions,
            ],
    );
  }
}
