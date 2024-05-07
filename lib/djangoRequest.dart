import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>?> getPosts(int currentPage, int postsPerPage) async {
  try {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/postlist/?page=$currentPage&perPage=$postsPerPage'));

    if (response.statusCode == 200) {
      final dynamic data = json.decode(utf8.decode(response.bodyBytes));

      if (data is Map<String, dynamic> && data.containsKey('posts')) {
        final dynamic postsData = data['posts'];

        if (postsData is List<dynamic>) {
          return postsData;
        } else {
          throw Exception('Posts data is not a List');
        }
      } else {
        throw Exception('Posts data not found');
      }
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to fetch posts: $e');
  }
}

Future<int> getPostId(int numpost) async {
  var response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/postlist/'));

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
  var response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/postlist/'));

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
  var response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/postlist/'));

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
  var response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/postlist/'));

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
  var response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/postlist/'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.containsKey('posts')) {
      for(int i = 0; i < data['posts'].length; i++) {
        Map<int, dynamic> post = data['posts'][i];
        if(post['user_id'] == id_post) {
          return post['user_id'];
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
  var response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/userlist/'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        Map<String, dynamic> user = data[i];
        if (user['id'] == id_user) {
          return user['name'];
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
  var response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/userlist/'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.isNotEmpty) {
      for(int i = 0; i < data.length; i++) {
        Map<String, dynamic> user = data[i];
        if(user['id'] == id_user) {
          return user['surname'];
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