import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:news_list/end_drawer.dart';
import 'package:news_list/locale_state.dart';
import 'package:news_list/story_list.dart';
import 'package:news_list/search_field.dart';
import 'package:news_list/story_api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'story_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
  MyHomePage({super.key, required this.title});

  final String title;

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getStories = ref.watch(providerOfGetTopStories);

    return FutureBuilder(
        future: hasConnection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final hasConnection = snapshot.data ?? false;

          if (hasConnection) {
            return getStories.when(
              data: (storyList) {
                for (final story in storyList ?? []) {
                  setStoryToCache(story);
                }
                return ProviderScope(overrides: [
                  providerOfStories.overrideWith((ref) => storyList)
                ], child: HomePageContent(title: title));
              },
              error: (error, stackTrace) =>
                  const Text('There was an error loading data.'),
              loading: () => const Center(child: CircularProgressIndicator()),
            );
          }

          final cachedStories = getStoriesFromCache();
          return ProviderScope(overrides: [
            providerOfStories.overrideWith((ref) => cachedStories)
          ], child: HomePageContent(title: title));
        });
  }

  Future<bool> hasConnection() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  setStoryToCache(Story story) async {
    final docRef = db
        .collection("stories")
        .withConverter(
          fromFirestore: Story.fromFirestore,
          toFirestore: (Story story, options) => story.toFirestore(),
        )
        .doc('${story.id}');
    await docRef.set(story);
  }

  List<Story> getStoriesFromCache() {
    final List<Story> storyList = [];
    db.collection("stories").get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          final story = docSnapshot.data() as Story;
          storyList.add(story);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return storyList;
  }

  Future<DocumentSnapshot<Story>> convertToStoryObject(
      QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot) async {
    final ref = db.collection("stories").doc(docSnapshot.id).withConverter(
          fromFirestore: Story.fromFirestore,
          toFirestore: (Story story, _) => story.toFirestore(),
        );
    final docSnap = await ref.get();
    // final story = docSnap.data();
    return docSnap;
  }
}

class HomePageContent extends ConsumerWidget {
  HomePageContent({super.key, required this.title});

  final String title;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(title),
        actions: [
          Builder(builder: (context) {
            return IconButton(
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
        children: const [
          Padding(padding: EdgeInsets.all(15), child: SearchField()),
          Expanded(child: StoryList()),
        ],
      )),
    );
  }
}

final providerOfStories = StateProvider<List<Story?>?>((ref) => <Story>[]);

final providerOfGetTopStories = FutureProvider((ref) async {
  final service = ref.watch(providerOfStoryAPIService);
  return await service.getStoryList();
});
