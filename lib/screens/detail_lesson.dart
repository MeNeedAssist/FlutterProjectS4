import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_s4/api/api_service.dart';
import 'package:project_s4/model/lesson.dart';
import 'package:project_s4/theme/colors.dart';
import 'package:project_s4/theme/fonts.dart';
import 'package:project_s4/utils/api_endpoint.dart';
import 'package:project_s4/widgets/app_bar.dart';
import 'package:project_s4/widgets/comments_tile.dart';
import 'package:project_s4/widgets/my_text_box.dart';
import 'package:project_s4/widgets/text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class LessonDetail extends StatefulWidget {
  final Lesson lesson;
  const LessonDetail({super.key, required this.lesson});

  @override
  State<LessonDetail> createState() => _LessonDetailState();
}

class _LessonDetailState extends State<LessonDetail> {
  bool isLoading = true;
  bool isBuying = false;
  final textController = TextEditingController();
  final FocusNode textFocusNode = FocusNode();

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final ApiService _apiSer = ApiService();
  late Lesson lessonTrong;

  Future<void> buyLessonById() async {
    try {
      setState(() {
        isBuying = true;
      });
      final SharedPreferences? prefs = await _prefs;
      final userId = prefs?.get('userId') as int;
      final token = prefs?.get('token') as String;
      final String message =
          await _apiSer.buyLesson(token: token, lessonId: widget.lesson.id);

      //lay lai data
      final Lesson lessonAPI =
          await _apiSer.getDetailLessonByUserId(userId, widget.lesson.id);
      lessonTrong = lessonAPI;
      if (mounted) {
        if (lessonTrong.video != null) {
          _videoController = VideoPlayerController.networkUrl(
              Uri.parse('${ApiEndPoints.backendUrl}${lessonTrong.video}'))
            ..initialize().then((_) {
              setState(() {
                isLoading = false;
              });
            });

          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoInitialize: true,
            looping: false,
            allowFullScreen: true,
            allowMuting: true,
            allowPlaybackSpeedChanging: true,
            aspectRatio: 16 / 9,
            // You can customize more options here
            // ...
          );
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.toString()),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        isBuying = false;
      });
    }
  }

  Future<void> refundLesson() async {
    try {
      setState(() {
        isBuying = true;
      });
      final SharedPreferences? prefs = await _prefs;
      final userId = prefs?.get('userId') as int;
      final token = prefs?.get('token') as String;
      await _apiSer.refundLesson(token: token, lessonId: widget.lesson.id);

      //lay lai data
      final Lesson lessonAPI =
          await _apiSer.getDetailLessonByUserId(userId, widget.lesson.id);
      lessonTrong = lessonAPI;
      if (mounted) {
        if (lessonTrong.video != null) {
          _videoController = VideoPlayerController.networkUrl(
              Uri.parse('${ApiEndPoints.backendUrl}${lessonTrong.video}'))
            ..initialize().then((_) {
              setState(() {
                isLoading = false;
              });
            });

          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoInitialize: true,
            looping: false,
            allowFullScreen: true,
            allowMuting: true,
            allowPlaybackSpeedChanging: true,
            aspectRatio: 16 / 9,
            // You can customize more options here
            // ...
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    } finally {
      setState(() {
        isBuying = false;
      });
    }
  }

  Future<void> getLessonByUserId() async {
    try {
      final SharedPreferences? prefs = await _prefs;
      final userId = prefs?.get('userId') as int;
      final Lesson lessonAPI =
          await _apiSer.getDetailLessonByUserId(userId, widget.lesson.id);
      lessonTrong = lessonAPI;
      // print(lessonTrong.comments);
      if (mounted) {
        if (lessonTrong.video != null) {
          _videoController = VideoPlayerController.networkUrl(
              Uri.parse('${ApiEndPoints.backendUrl}${lessonTrong.video}'))
            ..initialize().then((_) {
              setState(() {
                isLoading = false;
              });
            });

          _chewieController = ChewieController(
            videoPlayerController: _videoController!,
            autoInitialize: true,
            looping: false,
            allowFullScreen: true,
            allowMuting: true,
            allowPlaybackSpeedChanging: true,
            aspectRatio: 16 / 9,
            // You can customize more options here
            // ...
          );
        }
      }
    } catch (error) {
      // Xử lý lỗi ở đây
      print("--------------------");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addComment() async {
    try {
      final SharedPreferences? prefs = await _prefs;
      final userId = prefs?.get('userId') as int;
      // print(emailController.text.trim());
      await _apiSer.addComment(
        content: textController.text,
        lessonId: widget.lesson.id,
        userId: userId,
      );

      final Lesson lessonAPI =
          await _apiSer.getDetailLessonByUserId(userId, widget.lesson.id);
      lessonTrong = lessonAPI;
      setState(() {
        textController.clear();
        isLoading = false;
      });
    } catch (error) {
      String errorMessage;
      if (error is Map && error.containsKey('Error Message')) {
        errorMessage = error['Error Message'];
      } else if (error is String) {
        errorMessage = error;
      } else {
        errorMessage = 'Unknown Error Occurred';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getLessonByUserId();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(text: 'Ultimate Learning'),
        body: !isLoading
            ? Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        lessonTrong.video != null
                            ? AspectRatio(
                                aspectRatio:
                                    _videoController!.value.aspectRatio,
                                child: _videoController!.value.isInitialized
                                    ? Chewie(controller: _chewieController!)
                                    : CircularProgressIndicator(),
                              )
                            : Image.network(
                                '${ApiEndPoints.backendUrl}${lessonTrong.featureImage}'),
                        const SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: Text(
                            lessonTrong.title,
                            style: customTitleFont(color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              'Author :',
                              style: customAuthorFont(color: primaryColor),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              lessonTrong.authorName,
                              style: customAuthorFont(color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              'Category :',
                              style: customAuthorFont(color: primaryColor),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              lessonTrong.categoryName,
                              style: customAuthorFont(color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          lessonTrong.content,
                          maxLines: 100,
                          overflow: TextOverflow.ellipsis,
                          style: customContentFont(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        lessonTrong.video != null
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors
                                        .black, // You can set the color of the border
                                    width:
                                        1.0, // You can set the thickness of the border
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8.0), // You can set the border radius
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    context.goNamed('quiz_page',
                                        extra: lessonTrong);
                                  },
                                  child: Text('Take a Test'),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        lessonTrong.video != null
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors
                                        .black, // You can set the color of the border
                                    width:
                                        1.0, // You can set the thickness of the border
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8.0), // You can set the border radius
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    _showRefundDialog(context);
                                  },
                                  child: Text('Refund'),
                                ),
                              )
                            : Container(),
                        Divider(),
                        Text(
                          'Comments :',
                          style: customGoogleFont(
                              fontSize: 22, color: primaryColor),
                        ),
                        lessonTrong.video != null
                            ? Row(
                                children: [
                                  Expanded(
                                    child: MyTextField(
                                      controller: textController,
                                      hintText: 'Write something...',
                                      obscureText: false,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      addComment();
                                      textFocusNode.unfocus();
                                    },
                                    icon: Icon(Icons.arrow_circle_up),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        Comment(commentUser: lessonTrong.comments),
                      ],
                    ),
                  ),
                  lessonTrong.video == null
                      ? Container(
                          color: primaryColor,
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${lessonTrong.price} ',
                                    style: customGoogleFont(fontSize: 20),
                                  ),
                                  Icon(
                                    Icons.diamond_outlined,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  color: complementaryColor,
                                  border: Border.all(color: Colors.black),
                                  // Change the color as needed
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: !isBuying
                                    ? GestureDetector(
                                        onTap: () {
                                          buyLessonById();
                                        },
                                        child: Text(
                                          'Buy now',
                                          style: customGoogleFont(fontSize: 20),
                                        ),
                                      )
                                    : CircularProgressIndicator(),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              )
            : Text('IsLoading'),
      ),
    );
  }

  @override
  void dispose() {
    if (_videoController != null && _chewieController != null) {
      _videoController?.dispose();
      _chewieController?.dispose();
      textFocusNode.dispose();
      textController.dispose();
    }
    super.dispose();
  }

  void _showRefundDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Refund Confirmation'),
          content: Text('Are you sure you want to request a refund?'),
          actions: [
            TextButton(
              onPressed: () {
                refundLesson();
                // Perform refund logic here
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
