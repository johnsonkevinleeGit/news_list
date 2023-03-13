import 'package:flutter/material.dart';
import 'package:news_list/story_list.dart';
import 'package:news_list/search_field.dart';
import 'package:news_list/story_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'story_model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'Hacker News Top Stories'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getStories = ref.watch(providerOfGetTopStories);
    return getStories.when(
      data: (storyList) {
        return ProviderScope(
            overrides: [providerOfStories.overrideWith((ref) => storyList)],
            child: Scaffold(
              appBar: AppBar(title: Text(title)),
              body: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: SearchField(),
                  ),
                  Expanded(child: StoryList()),
                ],
              )),
            ));
      },
      error: (error, stackTrace) =>
          const Text('There was an error loading data.'),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

final providerOfStories = StateProvider<List<Story?>?>((ref) => <Story>[]);

final providerOfGetTopStories = FutureProvider((ref) async {
  final service = ref.watch(providerOfStoryAPIService);
  return await service.getStoryList();
});
