import 'package:flutter/material.dart';
import 'package:PHelperPro/djangoRequest.dart';

class PublicationPage extends StatelessWidget {
  final String userName;
  final String userSurname;
  final String postTitle;
  final String postContent;
  final int user;

  const PublicationPage({
    super.key,
    required this.userName,
    required this.userSurname,
    required this.postTitle,
    required this.postContent,
    required this.user,
  });

  Future<void> _deletePost(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Функция удаления поста пока недоступна'),
    ));
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
            Text(
              '$userName $userSurname',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        backgroundColor: Colors.red, // Красная кнопка
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () => _deletePost(context),
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
