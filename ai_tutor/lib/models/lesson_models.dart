class LessonContentRequest {
  final String courseTitle;
  final String moduleTitle;
  final String lessonTitle;
  final String lessonObjective;

  LessonContentRequest({
    required this.courseTitle,
    required this.moduleTitle,
    required this.lessonTitle,
    required this.lessonObjective,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_title': courseTitle,
      'module_title': moduleTitle,
      'lesson_title': lessonTitle,
      'lesson_objective': lessonObjective,
    };
  }
}

class LessonContentResponse {
  final String? lessonId;
  final String lessonTitle;
  final String? lessonIntroduction;
  final String? lessonContent;
  final List<String>? keyTakeaways;
  final List<QuizQuestion>? quizQuestions;

  LessonContentResponse({
    this.lessonId,
    required this.lessonTitle,
    this.lessonIntroduction,
    this.lessonContent,
    this.keyTakeaways,
    this.quizQuestions,
  });

  factory LessonContentResponse.fromJson(Map<String, dynamic> json) {
    // Handle case where lesson_content might be null
    var lessonContent = json['lesson_content'];

    // Handle case where key_takeaways might be null or not a list
    List<String> keyTakeaways = [];
    if (json['key_takeaways'] != null && json['key_takeaways'] is List) {
      keyTakeaways = List<String>.from(json['key_takeaways']);
    }

    // Handle case where quiz_questions might be null
    List<QuizQuestion> quizQuestions = [];
    if (json['quiz_questions'] != null && json['quiz_questions'] is List) {
      quizQuestions = List<QuizQuestion>.from(
        json['quiz_questions'].map((q) => QuizQuestion.fromJson(q)),
      );
    }

    return LessonContentResponse(
      lessonId: json['lesson_id'],
      lessonTitle: json['lesson_title'] ?? 'Untitled Lesson',
      lessonIntroduction: json['lesson_introduction'],
      lessonContent: lessonContent,
      keyTakeaways: keyTakeaways,
      quizQuestions: quizQuestions,
    );
  }
}

// Add new class for quiz requests
class QuizRequest {
  final String courseTitle;
  final String moduleTitle;
  final String lessonTitle;
  final String lessonObjective;

  QuizRequest({
    required this.courseTitle,
    required this.moduleTitle,
    required this.lessonTitle,
    required this.lessonObjective,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_title': courseTitle,
      'module_title': moduleTitle,
      'lesson_title': lessonTitle,
      'lesson_objective': lessonObjective,
    };
  }
}

class QuizResponse {
  final List<QuizQuestion> quiz;

  QuizResponse({required this.quiz});

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    List<QuizQuestion> questions = [];
    if (json['quiz'] != null) {
      questions = (json['quiz'] as List)
          .map((question) => QuizQuestion.fromJson(question))
          .toList();
    }
    return QuizResponse(quiz: questions);
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String correctAnswer;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.correctOptionIndex,
    required this.explanation,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    // Handle parsing the correct option index
    int index;
    if (json['correct_option_index'] != null) {
      if (json['correct_option_index'] is int) {
        index = json['correct_option_index'];
      } else {
        // Try to parse as integer if it's a string
        index = int.tryParse(json['correct_option_index'].toString()) ?? 0;
      }
    } else {
      // If no index provided, try to find the correct answer in options
      final options = List<String>.from(json['options'] ?? []);
      final correctAnswer = json['correct_answer'] ?? '';
      index = options.indexOf(correctAnswer);
      if (index == -1) index = 0; // Default to first option if not found
    }

    return QuizQuestion(
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correct_answer'] ?? '',
      correctOptionIndex: index,
      explanation: json['explanation'] ?? '',
    );
  }
}
