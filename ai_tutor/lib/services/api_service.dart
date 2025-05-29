import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ai_tutor/models/course_models.dart';
import 'package:ai_tutor/models/module_models.dart';
import 'package:ai_tutor/models/lesson_models.dart';
import 'package:ai_tutor/models/document_models.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class ApiService {
  final String _baseUrl =
      "http://localhost:8000/api/v1"; // Assuming backend runs on localhost:8000

  Future<CourseResponse> planCourse(CourseRequest request) async {
    final url = Uri.parse('$_baseUrl/plan-course');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response,
        // then parse the JSON.
        final decodedJson = jsonDecode(
            utf8.decode(response.bodyBytes)); // Ensure UTF-8 decoding
        return CourseResponse.fromJson(decodedJson);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception(
            'Failed to plan course: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      // Handle network errors or other exceptions during the request
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }

  Future<ModuleResponse> planModule(ModuleRequest request) async {
    final url = Uri.parse('$_baseUrl/plan-module');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response,
        // then parse the JSON.
        final decodedJson = jsonDecode(
            utf8.decode(response.bodyBytes)); // Ensure UTF-8 decoding
        return ModuleResponse.fromJson(decodedJson);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception(
            'Failed to plan module: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      // Handle network errors or other exceptions during the request
      throw Exception('Failed to connect to the server or other error: $e');
    }
  }

  Future<LessonContentResponse> createLessonContent(
      LessonContentRequest request) async {
    final url = Uri.parse('$_baseUrl/create-lesson-content');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response,
        // then parse the JSON with proper error handling
        final responseBody = utf8.decode(response.bodyBytes);
        if (responseBody.isEmpty) {
          throw Exception('Server returned an empty response');
        }

        dynamic decodedJson;
        try {
          decodedJson = jsonDecode(responseBody);
        } catch (e) {
          throw Exception(
              'Failed to decode JSON response: $e\nRaw response: $responseBody');
        }

        if (decodedJson == null) {
          throw Exception('Decoded JSON is null');
        }

        return LessonContentResponse.fromJson(decodedJson);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception(
            'Failed to create lesson content: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      // More detailed error handling
      if (e is http.ClientException) {
        throw Exception('Network error: ${e.message}');
      } else {
        throw Exception('Failed to connect to the server or other error: $e');
      }
    }
  }

  Future<QuizResponse> createQuiz(QuizRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/create-quiz'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final responseBody = utf8.decode(response.bodyBytes);
        if (responseBody.isEmpty) {
          throw Exception('Server returned an empty response');
        }

        dynamic decodedJson;
        try {
          decodedJson = jsonDecode(responseBody);
        } catch (e) {
          throw Exception(
              'Failed to decode JSON response: $e\nRaw response: $responseBody');
        }

        if (decodedJson == null) {
          throw Exception('Decoded JSON is null');
        }

        return QuizResponse.fromJson(decodedJson);
      } else {
        // If the server did not return a 200 OK response, throw an exception
        throw Exception(
            'Failed to create quiz: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      // More detailed error handling
      if (e is http.ClientException) {
        throw Exception('Network error: ${e.message}');
      } else {
        throw Exception('Failed to connect to the server or other error: $e');
      }
    }
  }

  // Document upload method that works for both web and mobile
  Future<DocumentUploadResponse> uploadDocument(PlatformFile file) async {
    final url = Uri.parse('$_baseUrl/documents/upload');

    try {
      // Create a multipart request
      final request = http.MultipartRequest('POST', url);

      // Determine file mime type
      String extension = file.extension?.toLowerCase() ?? '';
      String mimeType;

      switch (extension) {
        case 'pdf':
          mimeType = 'application/pdf';
          break;
        case 'doc':
          mimeType = 'application/msword';
          break;
        case 'docx':
          mimeType =
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
          break;
        case 'txt':
          mimeType = 'text/plain';
          break;
        default:
          mimeType = 'application/octet-stream';
      }

      // Use bytes for web and mobile compatibility
      if (file.bytes != null) {
        // Web case: use bytes directly
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: file.name,
            contentType: MediaType.parse(mimeType),
          ),
        );
      } else if (file.path != null) {
        // Mobile case: use file path
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path!,
            contentType: MediaType.parse(mimeType),
          ),
        );
      } else {
        throw Exception('Neither file bytes nor path is available');
      }

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(utf8.decode(response.bodyBytes));
        return DocumentUploadResponse.fromJson(decodedJson);
      } else {
        throw Exception(
            'Failed to upload document: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  // Generate course from document method
  Future<CourseResponse> generateCourseFromDocument(
      DocumentCourseRequest request) async {
    final url = Uri.parse('$_baseUrl/document-courses/generate-course');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(utf8.decode(response.bodyBytes));
        return CourseResponse.fromJson(decodedJson);
      } else {
        throw Exception(
            'Failed to generate course from document: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to generate course from document: $e');
    }
  }
}
