import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//http://195.10.205.87:8000/posts/?title=
String _urlTitle(String title) {
    if(title != "") {
      return "title=$title";
    }
    else {
      return "";
    }
}

//http://195.10.205.87:8000/posts/?tags=parenting&tags=hints
String _urlTags(List<String> tags) {
  String addUrl = "?";
  if(tags != []) {
    for(int i = 0; i < tags.length; i++) {
      String addTag = tags[i];
      addUrl += "tags=$addTag";
      if(i+1 < tags.length) {
        addUrl += "&";
      }
    }
    return addUrl;
  }
  else {
    return "";
  }
}

Future<List<dynamic>> getPosts(String title, List<String> tags) async {
  print("Ищется посты по заголовку: $title");
  print("И тегам: $tags");
  if((title == null || title.isEmpty) && (tags == null || tags.isEmpty)) {
    try {
      final response = await http.get(
          Uri.parse('http://195.10.205.87:8000/api/v1/postlist/'));

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
  else {
    //http://195.10.205.87:8000/posts/?tags=parenting&tags=hints&title= ЕСЛИ ЕСТЬ И ТЕГИ И title
    //http://195.10.205.87:8000/posts/?title= ЕСЛИ ЕСТЬ title
    //http://195.10.205.87:8000/posts/?tags=parenting&tags=hints ЕСЛИ ЕСТЬ ТЕГИ
    String customUrl = "http://195.10.205.87:8000/posts/";
    if((title == null || title.isEmpty) && (tags != null || !tags.isEmpty)) {
      customUrl += _urlTags(tags);
    }
    else if((title != null || !title.isEmpty) && (tags == null || tags.isEmpty)) {
      customUrl += "?";
      customUrl += _urlTitle(title);
    }
    else {
      customUrl += _urlTags(tags);
      customUrl += "&";
      customUrl += _urlTitle(title);
    }
    print("NEW URL: $customUrl");
    try {
      final response = await http.get(Uri.parse(customUrl));

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data is List) {
          return data; // Если data уже является списком
        } else if (data is Map<String, dynamic> && data.containsKey('posts')) {
          final postsData = data['posts'];

          if (postsData is List) {
            return postsData;
          } else {
            throw Exception('Посты не являются списком');
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

Future<List<dynamic>> getPostsByPostId(int idPost) async {
  try {
    var apiUrl = 'http://195.10.205.87:8000/user/profile_by_post/$idPost/';
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      if (data is Map<String, dynamic> && data.containsKey('posts')) {
        return data['posts'];
      } else {
        throw Exception('Некорректный формат данных');
      }
    } else {
      throw Exception('Ошибка: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Ошибка при загрузке постов по id_post: $e');
    throw Exception('Произошла ошибка при загрузке данных');
  }
}

Future<String> getUserName(int id_post) async {
  try {
    var response = await http.get(Uri.parse('http://195.10.205.87:8000/user/profile_by_post/$id_post/'));

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      if (data is Map<String, dynamic> && data.containsKey('user')) {
        var user = data['user'];
        if (user != null && user.containsKey('first_name')) {
          return user['first_name'];
        } else {
          throw Exception('Не найдено имя пользователя');
        }
      } else {
        throw Exception('Некорректный формат данных');
      }
    } else {
      throw Exception('Ошибка: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Ошибка фетча имени пользователя: $e');
    throw Exception('Произошла ошибка при загрузке данных');
  }
}

Future<String> getUserSurname(int id_post) async {
  try {
    var response = await http.get(Uri.parse('http://195.10.205.87:8000/user/profile_by_post/$id_post/'));

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      if (data is Map<String, dynamic> && data.containsKey('user')) {
        var user = data['user'];
        if (user != null && user.containsKey('last_name')) {
          return user['last_name'];
        } else {
          throw Exception('Не найдено имя пользователя');
        }
      } else {
        throw Exception('Некорректный формат данных');
      }
    } else {
      throw Exception('Ошибка: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Ошибка фетча имени пользователя: $e');
    throw Exception('Произошла ошибка при загрузке данных');
  }
}

Future<String> getUserAvatarUrl(int id_post) async {
  try {
    var response = await http.get(Uri.parse('http://195.10.205.87:8000/user/profile_by_post/$id_post/'));

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      if (data is Map<String, dynamic>) {
        return data['avatar'];
      } else {
        throw Exception('Некорректный формат данных');
      }
    } else {
      throw Exception('Ошибка: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Ошибка фетча имени пользователя: $e');
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

Future<Map<String, dynamic>> getUserByToken() async {
  final token = await getAccessToken();

  if (token == null) {
    throw Exception('No access token found');
  }

  final url = 'http://195.10.205.87:8000/get-user-id/';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load user data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load user data. Error: $e');
  }
}

Future<int> returnUserIndex() async {
  try {
    Map<String, dynamic> userData = await getUserByToken();
    return userData['user_id'];
  } catch (e) {
    print('Error: $e');
    return 0;
  }
}

Future<String> returnFirstName() async {
  try {
    Map<String, dynamic> userData = await getUserByToken();
    return userData['first_name'];
  } catch (e) {
    print('Error: $e');
    return "";
  }
}

Future<String> returnLastName() async {
  try {
    Map<String, dynamic> userData = await getUserByToken();
    return userData['last_name'];
  } catch (e) {
    print('Error: $e');
    return "";
  }
}

Future<String> returnUserName() async {
  try{
    Map<String, dynamic> userData = await getUserByToken();
    return userData['user'];
  } catch (e){
    print('Error: $e');
    return "";
  }
}

Future<String> getAvatarUrl() async {
  try{
    Map<String, dynamic> userData = await getUserByToken();
    return userData['avatar'];
  } catch(e){
    throw Exception('Ошибка загрузки аватара');
  }
}

Future<String> getUserPostTitle(int num) async {
  try {
    Map<String, dynamic> userData = await getUserByToken();
    List<dynamic> posts = userData['posts'];

    return posts[num]['title'];
  } catch (e) {
    throw Exception('Failed to load posts: $e');
  }
}

Future<String> getUserPostContent(int num) async {
  try {
    Map<String, dynamic> userData = await getUserByToken();
    List<dynamic> posts = userData['posts'];

    return posts[num]['content'];
  } catch (e) {
    throw Exception('Failed to load posts: $e');
  }
}

Future<List<dynamic>> getUserPostTagsWithToken(int num) async {
  try {
    Map<String, dynamic> userData = await getUserByToken();
    List<dynamic> posts = userData['posts'];

    if (num >= 0 && num < posts.length) {
      List<dynamic> tags = posts[num]['tags'];
      return tags;
    } else {
      return [];
    }
  } catch (e) {
    throw Exception('Failed to load posts: $e');
  }
}

Future<List<dynamic>> getUserPostTags(dynamic posts) async {
  try {
    return posts['tags'];
  } catch (e) {
    throw Exception('Failed to load posts: $e');
  }
}


Future<bool> passwordResetRequest(String userName, String secretWord) async{
  final url = Uri.parse('http://195.10.205.87:8000/password_reset_request/');
  final body = jsonEncode({
    "username": userName,
    "secret_word": secretWord
  });
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );
  if (response.statusCode == 200){
    return true;
  }
  else{
    return false;
  }
}
Future<bool> passwordReset(String userName, String secretWord, String newPassword, String confirmNewPassword) async{
  bool canChangePassword = await passwordResetRequest(userName, secretWord);
  final url = Uri.parse('http://195.10.205.87:8000/password_foggot/');
  final body = jsonEncode({
    "username": userName,
    "new_password": newPassword,
    "confirm_password": confirmNewPassword
  });
  if (canChangePassword == true){
    print('OKOKOKdadadadasdasdadasdadadadasdasdada');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200){
      print('dadadadadasdfasfafafasfas');
      return true;
    }
  }
  return false;
}

Future<bool> isUserPostOwner(int id_user) async {
  try {
    Map<String, dynamic> userData = await getUserByToken();
    if(userData['user_id'] == id_user || userData['admin']) {
      return true;
    }
    else {
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

Future<bool> isUserAdmin(int id_user) async {
  try {
    Map<String, dynamic> userData = await getUserByToken();
    if(userData['user_id'] != id_user && userData['admin']) {
      return true;
    }
    else {
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

Future<void> addPost(int id, int user_id, String title, String content, List<String> tags) async {
  final apiUrl = "http://195.10.205.87:8000/api/v1/postlist/";
  final token = await getAccessToken();

  List<String> tagStrings = List.from(tags);

  Map<String, dynamic> postData = {
    'id': id,
    'user': user_id,
    'title': title,
    'content': content,
    'tags': tagStrings,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(postData),
    );

    if (response.statusCode == 200) {
      print('Post updated successfully');
    } else {
      print('Failed to update post: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error sending request: $e');
  }
}

Future<void> deletePost(int postId) async {
  final apiUrl = "http://195.10.205.87:8000/api/v1/postlist/$postId";
  final token = await getAccessToken();

  try {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      print('Post deleted successfully');
    } else {
      print('Failed to delete post: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error deleting post: $e');
  }
}

Future<void> deleteUser(int userId) async {
  final apiUrl = 'http://195.10.205.87:8000/delete_user/$userId/';
  final token = await getAccessToken();

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      print('Пользователь с ID $userId успешно удален');
    } else {
      print('Ошибка при удалении пользователя с ID $userId: ${response.statusCode}');
      print('Тело ответа: ${response.body}');
    }
  } catch (e) {
    print('Ошибка при удалении пользователя с ID $userId: $e');
  }
}