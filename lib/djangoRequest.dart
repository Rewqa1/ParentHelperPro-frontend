import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../enumCategorys.dart';

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