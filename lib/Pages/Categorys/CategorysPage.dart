import 'package:flutter/material.dart';
import '../Home/HomePage.dart';
import '../Profile/ProfilePage.dart';
import '/enumCategorys.dart';
import '/djangoRequest.dart';
import '../Publications/PublicationPage.dart';

class CategorysPage extends StatefulWidget {
  @override
  _CategorysPageState createState() => _CategorysPageState();
}

class _CategorysPageState extends State<CategorysPage> {
  List<categorys> _selectedCategories = [];
  bool _isCategorySelectionExpanded = false;
  int _currentPage = 1;
  int _postsPerPage = 9; // Количество постов на одной странице
  int _totalPosts = 0;
  List<dynamic>? _posts;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final List<dynamic>? posts = await getPosts(_currentPage, _postsPerPage);
      if (posts != null) {
        setState(() {
          _totalPosts = posts.length;
          // Очищаем список и добавляем только необходимое количество постов
          _posts = posts.take(_postsPerPage).toList();
        });
      }
    } catch (e) {
      print('Failed to fetch posts: $e');
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
      body: SingleChildScrollView(
        child: Column(
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
            _buildPublicationsList(),
            SizedBox(height: 16),
            _buildPaginationButtons(),
            SizedBox(height: 16),
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
            backgroundColor: Colors.blue,
          ),
          child: Text(_selectedCategories.isEmpty
              ? 'Выбрать категории'
              : _getSelectedCategoriesNames()),
        ),
        Visibility(
          visible: _isCategorySelectionExpanded,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: 200,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
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
                        materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _translateCategory(category),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(width: 4),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getSelectedCategoriesNames() {
    return _selectedCategories
        .map((category) => _translateCategory(category))
        .join(', ');
  }

  Widget _buildPublicationsList() {
    return _posts != null
        ? ListView.builder(
      shrinkWrap: true,
      itemCount: _posts!.length,
      itemBuilder: (context, index) {
        final post = _posts![index];
        String title = post['title'].toString();
        String content = post['content'].toString();
        if (content.length > 120) {
          content = content.substring(0, 120) + '...';
        }
        return ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
          onTap: () async {
            String userName = await getUserName(post['user_id']);
            String userSurname = await getUserSurname(post['user_id']);
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
    )
        : Center(
      child: CircularProgressIndicator(),
    );
  }

  String _translateCategory(categorys category) {
    switch (category) {
      case categorys.parenting:
        return 'воспитание';
      case categorys.education:
        return 'обучение';
      case categorys.games:
        return 'игры';
      case categorys.nutrition:
        return 'питание';
      case categorys.sports:
        return 'спорт';
      case categorys.illness:
        return 'здоровье';
      case categorys.psychology:
        return 'психология';
      case categorys.stories:
        return 'здоровье';
      case categorys.hints:
        return 'советы';
      case categorys.other:
        return 'другое';
      default:
        return '';
    }
  }

  Widget _buildPaginationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _currentPage > 1 ? () => _changePage(-1) : null,
          child: Text('Предыдущая'),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: _currentPage * _postsPerPage < _totalPosts
              ? () => _changePage(1)
              : null,
          child: Text('Следующая'),
        ),
      ],
    );
  }

  void _changePage(int increment) {
    setState(() {
      _currentPage += increment;
      fetchNextPagePosts();
    });
  }

  Future<void> fetchNextPagePosts() async {
    try {
      final List<dynamic>? nextPagePosts = await getPosts(_currentPage, _postsPerPage);
      if (nextPagePosts != null) {
        setState(() {
          _posts?.clear();
          _posts?.addAll(nextPagePosts);
        });
      }
    } catch (e) {
      print('Failed to fetch posts: $e');
    }
  }

}
