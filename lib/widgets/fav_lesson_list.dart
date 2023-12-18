import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_s4/model/lesson.dart';
import 'package:project_s4/theme/fonts.dart';
import 'package:project_s4/utils/api_endpoint.dart';

class FavLessonList extends StatelessWidget {
  final Lesson lessons;
  FavLessonList({super.key, required this.lessons});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.only(left: 5),
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          if (lessons.featureImage != null)
            Image.network(
              '${ApiEndPoints.backendUrl}${lessons.featureImage}',
              height: 105,
            ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    lessons.title,
                    style: customGoogleFont(fontSize: 18, color: Colors.black),
                  ),
                  Text(
                    'Price: ${lessons.price.toString()}',
                    style: customGoogleFont(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  context.goNamed('detail_lesson', extra: lessons);
                },
                icon: Icon(Icons.arrow_circle_right_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
