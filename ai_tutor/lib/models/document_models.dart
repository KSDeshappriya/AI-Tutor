class DocumentUploadResponse {
  final String documentId;
  final String filename;
  final String message;
  final bool contentExtracted;

  DocumentUploadResponse({
    required this.documentId,
    required this.filename,
    required this.message,
    required this.contentExtracted,
  });

  factory DocumentUploadResponse.fromJson(Map<String, dynamic> json) {
    return DocumentUploadResponse(
      documentId: json['document_id'] ?? '',
      filename: json['filename'] ?? '',
      message: json['message'] ?? 'Upload successful',
      contentExtracted: json['content_extracted'] ?? false,
    );
  }
}

class DocumentCourseRequest {
  final String documentId;
  final String? additionalContext;
  final String? titleOverride;
  final String? targetAudience;
  final String? complexityLevel;

  DocumentCourseRequest({
    required this.documentId,
    this.additionalContext,
    this.titleOverride,
    this.targetAudience,
    this.complexityLevel,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'document_id': documentId,
    };

    if (additionalContext != null && additionalContext!.isNotEmpty) {
      data['additional_context'] = additionalContext;
    }
    if (titleOverride != null && titleOverride!.isNotEmpty) {
      data['title_override'] = titleOverride;
    }
    if (targetAudience != null && targetAudience!.isNotEmpty) {
      data['target_audience'] = targetAudience;
    }
    if (complexityLevel != null && complexityLevel!.isNotEmpty) {
      data['complexity_level'] = complexityLevel;
    }

    return data;
  }
}
