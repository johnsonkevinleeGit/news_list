import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchField extends ConsumerWidget {
  const SearchField({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = ref.watch(providerOfSearchController);

    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search',
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () => searchController.clear(),
                  icon: const Icon(Icons.close))
              : const SizedBox()),
      controller: searchController,
    );
  }
}

final providerOfSearchController =
    ChangeNotifierProvider((ref) => TextEditingController());
