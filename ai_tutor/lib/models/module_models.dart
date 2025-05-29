class ModuleRequest {
  final String courseTitle;
  final String courseDescription;
  final String moduleTitle;
  final String moduleSummary;

  ModuleRequest({
    required this.courseTitle,
    required this.courseDescription,
    required this.moduleTitle,
    required this.moduleSummary,
  });

  Map<String, dynamic> toJson() {
    return {
      'course_title': courseTitle,
      'course_description': courseDescription,
      'module_title': moduleTitle,
      'module_summary': moduleSummary,
    };
  }
}

class Lesson {
  final String lessonId;
  final String lessonTitle;
  final String lessonSummary;

  Lesson({
    required this.lessonId,
    required this.lessonTitle,
    required this.lessonSummary,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      lessonId: json['lesson_id'],
      lessonTitle: json['lesson_title'],
      lessonSummary: json['lesson_summary'],
    );
  }
}

class ModuleResponse {
  final String moduleId;
  final String moduleTitle;
  final String moduleDescription;
  final List<String> learningObjectives;
  final String estimatedTime;
  final List<Lesson> lessons;

  ModuleResponse({
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleDescription,
    required this.learningObjectives,
    required this.estimatedTime,
    required this.lessons,
  });

  factory ModuleResponse.fromJson(Map<String, dynamic> json) {
    return ModuleResponse(
      moduleId: json['module_id'],
      moduleTitle: json['module_title'],
      moduleDescription: json['module_description'],
      learningObjectives: List<String>.from(json['learning_objectives']),
      estimatedTime: json['estimated_time'],
      lessons: List<Lesson>.from(
        json['lessons'].map((x) => Lesson.fromJson(x)),
      ),
    );
  }
}
