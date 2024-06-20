import 'package:flutter/material.dart';
import '../Categorys/CategorysPage.dart';
import '../Home/HomePage.dart';
import '../Publications/PublicationPage.dart';
import '../Publications/NewPublicationPage.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:PHelperPro/djangoRequest.dart';
import 'package:PHelperPro/enumCategorys.dart';

class ProfileOtherPage extends StatefulWidget {
  final int id;
  final String avatarUrl;
  final String firstName;
  final String lastName;
  final List<dynamic> posts;

  ProfileOtherPage({
    required this.id,
    required this.avatarUrl,
    required this.firstName,
    required this.lastName,
    required this.posts,
  });

  @override
  _ProfileOtherPageState createState() => _ProfileOtherPageState();
}

class _ProfileOtherPageState extends State<ProfileOtherPage> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    try {
      bool isAdmin = await isUserPostOwner(widget.id);
      setState(() {
        _isAdmin = isAdmin;
      });
    } catch (e) {
      print('Failed to check admin status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 222, 154, 87),
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: widget.avatarUrl.isNotEmpty
                    ? Image.network(
                  widget.avatarUrl,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/background.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${widget.firstName} ${widget.lastName}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _isAdmin
                ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                _showDeleteConfirmationDialog();
              },
              child: Text('Заблокировать пользователя'),
            )
                : SizedBox.shrink(),
            SizedBox(height: 20),
            Expanded(
              child: _buildPostsList(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 222, 154, 87),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: '',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            AppMetrica.reportEvent('toHomePage');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (index == 1) {
            AppMetrica.reportEvent('toCategorysPage');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CategorysPage()),
            );
          }
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }

  Widget _buildPostsList() {
    if (widget.posts.isEmpty) {
      return Center(child: Text('Постов нет :('));
    } else {
      return ListView.builder(
        itemCount: widget.posts.length,
        itemBuilder: (context, index) {
          return _buildPostCard(widget.posts[index]);
        },
      );
    }
  }

  Widget _buildPostCard(dynamic post) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PublicationPage(
              avatarUrl: widget.avatarUrl,
              userName: widget.firstName,
              userSurname: widget.lastName,
              postTitle: post['title'] ?? '',
              postContent: post['content'] ?? '',
              id: post['id'] ?? '',
              user: post['user'] ?? '',
              posts: widget.posts,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Colors.grey[200],
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                post['title'] ?? 'No Title',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                color: Colors.grey[300],
                child: Text(
                  _truncateContent(post['content'] ?? 'No Content'),
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 12),
              FutureBuilder<List<dynamic>>(
                future: getUserPostTags(post['id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Failed to load tags: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<dynamic> tags = snapshot.data!;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: tags.asMap().entries.map((entry) {
                        int idx = entry.key;
                        dynamic tag = entry.value;
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            '${translateCategoryByText(tag.toString())}${idx != tags.length - 1 ? ',' : ''}',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Text('No tags available');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _truncateContent(String content) {
    const int maxLength = 200;
    if (content.length <= maxLength) {
      return content;
    } else {
      return content.substring(0, maxLength) + '...';
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Подтверждение удаления.'),
          content:
          Text('Вы уверены что хотите удалить пользователя ${widget.firstName} ${widget.lastName}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Нет'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Да'),
              onPressed: () async {
                try {
                  await deleteUser(widget.id);
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategorysPage(),
                      settings: RouteSettings(
                        arguments:
                        'Пользователь ${widget.firstName} ${widget.lastName} удален',
                      ),
                    ),
                  );
                } catch (e) {
                  print('Failed to delete user: $e');
                  // Handle error if necessary
                }
              },
            ),
          ],
        );
      },
    );
  }
}
