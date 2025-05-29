import 'package:flutter/material.dart';
import 'package:ai_tutor/models/lesson_models.dart';
import 'package:ai_tutor/services/api_service.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/animated_background.dart';
import 'ask_question_page.dart';
import '../quiz/quiz_page.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class LessonDetailPage extends StatelessWidget {
  final LessonContentResponse lessonData;
  final String courseTitle;
  final String moduleTitle;
  final ApiService _apiService = ApiService();

  LessonDetailPage({
    Key? key,
    required this.lessonData,
    required this.courseTitle,
    required this.moduleTitle,
  }) : super(key: key);

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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lesson Title with decorative element
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade100,
                                Colors.blue.shade50
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Text(
                            lessonData.lessonTitle,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Introduction Section if available
                        if (lessonData.lessonIntroduction != null &&
                            lessonData.lessonIntroduction!.isNotEmpty) ...[
                          _buildSectionHeader('Introduction'),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.blue.shade100, width: 1),
                            ),
                            child: MarkdownBody(
                              data: lessonData.lessonIntroduction ??
                                  'No introduction available.',
                              styleSheet: MarkdownStyleSheet(
                                p: const TextStyle(fontSize: 16, height: 1.6),
                                code: TextStyle(
                                  backgroundColor: Colors.grey.shade200,
                                  color: Colors.black87,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],

                        // Main Content Section
                        _buildSectionHeader('Lesson Content'),
                        const SizedBox(height: 12),

                        // Use Markdown widget to render markdown content
                        if (lessonData.lessonContent != null &&
                            lessonData.lessonContent!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: MarkdownBody(
                              data: lessonData.lessonContent!,
                              styleSheet: MarkdownStyleSheet(
                                p: const TextStyle(fontSize: 16, height: 1.6),
                                h1: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                                h2: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                h3: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                blockquote: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                                code: TextStyle(
                                  backgroundColor: Colors.grey.shade200,
                                  color: Colors.black87,
                                  fontFamily: 'monospace',
                                ),
                                codeblockPadding: const EdgeInsets.all(8),
                              ),
                            ),
                          )
                        else
                          _buildEmptyState(
                              'No lesson content available. Please try regenerating the content.'),

                        const SizedBox(height: 30),

                        // Key Takeaways Section if available
                        if (lessonData.keyTakeaways != null &&
                            lessonData.keyTakeaways!.isNotEmpty) ...[
                          _buildSectionHeader('Key Takeaways'),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Colors.green.shade100, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  lessonData.keyTakeaways!.map((takeaway) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.check,
                                            color: Colors.green, size: 16),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          takeaway,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AskQuestionPage(
                                        section: lessonData.lessonTitle,
                                      ),
                                    ),
                                  );
                                },
                                icon:
                                    const Icon(Icons.question_answer_outlined),
                                label: const Text('Ask Question'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue.shade700,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side:
                                        BorderSide(color: Colors.blue.shade200),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  // Show loading dialog instead of snackbar for better UX
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return const AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircularProgressIndicator(),
                                            SizedBox(height: 16),
                                            Text('Generating quiz questions...')
                                          ],
                                        ),
                                      );
                                    },
                                  );

                                  try {
                                    // If we already have quiz questions, use them
                                    if (lessonData.quizQuestions != null &&
                                        lessonData.quizQuestions!.isNotEmpty) {
                                      // Hide the dialog before navigating
                                      Navigator.pop(context);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => QuizPage(
                                            section: lessonData.lessonTitle,
                                            quizQuestions:
                                                lessonData.quizQuestions,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Otherwise, generate new quiz questions from API
                                      final quizRequest = QuizRequest(
                                        courseTitle: courseTitle,
                                        moduleTitle: moduleTitle,
                                        lessonTitle: lessonData.lessonTitle,
                                        lessonObjective: lessonData
                                                .lessonIntroduction ??
                                            "Learn about ${lessonData.lessonTitle}",
                                      );

                                      final quizResponse = await _apiService
                                          .createQuiz(quizRequest);

                                      // Hide the dialog before navigating
                                      Navigator.pop(context);

                                      if (quizResponse.quiz.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'No quiz questions were generated. Please try again.'),
                                            duration: Duration(seconds: 5),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => QuizPage(
                                              section: lessonData.lessonTitle,
                                              quizQuestions: quizResponse.quiz,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  } catch (e) {
                                    // Always pop the dialog if there's an error
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Failed to generate quiz: ${e.toString()}'),
                                        duration: const Duration(seconds: 5),
                                        action: SnackBarAction(
                                          label: 'Try Again',
                                          onPressed: () {
                                            // Retry the quiz generation
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.quiz_outlined),
                                label: const Text('Take Quiz'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
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

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.info_outline, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
