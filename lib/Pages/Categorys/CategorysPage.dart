import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import '../Home/HomePage.dart';
import '../Profile/ProfilePage.dart';
import '../../enumCategorys.dart';
import '../../djangoRequest.dart';
import '../Publications/PublicationPage.dart';

class CategorysPage extends StatefulWidget {
  @override
  _CategorysPageState createState() => _CategorysPageState();
}

class _CategorysPageState extends State<CategorysPage> {
  List<categorys> _selectedCategories = [];
  bool _isCategorySelectionExpanded = false;
  List<dynamic> _posts = [];
  bool _isLoading = false;
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    List<String> empt = [];
    fetchPosts("", empt);
  }

  Future<void> fetchPosts(String title, List<String> tags) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<dynamic> posts = await getPosts(title, tags);
      setState(() {
        _posts = posts;
      });
    } catch (e) {
      print('Failed to fetch posts: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Закрываем клавиатуру при касании любой области экрана
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Публикации'),
          titleTextStyle: TextStyle(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 222, 154, 87),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCategorySelectionExpanded = false;
                        });
                      },
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Поиск',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      //ТУТ РАБОТАЕТ ПОИСК
                      List<String> nowSelectedCategories = getCategoryStrings(_selectedCategories);
                      fetchPosts(_searchController.text, nowSelectedCategories);
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildCategorySelectionButton(),
              SizedBox(height: 16),
              _buildPublicationsList(),
              if (_isLoading) Center(child: CircularProgressIndicator()),
              SizedBox(height: 16),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 222, 154, 87),
          type: BottomNavigationBarType.fixed,
          items: const [
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategorySelectionButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _isCategorySelectionExpanded = !_isCategorySelectionExpanded;
              FocusScope.of(context).unfocus();
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _selectedCategories.isEmpty
                    ? 'Фильтрация'
                    : 'Фильтрация', // можно вставить ${_getSelectedCategoriesNames()} если решить проблему размерности
                textAlign: TextAlign.center,
              ),
              Icon(
                _isCategorySelectionExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              ),
            ],
          ),
        ),
        Visibility(
          visible: _isCategorySelectionExpanded,
          child: Wrap(
            children: List.generate(categorys.values.length, (index) {
              var category = categorys.values.elementAt(index);
              return Row(
                children: [
                  Checkbox(
                    value: _selectedCategories.contains(category),
                    onChanged: (checked) {
                      setState(() {
                        if (checked!) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  SizedBox(width: 4),
                  Text(
                    translateCategoryByCategory(category),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 4),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPublicationsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        String title = post['title'].toString();
        String content = post['content'].toString();
        List<dynamic> tags = post['tags']; //Получаем список тегов из поста
        String tagsString = tags.map((tagIndex) => translateCategoryByText(tagIndex)).join(', ');
        if (content.length > 120) {
          content = content.substring(0, 120) + '...';
        }
        return Container(
          color: Colors.grey[300],
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  color: Colors.grey[400], // Более темный серый фон для содержимого поста
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 4),
                Center( // Центровка текста тегов
                  child: Text(
                    '$tagsString', // Выводим список тегов
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () async {
              String avatarUrl = await getUserAvatarUrl(post['id']);
              String userName = await getUserName(post['id']);
              String userSurname = await getUserSurname(post['id']);
              String postTitle = post['title'];
              String postContent = post['content'];
              int id = post['id'];
              int user = post['user'];
              List<dynamic> posts = await getPostsByPostId(post['id']) as List;
              AppMetrica.reportEvent('Просмотр публикаций');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PublicationPage(
                    avatarUrl: avatarUrl,
                    userName: userName,
                    userSurname: userSurname,
                    postTitle: postTitle,
                    postContent: postContent,
                    id: id,
                    user: user,
                    posts: posts,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose(); // Убедимся, что контроллер прокрутки освобожден
    super.dispose();
  }
}
