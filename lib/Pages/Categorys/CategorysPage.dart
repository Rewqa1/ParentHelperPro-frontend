import 'package:flutter/material.dart';
import '../Home/HomePage.dart';
import '../Profile/ProfilePage.dart';
import '/enumCategorys.dart';
import '/djangoRequest.dart';

class CategorysPage extends StatefulWidget {
  @override
  _CategorysPageState createState() => _CategorysPageState();
}

class _CategorysPageState extends State<CategorysPage> {
  List<categorys> _selectedCategories = [];
  bool _isCategorySelectionExpanded = false;

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
                  onPressed: () async {
                    int userId = await getPostCount();
                    String userlogin = await getUserName(0);
                    print(userlogin);
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildCategorySelectionButton(),
            SizedBox(height: 16),
            _buildPublicationsList(), // Здесь будет список публикаций
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
          // Навигация на страницу публикаций (уже находимся на этой странице)
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
            foregroundColor: Colors.white, backgroundColor: Colors.blue,
          ),
          child: Text(_selectedCategories.isEmpty ? 'Выбрать категории' : _getSelectedCategoriesNames()),
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
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _translateCategory(category),
                        style: TextStyle(fontSize: 14), // уменьшим размер текста
                      ),
                      SizedBox(width: 4), // уменьшим отступы между элементами
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
    return _selectedCategories.map((category) => _translateCategory(category)).join(', ');
  }

  Widget _buildPublicationsList() {
    // Здесь нужно будет отобразить список публикаций
    // Можно использовать ListView.builder для динамического построения списка
    return Container(
      color: Colors.grey[200], // Серый фон
      child: ListView.builder(
        itemCount: 10, // Пример количества публикаций
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              'Название публикации $index',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              'Краткий текст публикации $index',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onTap: () {
              // Добавьте функционал выбора публикации
              print('Выбрана публикация номер $index');
            },
          );
        },
      ),
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
}