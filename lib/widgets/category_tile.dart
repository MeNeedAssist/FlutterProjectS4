// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/model/category.dart';
import 'package:project_s4/screens/lesson_category_page.dart';
import 'package:project_s4/theme/fonts.dart';
import 'package:project_s4/utils/api_endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryTile extends StatefulWidget {
  Category category;
  CategoryTile({Key? key, required this.category}) : super(key: key);
  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final ApiService _apiSer = ApiService();

  Future<void> toggleLikeRemove(int categoryId) async {
    final SharedPreferences? prefs = await _prefs;
    final token = prefs?.get('token') as String;

    // Call the asynchronous method and get the result
    await _apiSer.addOrRemoveFavorite(token, categoryId);
    widget.category.favorite = !widget.category.favorite;
    setState(() {});
  }

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
          if (widget.category.featureImage != null)
            Stack(
              alignment: Alignment.topRight,
              children: [
                Image.network(
                  '${ApiEndPoints.backendUrl}${widget.category.featureImage}',
                  height: 115,
                ),
                IconButton(
                  icon: widget.category.favorite
                      ? Icon(
                          Icons.favorite,
                        )
                      : Icon(Icons.favorite_border),
                  onPressed: () {
                    toggleLikeRemove(widget.category.categoryId);
                  },
                ),
              ],
            ),
          SizedBox(
            height: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.category.categoryName,
                style: customGoogleFont(fontSize: 20, color: Colors.black),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LessonCategoryPage(category: widget.category),
                    ),
                  );
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
