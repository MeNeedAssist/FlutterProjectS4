import 'package:flutter/material.dart';
import 'package:project_s4/model/comments.dart';

class Comment extends StatelessWidget {
  final List<Comments>? commentUser;
  const Comment({Key? key, required this.commentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var comment in commentUser!)
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ListTile(
                  title: Text(
                    comment.userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(comment.content),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
      ],
    );
  }
}
