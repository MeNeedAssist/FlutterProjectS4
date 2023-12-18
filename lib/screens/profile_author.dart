import 'package:flutter/material.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/model/author.dart';
import 'package:project_s4/model/lesson.dart';
import 'package:project_s4/utils/api_endpoint.dart';
import 'package:project_s4/widgets/app_bar.dart';
import 'package:project_s4/widgets/lessons_tile.dart';

class ProfileAuthor extends StatefulWidget {
  final Author author;
  const ProfileAuthor({super.key, required this.author});

  @override
  State<ProfileAuthor> createState() => _ProfileAuthorState();
}

class _ProfileAuthorState extends State<ProfileAuthor> {
  bool isLoading = false;
  final ApiService _apiSer = ApiService();
  List<Lesson> lessonsList = [];

  Future<void> getListLessonByAuthorId() async {
    try {
      final List<Lesson> listLesson =
          await _apiSer.getListLessonByAuthorId(authorId: widget.author.userId);
      setState(() {
        isLoading = true;
        lessonsList = listLesson;
      });
    } catch (error) {
      // Xử lý lỗi ở đây
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    getListLessonByAuthorId();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(text: 'Ultimate Learning'),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                    radius: 20, // Adjust the radius as needed
                    backgroundImage: Image.network(
                            '${ApiEndPoints.backendUrl}${widget.author.avatar}')
                        .image,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.author.author,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.author.authorEmail,
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                for (Lesson lesson in lessonsList)
                  LessonTile(
                    lesson: lesson,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
