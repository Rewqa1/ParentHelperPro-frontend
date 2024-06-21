import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:PHelperPro/components/icon.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:PHelperPro/Pages/Login/LoginPage.dart';
import 'package:PHelperPro/djangoRequest.dart';
import 'package:PHelperPro/Pages/Profile/ProfilePage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

Future<void> logout(BuildContext context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('accessToken');
  await prefs.remove('refreshToken');
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    (route) => false,
  );
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirm_password;
  late String _avatarUrl;
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirm_password = TextEditingController();
    _fetchAvatar();
    _initializeNameController();
  }

  Future<void> _fetchAvatar() async {
    setState(() {
      _isLoading = true; 
    });
    try {
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

  Future<void> _initializeNameController() async {
    String firstName = await returnFirstName();
    String lastName = await returnLastName();
    setState(() {
      _nameController.text = firstName;
      _lastNameController.text = lastName;
    });
  }

  Future<void> _pickImage() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        // Use storage permission for Android 12 and below
        final status = await Permission.storage.status;
        if (status.isGranted) {
          _openGallery();
        } else if (status.isDenied || status.isRestricted) {
          final result = await Permission.storage.request();
          if (result.isGranted) {
            _openGallery();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Разрешение на доступ к галерее отклонено')),
            );
          }
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
        }
      } else {
        // Use photos permission for Android 13 and above
        final status = await Permission.photos.status;
        if (status.isGranted) {
          _openGallery();
        } else if (status.isDenied || status.isRestricted) {
          final result = await Permission.photos.request();
          if (result.isGranted) {
            _openGallery();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Разрешение на доступ к галерее отклонено')),
            );
          }
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
        }
      }
    }
  }

  Future<void> _openGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String uploadedImageUrl = await _uploadImageToServer(File(pickedFile.path));

      setState(() {
        _avatarUrl = uploadedImageUrl;
      });
    }
  }

  Future<String> _uploadImageToServer(File imageFile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      throw Exception('AccessToken не найден');
    }

    final url = Uri.parse('http://195.10.205.87:8000/update_avatar/');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.files.add(await http.MultipartFile.fromPath('avatar', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      String avatarUrl = jsonResponse['avatar'];
      avatarUrl = 'http://195.10.205.87:8000$avatarUrl';
      return avatarUrl;
    } else {
      throw Exception('Ошибка при загрузке изображения: ${response.statusCode}');
    }
  }
  
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }
 Future<void> _saveChanges() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');
    if (accessToken == null) {
      throw Exception('AccessToken не найден');
    }

    final url = Uri.parse('http://195.10.205.87:8000/profile/update/');
    Map<String, dynamic> requestBody = {};

    if (_nameController.text.trim().isNotEmpty) {
      requestBody['first_name'] = _nameController.text.trim();
    }
    if (_lastNameController.text.trim().isNotEmpty) {
      requestBody['last_name'] = _lastNameController.text.trim();
    }
    if (_oldPasswordController.text.trim().isNotEmpty &&
        _newPasswordController.text.trim().isNotEmpty &&
        _confirm_password.text.trim().isNotEmpty) {
      requestBody['old_password'] = _oldPasswordController.text.trim();
      requestBody['new_password'] = _newPasswordController.text.trim();
      requestBody['confirm_password'] = _confirm_password.text.trim();
    }

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Профиль успешно обновлен')),
      );
    } else {
      throw Exception('Ошибка при обновлении профиля, проверьте корректность введенных данных');
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ошибка при обновлении профиля, проверьте корректность введенных данных')),
    );
  }
}

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus();
    },
    child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: backArrowIcon,
          onPressed: () async {
            AppMetrica.reportEvent('toHomePage');
            String? updatedAvatarUrl = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            if (updatedAvatarUrl != null) {
              setState(() {
                _avatarUrl = updatedAvatarUrl;
              });
            }
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              reverse: true, 
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(_avatarUrl),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFFFFCED4),
                    ),
                    child: Text('Изменить фото'),
                  ),
                  SizedBox(height: 16.0),
                  _buildTextField('Имя', _nameController),
                  SizedBox(height: 16.0),
                  _buildTextField('Фамилия', _lastNameController),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _oldPasswordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Старый пароль',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _togglePasswordVisibility,
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _newPasswordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Новый пароль',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _togglePasswordVisibility,
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _confirm_password,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Подтвердите новый пароль',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _togglePasswordVisibility,
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                    ),
                    child: Text('Сохранить изменения'),
                  ),
                  SizedBox(height: 8.0),
                  TextButton(
                    onPressed: () {
                      logout(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Выйти из аккаунта'),
                  ),
                ],
              ),
            ),
    ),
  );
}

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }
}
