import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../enumCategorys.dart';
import '../djangoRequest.dart';

Future<void> createPost(int id, int user, String title, String content, List<int> tags) async {
  final url = Uri.parse('http://192.168.0.106:8000/api/v1/postlist/');

  final headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  final body = jsonEncode({
    "id": id,
    "user": user,
    "title": title,
    "content": content,
    "tags": tags
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    print('Post created successfully');
  } else {
    print('Failed to create post: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
