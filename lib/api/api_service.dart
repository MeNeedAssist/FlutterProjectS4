import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:project_s4/model/category.dart';
import 'package:project_s4/model/lesson.dart';
import 'package:project_s4/model/question.dart';
import 'package:project_s4/model/test_result.dart';
import 'package:project_s4/model/user.dart';
import 'package:project_s4/utils/api_endpoint.dart';

class ApiService {
  ApiService();

  Future<dynamic> loginWebAccount(String email, String password) async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.loginWebAccount);
      Map body = {
        'email': email.trim(),
        'password': password,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      // print(response.statusCode);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // print(json);
        return json;
      } else {
        throw jsonDecode(response.body)["Error Message"] ??
            "Unknown Error Occurred";
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Category>> getListCategories(String token) async {
    try {
      var url = Uri.parse(ApiEndPoints.baseUrl +
          ApiEndPoints.categoriesEndpoints.getCategoriesByToken);
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        // print(jsonResponse);
        final List<dynamic> categoriesDataList = jsonResponse;

        final List<Category> categories = categoriesDataList
            .map((categoriesData) =>
                Category.fromJson(categoriesData as Map<String, dynamic>))
            .toList();

        return categories;
      } else {
        final dynamic errorResponse = jsonDecode(response.body);
        // Use the null-aware operator to check for a Message property
        throw errorResponse?['Error Message'] ?? 'Unknown Error Occurred';
      }
    } catch (error) {
      throw error.toString(); // Convert the error to a string
    }
  }

  Future<void> addOrRemoveFavorite(String token, int categoryId) async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.categoriesEndpoints.addOrRemove}/$categoryId');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final http.Response response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
      } else {
        final dynamic errorResponse = jsonDecode(response.body);
        // Use the null-aware operator to check for a Message property
        throw errorResponse?['Error Message'] ?? 'Unknown Error Occurred';
      }
    } catch (error) {
      throw error.toString(); // Convert the error to a string
    }
  }

  Future<List<Lesson>> getListLesson() async {
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.lessonEndpoints.getLesson);
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        // print(jsonResponse);
        final List<dynamic> lessonDataList = jsonResponse;

        final List<Lesson> lessons = lessonDataList
            .map((lessonsData) =>
                Lesson.fromJson(lessonsData as Map<String, dynamic>))
            .toList();

        return lessons;
      } else {
        final dynamic errorResponse = jsonDecode(response.body);
        // Use the null-aware operator to check for a Message property
        throw errorResponse?['Error Message'] ?? 'Unknown Error Occurred';
      }
    } catch (error) {
      throw error.toString(); // Convert the error to a string
    }
  }

  Future<List<Lesson>> getListLessonByUserId({required int userId}) async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.lessonEndpoints.boughtLesson}/$userId');
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        // print(jsonResponse);
        final List<dynamic> lessonDataList = jsonResponse;

        final List<Lesson> lessons = lessonDataList
            .map((lessonsData) =>
                Lesson.fromJson(lessonsData as Map<String, dynamic>))
            .toList();

        return lessons;
      } else {
        final dynamic errorResponse = jsonDecode(response.body);
        // Use the null-aware operator to check for a Message property
        throw errorResponse?['Error Message'] ?? 'Unknown Error Occurred';
      }
    } catch (error) {
      throw error.toString(); // Convert the error to a string
    }
  }

  Future<Lesson> getDetailLessonByUserId(int userId, int lessonId) async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.lessonEndpoints.getLessonByUserId}/$userId/$lessonId');

      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        // print(jsonResponse);
        // final Map<String, dynamic> lessonData = jsonResponse;
        final Lesson lesson = Lesson.fromJson(jsonResponse);

        return lesson;
      } else {
        final dynamic errorResponse = jsonDecode(response.body);
        throw errorResponse?['Error Message'] ?? 'Unknown Error Occurred';
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<dynamic> registerUser({
    required String email,
    required String name,
    required String password,
    required DateTime dateOfBirth,
  }) async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.registerUser}');
      // Construct the request body as a Map
      final Map<String, dynamic> requestBody = {
        'email': email,
        'name': name,
        'password': password,
        'dateOfBirth': dateOfBirth
            .toIso8601String(), // Convert DateTime to ISO 8601 format
      };

      // Convert the request body to a JSON string
      final String requestBodyJson = jsonEncode(requestBody);

      // Send the POST request with the JSON body
      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBodyJson,
      );
      if (response.statusCode == 200) {
        // print('Register successfully');
        // final json = jsonDecode(response.body);
        return true;
      } else {
        final dynamic errorResponse = jsonDecode(response.body);
        throw errorResponse?['Error Message'] ?? 'Unknown Error Occurred';
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<bool> sendVerifyCode({
    required String toEmail,
    required String subject,
    required String content,
  }) async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.sendVerifyCode}');

      // Construct the request body as a Map
      final Map<String, dynamic> requestBody = {
        'toEmail': toEmail,
        'subject': subject,
        'content': content,
      };

      // Convert the request body to a JSON string
      final String requestBodyJson = jsonEncode(requestBody);
      // print(requestBody);
      // Send the POST request with the JSON body
      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        // print('Verification code Service');
        return true;
      } else {
        print(
            'Failed to send verification code. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return false;
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<bool> activeUser({
    required String email,
    required String code,
  }) async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.activeUser}');

      // Construct the request body as a Map
      final Map<String, dynamic> requestBody = {
        'email': email,
        'code': code,
      };

      // Convert the request body to a JSON string
      final String requestBodyJson = jsonEncode(requestBody);
      // print(requestBody);
      // Send the POST request with the JSON body
      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBodyJson,
      );

      if (response.statusCode == 200) {
        print('Active successfully');
        return true;
      } else {
        print(
            'Failed to send verification code. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during activation: $error');
      return false;
    }
  }

  Future<User> getUserGemData({required int userId}) async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.gemData}/$userId');

      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        // print(jsonResponse);
        // final Map<String, dynamic> lessonData = jsonResponse;
        final User userGemData = User.fromJson(jsonResponse);

        return userGemData;
      } else {
        final dynamic errorResponse = jsonDecode(response.body);
        throw errorResponse?['Error Message'] ?? 'Unknown Error Occurred';
      }
    } catch (error) {
      throw error.toString();
    }
  }

  Future<dynamic> buyLesson(
      {required String token, required int lessonId}) async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.lessonEndpoints.buyLesson}/$lessonId');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final http.Response response = await http.put(url, headers: headers);
      if (response.statusCode == 200) {
        return response;
      } else {
        final dynamic errorResponse = jsonDecode(response.body);
        // Use the null-aware operator to check for a Message property
        throw errorResponse?['Error Message'] ?? 'Unknown Error Occurred';
      }
    } catch (error) {
      throw error.toString(); // Convert the error to a string
    }
  }

  Future<TestResult> checkPoint({
    required int userId,
    required int lessonId,
    required List<Question> questions,
  }) async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.lessonEndpoints.checkPoint}/$userId/$lessonId');
      var headers = {
        'Content-Type': 'application/json',
      };
      final List<Map<String, dynamic>> mappedList =
          questions.map((data) => data.toJson()).toList();

      // Convert the list of maps to a JSON-encoded string
      final String requestBody = jsonEncode(mappedList);

      final http.Response response =
          await http.put(url, headers: headers, body: requestBody);

      // Handle the response based on your requirements
      if (response.statusCode == 200) {
        // Successful response, parse the result
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        // Replace TestResult.fromJson with your actual deserialization logic
        // print(responseBody);
        return TestResult.fromJson(responseBody);
      } else {
        // Handle error responses
        throw 'Error: ${response.statusCode}, ${response.body}';
      }
    } catch (e) {
      // Handle other exceptions
      throw e.toString();
    }
  }

  Future<String> purchaseGem({required String token, required int gem}) async {
    try {
      var url = Uri.parse(
          '${ApiEndPoints.baseUrl}${ApiEndPoints.authEndpoints.buyGem}');
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final http.Response response =
          await http.put(url, headers: headers, body: jsonEncode(gem));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        final dynamic errorResponse = jsonDecode(response.body);
        // Use the null-aware operator to check for a Message property
        throw errorResponse?['Error Message'] ?? 'Unknown Error Occurred';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
