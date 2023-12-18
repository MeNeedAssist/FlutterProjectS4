import 'package:flutter/material.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/model/author.dart';
import 'package:project_s4/widgets/author_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorPage extends StatefulWidget {
  const AuthorPage({super.key});

  @override
  State<AuthorPage> createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final ApiService _apiSer = ApiService();

  List<Author> authorList = [];

  Future<void> getListAuthor() async {
    try {
      final List<Author> listAuthor = await _apiSer.getListAuthor();
      setState(() {
        authorList = listAuthor;
      });
    } catch (error) {
      // Xử lý lỗi ở đây
      print(error);
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    getListAuthor();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          itemCount: authorList.length,
          itemBuilder: (context, index) =>
              AuthorTile(author: authorList[index]),
        ),
      ),
    );
  }
}
