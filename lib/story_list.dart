import 'package:flutter/material.dart';
import 'package:news_list/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_list/search_field.dart';
import 'package:url_launcher/url_launcher.dart';

import 'story_model.dart';

class StoryList extends ConsumerWidget {
  const StoryList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredStories = ref.watch(providerOfFilteredStories);

    return RefreshIndicator(
      onRefresh: () async {
        return ref.refresh(providerOfGetTopStories);
      },
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: filteredStories?.length,
          itemBuilder: (context, i) {
            final story = filteredStories?[i];
            return InkWell(
              onTap: () async {
                final url = Uri.parse(story?.url ?? '');
                if (await canLaunchUrl(url)) {
                  launchUrl(url);
                }
              },
              child: Card(
                  child: ListTile(
                dense: true,
                title: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(story?.title ?? '',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              )),
            );
          }),
    );
  }
}

final providerOfFilteredStories = StateProvider<List<Story?>?>((ref) {
  final stories = ref.watch(providerOfStories);
  final searchController = ref.watch(providerOfSearchController);
  final searchText = searchController.text.trim().toLowerCase();
  final filteredStories = stories
      ?.where((element) =>
          (element?.title ?? '').toLowerCase().contains(searchText))
      .toList();
  // Add to a sort button
  // filteredStories?.sort((a, b) =>
  //     (a?.title ?? '').toLowerCase().compareTo((b?.title ?? '').toLowerCase()));
  return filteredStories;
}, dependencies: [providerOfStories]);
