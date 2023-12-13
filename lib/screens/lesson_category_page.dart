import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/model/category.dart';
import 'package:project_s4/model/lesson.dart';
import 'package:project_s4/utils/api_endpoint.dart';
import 'package:project_s4/widgets/app_bar.dart';

class LessonCategoryPage extends StatefulWidget {
  final Category category;
  const LessonCategoryPage({super.key, required this.category});

  @override
  State<LessonCategoryPage> createState() => _LessonCategoryPageState();
}

class _LessonCategoryPageState extends State<LessonCategoryPage> {
  final ApiService _apiSer = ApiService();
  List<Lesson> lessonsList = [];
  Future<void> getListLessons() async {
    try {
      final List<Lesson> lessons = await _apiSer.getListLesson();
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
    List<Lesson> filteredLessons = lessonsList
        .where((lesson) => lesson.categoryName == widget.category.categoryName)
        .toList();
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(text: 'Ultimate Learning'),
        body: Column(
          children: [
            // Add any other widgets or information you want to display here

            // Display the filtered lessons in a ListView
            filteredLessons.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: filteredLessons.length,
                      itemBuilder: (context, index) {
                        Lesson lesson = filteredLessons[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            height: 70, // Adjust the height as needed
                            child: ListTile(
                              leading: lesson.featureImage != null
                                  ? Image.network(
                                      '${ApiEndPoints.backendUrl}${lesson.featureImage}',
                                      height: 100,
                                    )
                                  : Container(),
                              title: Text(lesson.title),
                              subtitle: Text(
                                'Price: ${lesson.price}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  context.goNamed('detail_lesson',
                                      extra: lesson);
                                },
                                icon: Icon(Icons.arrow_circle_right_outlined),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}
