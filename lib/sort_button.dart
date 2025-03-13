import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SortButton extends ConsumerWidget {
  const SortButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortIsOn = ref.watch(sortProvider);

    return IconButton(
      color: sortIsOn ? Colors.blue : Colors.grey,
      onPressed: () {
        ref.read(sortProvider.notifier).state = !sortIsOn;
      },
      icon: const Icon(Icons.sort),
    );
  }
}

final sortProvider = StateProvider((ref) => false);
