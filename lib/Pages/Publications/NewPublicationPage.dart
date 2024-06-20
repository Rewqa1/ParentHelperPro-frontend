import 'package:flutter/material.dart';
import '../../enumCategorys.dart';
import '../../djangoPost.dart';
import '../../djangoRequest.dart';
import '../Categorys/CategorysPage.dart';

class NewPublicationPage extends StatefulWidget {
  @override
  _NewPublicationPageState createState() => _NewPublicationPageState();
}

class _NewPublicationPageState extends State<NewPublicationPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<categorys> _selectedCategories = [];

  Future<List<int>> returnMassiveIndex() async {
    List<int> massive = [];
    for (var category in _selectedCategories) {
      int index = returnIndex(category);
      massive.add(index);
    }
    return massive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новая публикация'),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 222, 154, 87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Заголовок',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<categorys>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                  ),
                  items: categorys.values.map((category) {
                    return DropdownMenuItem<categorys>(
                      value: category,
                      child: Text(translateCategoryByCategory(category)),
                    );
                  }).toList(),
                  onChanged: (category) {
                    if (category != null && !_selectedCategories.contains(category)) {
                      setState(() {
                        _selectedCategories.add(category);
                      });
                    }
                  },
                  hint: Text('Категории'),
                ),
                SizedBox(height: 10),
                Wrap(
                  children: _selectedCategories.map((category) {
                    return Chip(
                      label: Text(translateCategoryByCategory(category)),
                      onDeleted: () {
                        setState(() {
                          _selectedCategories.remove(category);
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Text(
                  'Текст публикации',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                TextField(
                  controller: _contentController,
                  maxLines: 18,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_selectedCategories.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Нельзя опубликовать статью не выбрав категории')),
                        );
                      } else {
                        try {
                          List<int> categoriesIndices = await returnMassiveIndex(); // Получаем индексы категорий
                          int lastPostId = await getPostCount() - 1;
                          int postNewIndex = await getPostId(lastPostId) + 1;
                          int userIndex = await returnUserIndex();
                          List<String> categoryStrings = await getCategoryStringsByIndices(categoriesIndices);

                          await addPost(postNewIndex, userIndex, _titleController.text, _contentController.text, categoryStrings);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.yellow,
                              content: Text(
                                'Пост успешно создан',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CategorysPage()),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Возникла неизвестная ошибка'),
                            ),
                          );
                        }
                      }
                    },
                    child: Text('Опубликовать'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 222, 154, 87),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
