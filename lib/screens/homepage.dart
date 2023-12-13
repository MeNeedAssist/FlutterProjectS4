import 'package:flutter/material.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/model/category.dart';
import 'package:project_s4/model/lesson.dart';
import 'package:project_s4/screens/my_lesson.dart';
import 'package:project_s4/screens/profile.dart';
import 'package:project_s4/theme/colors.dart';
import 'package:project_s4/theme/fonts.dart';
import 'package:project_s4/widgets/app_bar.dart';
import 'package:project_s4/widgets/category_tile.dart';
import 'package:project_s4/widgets/lessons_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  bool isLoading = true;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final ApiService _apiSer = ApiService();

  List<Category> categoriesList = [];
  List<Lesson> lessonsList = [];

  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;

  // Assume this is inside an async function
  Future<void> getListCategories() async {
    try {
      final SharedPreferences? prefs = await _prefs;
      final token = prefs?.get('token') as String;
      final List<Category> categories = await _apiSer.getListCategories(token);
      setState(() {
        categoriesList = categories;
      });
    } catch (error) {
      // Xử lý lỗi ở đây
      print(error);
    }
  }

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
    getListCategories();
    getListLessons();
    _scrollController.addListener(() {
      setState(() {
        _showScrollToTopButton = _scrollController.offset >= 200;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(text: 'Ultimate Learning'),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: <Widget>[
            ListView(
              controller: _scrollController,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _slogan(),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'Category',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoriesList.length,
                        itemBuilder: (context, index) =>
                            CategoryTile(category: categoriesList[index]),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        'List of Lessons',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    for (Lesson lesson in lessonsList)
                      LessonTile(
                        lesson: lesson,
                      ),
                  ],
                ),
              ],
            ),
            MyLessonPage(),
            MyProfilePage(),
          ][currentPageIndex],
        ),
        bottomNavigationBar: _bottomNavBar(),
        floatingActionButton: _showScrollToTopButton
            ? FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                child: Icon(Icons.arrow_upward),
              )
            : null,
      ),
    );
  }

  Container _slogan() {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.9),
      ),
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Unlock Your Potential, Embrace Learning.',
                style: customGoogleFont(fontSize: 13),
              ),
              Text(
                'Learn Today, Lead Tomorrow.',
                style: customGoogleFont(fontSize: 13),
              ),
              Text(
                'Explore, Learn, Grow.',
                style: customGoogleFont(fontSize: 13),
              ),
            ],
          ),
          Image.asset(
            'images/assets/books.jpg',
            width: 70,
          )
        ],
      ),
    );
  }

  NavigationBar _bottomNavBar() {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      indicatorColor: Colors.amber,
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.library_books_rounded),
          label: 'MyLesson',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
