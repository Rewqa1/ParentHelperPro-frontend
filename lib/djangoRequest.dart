import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> getPosts(int currentPage, int postsPerPage) async {
  try {
    final response = await http.get(Uri.parse('http://195.10.205.87:8000/api/v1/postlist/?page=$currentPage&perPage=$postsPerPage'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(utf8.decode(response.bodyBytes));

      if (data is Map<String, dynamic> && data.containsKey('posts')) {
        final dynamic postsData = data['posts'];

        if (postsData is List<dynamic>) {
          return postsData;
        } else {
          throw Exception('Посты не лист?');
        }
      } else {
        throw Exception('Посты не найдены');
      }
    } else {
      throw Exception('Ошибка загрузки постов ${response.statusCode}');
    }
  } catch (e) {
    print('Ошибка фетча постов $e');
    return [];
  }
}

Future<List<dynamic>> getPostTags(int postId) async {
  try {
    final response = await http.get(Uri.parse('http://195.10.205.87:8000/api/v1/postlist/$postId'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(utf8.decode(response.bodyBytes));

      if (data is Map<String, dynamic> && data.containsKey('tags')) {
        final List<dynamic> tags = data['tags'];
        return tags;
      } else {
        throw Exception('Теги исчезли...');
      }
    } else {
      throw Exception('Ошибка загрузки постов $postId: ${response.statusCode}');
    }
  } catch (e) {
    print('Ошибка фетча постов $postId: $e');
    return [];
  }
}

Future<int> getPostId(int numpost) async {
  var response = await http.get(Uri.parse('http://195.10.205.87:8000/api/v1/postlist/'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.containsKey('posts') && data['posts'].length >= numpost) {
      Map<String, dynamic> post = data['posts'][numpost];
      int postId = post['id'];
      return postId;
    } else {
      throw Exception('Не найден пост...');
    }
  } else {
    throw Exception('Произошла ошибка при загрузке данных');
  }
}

Future<int> getPostCount() async {
  var response = await http.get(Uri.parse('http://195.10.205.87:8000/api/v1/postlist/'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.containsKey('posts'))
    {
      return data['posts'].length;
    }
    else
    {
      throw Exception('Не найдены посты... че?');
    }
  } else {
    throw Exception('Произошла ошибка при загрузке данных');
  }
}

Future<String> getPostTitle(int id_post) async {
  var response = await http.get(Uri.parse('http://195.10.205.87:8000/api/v1/postlist/'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.containsKey('posts')) {
      var posts = data['posts'] as List<dynamic>;
      for (var post in posts) {
        if (post['id'] == id_post) {
          return post['title'];
        }
      }
      throw Exception('Не найден пост.');
    } else {
      throw Exception('Не найдены посты... че?');
    }
  } else {
    throw Exception('Произошла ошибка при загрузке данных');
  }
}

Future<String> getPostContent(int id_post) async {
  var response = await http.get(Uri.parse('http://195.10.205.87:8000/api/v1/postlist/'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.containsKey('posts')) {
      var posts = data['posts'] as List<dynamic>;
      for (var post in posts) {
        if (post['id'] == id_post) {
          return post['content'];
        }
      }
      throw Exception('Не найден пост.');
    } else {
      throw Exception('Не найдены посты... че?');
    }
  } else {
    throw Exception('Произошла ошибка при загрузке данных');
  }
}

Future<int> getPostUserId(int id_post) async {
  var response = await http.get(Uri.parse('http://195.10.205.87:8000/api/v1/postlist/'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.containsKey('posts')) {
      for(int i = 0; i < data['posts'].length; i++) {
        Map<int, dynamic> post = data['posts'][i];
        if(post['user'] == id_post) {
          return post['user'];
        }
      }
      throw Exception('Не найден пост.');
    }
    else
    {
      throw Exception('Не найдены посты... че?');
    }
  } else {
    throw Exception('Произошла ошибка при загрузке данных');
  }
}


Future<String> getUserName(int id_user) async {
  var response = await http.get(Uri.parse('http://195.10.205.87:8000/api/v1/userlist/'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        Map<String, dynamic> user = data[i];
        if (user['id'] == id_user) {
          return user['first_name'];
        }
      }
      throw Exception('Не найден пользователь');
    } else {
      throw Exception('Не найдены пользователи...');
    }
  } else {
    throw Exception('Произошла ошибка при загрузке данных');
  }
}

Future<String> getUserSurname(int id_user) async {
  var response = await http.get(Uri.parse('http://195.10.205.87:8000/api/v1/userlist/'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.isNotEmpty) {
      for(int i = 0; i < data.length; i++) {
        Map<String, dynamic> user = data[i];
        if(user['id'] == id_user) {
          return user['last_name'];
        }
      }
      throw Exception('Не найден пользователь');
    } else {
      throw Exception('Не найдены пользователи...');
    }
  } else {
    throw Exception('Произошла ошибка при загрузке данных');
  }
}








const String baseUrl = 'http://192.168.0.122:8000/api/v1/';

Future<void> saveTokens(String accessToken, String refreshToken) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('accessToken', accessToken);
  await prefs.setString('refreshToken', refreshToken);
}

Future<String?> getAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('accessToken');
}

Future<String?> getRefreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('refreshToken');
}

Future<void> refreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  final refreshToken = prefs.getString('refreshToken');

  if (refreshToken != null) {
    print('Refreshing token...');
    final response = await http.post(
      Uri.parse('http://195.10.205.87:8000/api/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      await saveTokens(responseData['access'], refreshToken);
      print('Token refreshed: ${responseData['access']}');
    } else {
      print('Failed to refresh token: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to refresh token');
    }
  } else {
    print('No refresh token found.');
    throw Exception('No refresh token found');
  }
}

Future<bool> verifyToken(String token) async {
  final url = Uri.parse('http://195.10.205.87:8000/api/token/verify/');
  print('Verifying token...');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'token': token}),
    );

    print('Verify token status: ${response.statusCode}');
    if (response.statusCode != 200) {
      print('Verify token response: ${response.body}');
    }
    return response.statusCode == 200;
  } catch (e) {
    print('Error verifying token: $e');
    return false;
  }
}