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

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final List<dynamic> posts = await getPosts(1, 3);
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
    return Scaffold(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSearchBar(),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildCategorySelectionButton(),
          SizedBox(height: 16),
          Expanded(
            child: _buildPublicationsList(),
          ),
          if (_isLoading)
            Center(child: CircularProgressIndicator()),
          SizedBox(height: 16),
        ],
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          }
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Поиск',
        border: OutlineInputBorder(),
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
            });
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.grey,
          ),
          child: Text(
            _selectedCategories.isEmpty
                ? 'Выбрать теги'
                : 'Выбранные теги: ${_getSelectedCategoriesNames()}',
            textAlign: TextAlign.center,
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
                    translateCategory(category),
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

  String _getSelectedCategoriesNames() {
    return _selectedCategories
        .map((category) => translateCategory(category))
        .join(', ');
  }

  Widget _buildPublicationsList() {
    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        String title = post['title'].toString();
        String content = post['content'].toString();
        List<dynamic> tags = post['tags']; //Получаем список тегов из поста
        String tagsString = tags.map((tagIndex) => translateCategory(returnCategory(tagIndex))).join(', ');
        if (content.length > 120) {
          content = content.substring(0, 120) + '...';
        }
        return ListTile(
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
              Text(
                content,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                '$tagsString', //Выводим список тегов
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          onTap: () async {
            String userName = await getUserName(post['user']);
            String userSurname = await getUserSurname(post['user']);
            String postTitle = post['title'];
            String postContent = post['content'];

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PublicationPage(
                  userName: userName,
                  userSurname: userSurname,
                  postTitle: postTitle,
                  postContent: postContent,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
