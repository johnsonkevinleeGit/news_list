import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchField extends ConsumerWidget {
  const SearchField({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = ref.watch(providerOfSearchController);

    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: AppLocalizations.of(context)!.search,
          hintStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white),
          fillColor: Colors.white,
          prefixIconColor: Colors.white,
          suffixIcon: searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () => searchController.clear(),
                  icon: const Icon(Icons.close))
              : const SizedBox(),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white))),
      controller: searchController,
      style:
          Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
    );
  }
}

final providerOfSearchController =
    ChangeNotifierProvider((ref) => TextEditingController());
