import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:news_list/end_drawer.dart';
import 'package:news_list/l10n/app_localizations.dart';
import 'package:news_list/locale_state.dart';
import 'package:news_list/sort_button.dart';
import 'package:news_list/story_list.dart';
import 'package:news_list/search_field.dart';
import 'package:news_list/story_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'story_model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(providerOfLocale);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      locale: locale,
      supportedLocales: SupportedLocales.all,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: Builder(builder: (context) {
        return MyHomePage(title: AppLocalizations.of(context)!.news);
      }),
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
              appBar: AppBar(
                backgroundColor: Colors.blueGrey,
                title: Text(title, style: const TextStyle(color: Colors.white)),
                centerTitle: true,
                actions: [
                  Builder(builder: (context) {
                    return IconButton(
                        color: Colors.white,
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: const Icon(Icons.menu_outlined));
                  })
                ],
              ),
              endDrawer: const MyEndDrawer(),
              body: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(children: [
                    const Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                          child: SearchField()),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(5, 15, 15, 15),
                        child: Tooltip(
                            message: AppLocalizations.of(context)!.sort,
                            child: const SortButton()))
                  ]),
                  const Expanded(child: StoryList()),
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
