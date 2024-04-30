import 'package:http/http.dart' as http;
import 'dart:convert';

Future<int> getPostId() async {
  var response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/postlist/'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.containsKey('posts') && data['posts'].length >= 2) {
      Map<String, dynamic> post = data['posts'][2]; // Получаем второй пост из списка
      int postId = post['id']; // Извлекаем id второго поста
      return postId;
    } else {
      throw Exception('There are less than 2 posts in the list');
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

Future<int> getPostUserId(int id_post) async {
  var response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/postlist/'));

  if (response.statusCode == 200) {
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.containsKey('posts')) {
      Map<int, dynamic> post = data['posts'][id_post];
      return post['id_user'];
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
    Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    if (data.containsKey('users')) {
      Map<String, dynamic> user = data['users'][id_user];
      return user['name'];
    }
    else
    {
      throw Exception('Не найдены пользователи...');
    }
  } else {
    throw Exception('Произошла ошибка при загрузке данных');
  }
}
