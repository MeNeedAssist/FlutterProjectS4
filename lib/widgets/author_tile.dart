import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_s4/model/author.dart';
import 'package:project_s4/theme/colors.dart';
import 'package:project_s4/utils/api_endpoint.dart';

class AuthorTile extends StatelessWidget {
  final Author author;
  const AuthorTile({super.key, required this.author});

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
          leading: author.avatar != null
              ? Image.network(
                  '${ApiEndPoints.backendUrl}${author.avatar}',
                  height: 100,
                )
              : Container(),
          title: Text(
            author.author,
            style: TextStyle(color: primaryColor),
          ),
          subtitle: Row(
            children: [
              Text(
                'Total: ${author.countLesson}',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Sold: ${author.soldLesson}',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              context.goNamed('profile_author', extra: author);
            },
            icon: Icon(Icons.arrow_circle_right_outlined),
          ),
        ),
      ),
    );
  }
}
