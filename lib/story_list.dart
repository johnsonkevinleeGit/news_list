import 'package:flutter/material.dart';
import 'package:news_list/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_list/search_field.dart';
import 'package:news_list/sort_button.dart';
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
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
          itemCount: filteredStories?.length,
          itemBuilder: (context, i) {
            final story = filteredStories?[i];
            return Card(
              key: ValueKey(story),
                color: Colors.white60,
                child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () async {
                      final url = Uri.parse(story?.url ?? '');
                      if (await canLaunchUrl(url)) {
                        launchUrl(url);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(story?.title ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600)),
                          Text('${story?.score.toString() ?? ''} points by ${story?.by}')
                        ],
                      ),
                    )));
          }),
    );
  }
}

final providerOfFilteredStories = StateProvider<List<Story?>?>((ref) {
  final stories = ref.watch(providerOfStories);
  final searchController = ref.watch(providerOfSearchController);
  final sortIsOn = ref.watch(sortProvider);
  final searchText = searchController.text.trim().toLowerCase();
  final filteredStories = stories
      ?.where((element) =>
          (element?.title ?? '').toLowerCase().contains(searchText))
      .toList();
  if (sortIsOn) {
    filteredStories?.sort((a, b) =>
        //Exclude special characters from the sort
        (a?.title?.replaceAll(RegExp(r"[^\s\w]"), "") ?? '')
            .toLowerCase()
            .compareTo((b?.title?.replaceAll(RegExp(r"[^\s\w]"), "") ?? '')
                .toLowerCase()));
  }
  return filteredStories;
}, dependencies: [providerOfStories]);
