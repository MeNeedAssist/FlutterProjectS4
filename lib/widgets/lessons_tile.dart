import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_s4/model/lesson.dart';
import 'package:project_s4/utils/api_endpoint.dart';

class LessonTile extends StatelessWidget {
  final Lesson lesson;
  const LessonTile({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
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
              context.goNamed('detail_lesson', extra: lesson);
            },
            icon: Icon(Icons.arrow_circle_right_outlined),
          ),
        ),
      ),
    );
  }
}
