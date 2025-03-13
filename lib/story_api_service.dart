import 'dart:convert';
import 'package:news_list/story_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class StoryAPIService {
  Future<List<Story?>?> getStoryList() async {
    const listUrl =
        'https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty';
    final listResponse = await http.get(Uri.parse(listUrl));
    if (listResponse.statusCode == 200) {
      final contentList = jsonDecode(listResponse.body) as List<dynamic>;
      final idList = contentList.map((e) => e as int).toList();

      final responseList =
          await Future.wait([...idList.map((id) => getStory(id)).take(20)]);

      return responseList;
    }
    return null;
  }

  Future<Story?> getStory(int id) async {
    final url = Uri.parse(
        'https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(response.body);
      return Story.fromJson(decodedBody);
    }
    return null;
  }
}

final providerOfStoryAPIService = Provider((ref) => StoryAPIService());
