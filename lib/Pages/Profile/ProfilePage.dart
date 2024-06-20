import 'package:flutter/material.dart';
import '../Categorys/CategorysPage.dart';
import '../Home/HomePage.dart';
import '../Publications/PublicationPage.dart';
import '../Settings/SettingsPage.dart';
import '../Publications/NewPublicationPage.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:PHelperPro/djangoRequest.dart';
import 'package:PHelperPro/enumCategorys.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<String> _firstNameFuture;
  late Future<String> _lastNameFuture;
  late String _avatarUrl;
  late Future<Map<String, dynamic>> _userDataFuture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchAvatar();
    
  }
  Future<void> _fetchAvatar() async {
    try{
      String url = await getAvatarUrl();
      setState(() {
        _avatarUrl = url;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _loadUserData() async {
    _firstNameFuture = returnFirstName();
    _lastNameFuture = returnLastName();
    _userDataFuture = getUserByToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваш профиль'),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 222, 154, 87),
        automaticallyImplyLeading: false, // убираем стрелку назад
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.settings),
            onPressed: () {
              AppMetrica.reportEvent('toSettingsPage');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(_avatarUrl),
                  ),
                  SizedBox(height: 20),
                  FutureBuilder<String>(
                    future: _firstNameFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        String firstName = snapshot.data!;
                        return FutureBuilder<String>(
                          future: _lastNameFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              String lastName = snapshot.data!;
                              return Text(
                                '$firstName $lastName',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              );
                            } else {
                              return Text('No data available');
                            }
                          },
                        );
                      } else {
                        return Text('No data available');
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<Map<String, dynamic>>(
                      future: _userDataFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Failed to load user data: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          List<dynamic> posts = snapshot.data!['posts'];
                          if (posts.isEmpty) {
                            return Center(child: Text('Постов нет :('));
                          } else {
                            return ListView.builder(
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return _buildPostCard(posts[index], index);
                              },
                            );
                          }
                        } else {
                          return Center(child: Text('No data available'));
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Цвет кнопки
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewPublicationPage()),
                      );
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
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
            Navigator.push(
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

  Widget _buildPostCard(dynamic post, int index) {
    return FutureBuilder<String>(
      future: _firstNameFuture,
      builder: (context, firstNameSnapshot) {
        if (firstNameSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (firstNameSnapshot.hasError) {
          return Text('Error: ${firstNameSnapshot.error}');
        } else if (firstNameSnapshot.hasData) {
          return FutureBuilder<String>(
            future: _lastNameFuture,
            builder: (context, lastNameSnapshot) {
              if (lastNameSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (lastNameSnapshot.hasError) {
                return Text('Error: ${lastNameSnapshot.error}');
              } else if (lastNameSnapshot.hasData) {
                String userName = firstNameSnapshot.data!;
                String userSurname = lastNameSnapshot.data!;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PublicationPage(
                          userName: userName,
                          userSurname: userSurname,
                          postTitle: post['title'] ?? '',
                          postContent: post['content'] ?? '',
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
                            future: getUserPostTags(index), // передаем индекс поста в массиве posts
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
                                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
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
              } else {
                return Text('No data available');
              }
            },
          );
        } else {
          return Text('No data available');
        }
      },
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
}
