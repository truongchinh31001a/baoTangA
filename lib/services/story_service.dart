import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/story.dart';

class StoryService {
  static const baseUrl = 'http://192.168.1.197:3000/api';

  static Future<List<Story>> fetchStories() async {
    final res = await http.get(Uri.parse('$baseUrl/stories'));
    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((json) => Story.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch stories');
    }
  }

  static Future<Story> fetchStoryDetail(String storyId) async {
    final res = await http.get(Uri.parse('$baseUrl/stories/$storyId'));
    if (res.statusCode == 200) {
      return Story.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to fetch story detail');
    }
  }
}
