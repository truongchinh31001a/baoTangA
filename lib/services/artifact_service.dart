import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artifact.dart';

class ArtifactService {
  static const baseUrl = 'http://192.168.1.197:3000/api';

  static Future<Artifact> fetchArtifact(String artifactId, String lang) async {
    final url = '$baseUrl/artifacts/$artifactId?lang=$lang';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return Artifact.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to load artifact');
    }
  }
}
