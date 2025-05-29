import 'package:flutter/material.dart';
import 'package:ai_tutor/models/module_models.dart';
import 'package:ai_tutor/models/lesson_models.dart';
import 'package:ai_tutor/services/api_service.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/animated_background.dart';
import 'lesson_detail_page.dart';

class ContentPage extends StatefulWidget {
  final ModuleResponse? moduleData;
  final String courseTitle;

  const ContentPage({
    super.key,
    this.moduleData,
    required this.courseTitle,
  });

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final ApiService _apiService = ApiService();
  Map<String, bool> _loadingLessons = {};
  Map<String, LessonContentResponse?> _lessonContents = {};

  Future<void> _loadLessonContent(Lesson lesson) async {
    if (_loadingLessons[lesson.lessonId] == true) return;

    setState(() {
      _loadingLessons[lesson.lessonId] = true;
    });

    try {
      if (widget.moduleData == null) {
        throw Exception('Module data is not available');
      }

      final lessonRequest = LessonContentRequest(
        courseTitle: widget.courseTitle,
        moduleTitle: widget.moduleData!.moduleTitle,
        lessonTitle: lesson.lessonTitle,
        lessonObjective: lesson.lessonSummary,
      );

      try {
        final lessonResponse =
            await _apiService.createLessonContent(lessonRequest);

        setState(() {
          _lessonContents[lesson.lessonId] = lessonResponse;
          _loadingLessons[lesson.lessonId] = false;
        });

        // Navigate to lesson detail page with the detailed content
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonDetailPage(
              lessonData: lessonResponse,
              courseTitle: widget.courseTitle,
              moduleTitle: widget.moduleData!.moduleTitle,
            ),
          ),
        );
      } catch (e) {
        setState(() {
          _loadingLessons[lesson.lessonId] = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load lesson content: $e'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _loadLessonContent(lesson),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _loadingLessons[lesson.lessonId] = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBackground(
        primaryColor: Colors.blue.shade400,
        secondaryColor: Colors.blue.shade600,
        opacity: 0.03,
        enableWaves: true,
        enableParticles: true,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),
              Expanded(
                child: widget.moduleData == null
                    ? const Center(child: Text('No module data available'))
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Module Title
                              Text(
                                widget.moduleData!.moduleTitle,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Estimated Time
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Estimated time: ${widget.moduleData!.estimatedTime}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Module Description
                              Text(
                                widget.moduleData!.moduleDescription,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Learning Objectives
                              const Text(
                                'Learning Objectives',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...widget.moduleData!.learningObjectives
                                  .map((objective) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: Colors.green, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(objective),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 24),
                              // Lessons
                              const Text(
                                'Lessons',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...widget.moduleData!.lessons.map((lesson) {
                                final isLoading =
                                    _loadingLessons[lesson.lessonId] ?? false;

                                return GestureDetector(
                                  onTap: () => _loadLessonContent(lesson),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                lesson.lessonTitle,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            if (isLoading)
                                              const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            else
                                              const Icon(
                                                Icons.arrow_forward_ios,
                                                size: 16,
                                                color: Colors.grey,
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          lesson.lessonSummary,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}
