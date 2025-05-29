// Dart models based on Python FastAPI models

class ModuleInfo {
  final String moduleId;
  final String moduleTitle;
  final String moduleSummary;

  ModuleInfo({
    required this.moduleId,
    required this.moduleTitle,
    required this.moduleSummary,
  });

  factory ModuleInfo.fromJson(Map<String, dynamic> json) {
    return ModuleInfo(
      moduleId: json['module_id'] as String,
      moduleTitle: json['module_title'] as String,
      moduleSummary: json['module_summary'] as String,
    );
  }
}

class CourseResponse {
  final String courseTitle;
  final String courseDescription;
  final String courseIntroduction;
  final List<ModuleInfo> modules;

  CourseResponse({
    required this.courseTitle,
    required this.courseDescription,
    required this.courseIntroduction,
    required this.modules,
  });

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    var modulesList = json['modules'] as List;
    List<ModuleInfo> modules = modulesList.map((i) => ModuleInfo.fromJson(i)).toList();

    return CourseResponse(
      courseTitle: json['course_title'] as String,
      courseDescription: json['course_description'] as String,
      courseIntroduction: json['course_introduction'] as String,
      modules: modules,
    );
  }
}

class CourseRequest {
  final String title;
  final String description;
  final String targetAudience;
  final String timeAvailable;
  final String preferredFormat;
  final List<String> learningObjectives;

  CourseRequest({
    required this.title,
    required this.description,
    required this.targetAudience,
    required this.timeAvailable,
    required this.preferredFormat,
    required this.learningObjectives,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'target_audience': targetAudience,
      'time_available': timeAvailable,
      'preferred_format': preferredFormat,
      'learning_objectives': learningObjectives,
    };
  }
}
