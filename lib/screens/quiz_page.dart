import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_s4/model/lesson.dart';
import 'package:project_s4/model/question.dart';
import 'package:project_s4/widgets/app_bar.dart';

class QuizPage extends StatefulWidget {
  final Lesson questionsLesson;

  QuizPage({Key? key, required this.questionsLesson}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Question> questionList;
  int currentQuestionIndex = 0;
  Map<int, String?> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    questionList = widget.questionsLesson.questions!;
    // Initialize selectedAnswers for all questions
    for (int i = 0; i < questionList.length; i++) {
      selectedAnswers[i] = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(text: 'Ultimate Learning'),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () {
              // Handle tap event, e.g., show content of the selected question
              _showQuestionContent(currentQuestionIndex);
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      Text(
                        'Question:',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      ...List.generate(
                        questionList.length,
                        (index) => GestureDetector(
                          onTap: () {
                            // Handle tap on question number to show its content
                            _showQuestionContent(index);
                          },
                          child: Container(
                            width:
                                40.0, // Set the width and height to make it a square
                            height: 40.0,
                            margin: EdgeInsets.all(8.0),
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: index == currentQuestionIndex
                                  ? Colors
                                      .green // Highlight the current question
                                  : Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Border color
                        width: 2.0, // Border thickness
                      ),
                      borderRadius: BorderRadius.circular(
                          8.0), // Optional: Rounded corners
                    ),
                    child: Text(
                      questionList[currentQuestionIndex].content,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Display answer options as radio buttons
                  Column(
                    children: [
                      _buildRadioButton(
                        "A",
                        questionList[currentQuestionIndex].answerA,
                        currentQuestionIndex,
                      ),
                      _buildRadioButton(
                        "B",
                        questionList[currentQuestionIndex].answerB,
                        currentQuestionIndex,
                      ),
                      _buildRadioButton(
                        "C",
                        questionList[currentQuestionIndex].answerC,
                        currentQuestionIndex,
                      ),
                      _buildRadioButton(
                        "D",
                        questionList[currentQuestionIndex].answerD,
                        currentQuestionIndex,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (currentQuestionIndex == questionList.length - 1)
                    Center(
                      child: ElevatedButton(
                        onPressed: _checkAnswer,
                        style: ElevatedButton.styleFrom(
                          // Set width and height of the button
                          backgroundColor: Colors.grey[50],
                          foregroundColor: Colors.green,
                          fixedSize: Size(200, 50),
                        ),
                        child: Text('Submit'),
                      ),
                    )
                  else
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle next question logic here
                          _showQuestionContent(currentQuestionIndex + 1);
                        },
                        style: ElevatedButton.styleFrom(
                          // Set width and height of the button
                          backgroundColor: Colors.grey[50],
                          foregroundColor: Colors.green,
                          fixedSize: Size(200, 50),
                        ),
                        child: Text('Next Question'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton(String value, String label, int questionIndex) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Border color
          width: 2.0, // Border thickness
        ),
        borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
      ), // Example margin for spacing
      child: ListTile(
        title: Text(label),
        leading: Radio<String>(
          value: value,
          groupValue: selectedAnswers[questionIndex],
          onChanged: (String? value) {
            setState(() {
              selectedAnswers[questionIndex] = value;
              questionList[currentQuestionIndex].answer = value;
            });
          },
        ),
      ),
    );
  }

  Future<void> _checkAnswer() async {
    String? selectedAnswer = selectedAnswers[currentQuestionIndex];

    if (selectedAnswer != null) {
      // Check if the selected answer is correct

      // Move to the next question
      if (currentQuestionIndex < questionList.length - 1) {
        setState(() {
          currentQuestionIndex++;
        });
      } else {
        context.goNamed('quiz_result', extra: widget.questionsLesson);
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Please select an answer before moving to the next question.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _showQuestionContent(int index) {
    // Update the current question index to the selected question
    setState(() {
      currentQuestionIndex = index;
    });
  }
}
