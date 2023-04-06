import 'dart:convert';
import 'package:news_list/story_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class StoryAPIService {
  StoryAPIService() {
    _log = Logger('StoryAPIService');
  }
  late Logger _log;

  Future<List<Story?>?> getStoryList() async {
    _log.info('Getting hacker news list');
    try {
      const listUrl =
          'https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty';

      final listResponse = await http.get(Uri.parse(listUrl));
      if (listResponse.statusCode == 200) {
        _log.info('Successfully received hacker news list');

        final contentList = jsonDecode(listResponse.body) as List<dynamic>;
        final idList = contentList.map((e) => e as int).toList();

        final responseList =
            await Future.wait([...idList.map((id) => getStory(id)).take(10)]);

        return responseList;
      }
    } catch (err) {
      _log.severe('Error getting hacker news list: $err');
      return null;
    }

    return null;
  }

  Future<Story?> getStory(int id) async {
    _log.info('Getting hacker story: $id');
    try {
      final url = Uri.parse(
          'https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        return Story.fromJson(decodedBody);
      }
    } catch (err) {
      _log.severe('Error getting hacker story: $id, Error: $err');
      return null;
    }

    return null;
  }
}

final providerOfStoryAPIService = Provider((ref) => StoryAPIService());
