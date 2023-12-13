import 'package:flutter/material.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/model/lesson.dart';
import 'package:project_s4/widgets/lessons_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLessonPage extends StatefulWidget {
  const MyLessonPage({super.key});

  @override
  State<MyLessonPage> createState() => _MyLessonPageState();
}

class _MyLessonPageState extends State<MyLessonPage> {
  bool isLoading = true;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final ApiService _apiSer = ApiService();

  List<Lesson> lessonsList = [];

  Future<void> getListLessons() async {
    try {
      final SharedPreferences? prefs = await _prefs;
      final userId = prefs?.get('userId') as int;
      final List<Lesson> lessons =
          await _apiSer.getListLessonByUserId(userId: userId);
      setState(() {
        lessonsList = lessons;
      });
    } catch (error) {
      // Xử lý lỗi ở đây
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    getListLessons();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView.builder(
          itemCount: lessonsList.length,
          itemBuilder: (context, index) {
            Lesson lesson = lessonsList[index];
            return LessonTile(
              lesson: lesson,
            );
          },
        ),
      ),
    );
  }
}
