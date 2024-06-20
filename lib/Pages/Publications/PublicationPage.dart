import 'package:flutter/material.dart';
import 'package:PHelperPro/djangoRequest.dart';
import '../Categorys/CategorysPage.dart';
import '../Profile/ProfileOtherPage.dart';

class PublicationPage extends StatelessWidget {
  final String avatarUrl;
  final String userName;
  final String userSurname;
  final String postTitle;
  final String postContent;
  final int id;
  final int user;
  final List<dynamic> posts;

  const PublicationPage({
    Key? key,
    required this.avatarUrl,
    required this.userName,
    required this.userSurname,
    required this.postTitle,
    required this.postContent,
    required this.id,
    required this.user,
    required this.posts,
  }) : super(key: key);

  Future<void> _deletePost(BuildContext context) async {
    try {
      await deletePost(id); // Вызываем функцию удаления поста
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Пост удален',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategorysPage()), // Перенаправление на страницу категорий
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Не удалось удалить пост: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(postTitle),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 222, 154, 87),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileOtherPage(
                      avatarUrl: avatarUrl,
                      firstName: userName,
                      lastName: userSurname,
                      posts: posts,
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30, // Adjust as needed
                    backgroundImage: NetworkImage(avatarUrl),
                  ),
                  SizedBox(width: 16),
                  Text(
                    '$userName $userSurname',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Text(
                postContent,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<bool>(
              future: isUserPostOwner(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!) {
                  return Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () {
                        // Показываем диалоговое окно подтверждения удаления
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Вы уверены?'),
                            content: Text('Вы действительно хотите удалить этот пост?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () => _deletePost(context),
                                child: Text('Да'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        'Удалить пост',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
