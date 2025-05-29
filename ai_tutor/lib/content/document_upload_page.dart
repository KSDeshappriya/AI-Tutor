import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ai_tutor/services/api_service.dart';
import 'package:ai_tutor/models/document_models.dart';
import 'package:ai_tutor/content/content_preview_page.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/focus_aware_background.dart'; // Add this import

class DocumentUploadPage extends StatefulWidget {
  const DocumentUploadPage({super.key});

  @override
  State<DocumentUploadPage> createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends State<DocumentUploadPage> {
  final ApiService _apiService = ApiService();
  PlatformFile? _selectedFile;
  bool _isUploading = false;
  bool _isGeneratingCourse = false;
  String? _uploadedDocumentId;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  String _selectedComplexity = 'beginner';
  final List<String> _complexityLevels = [
    'beginner',
    'intermediate',
    'advanced'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        withData: true, // Important for web: ensure we get the file bytes
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
          _uploadedDocumentId =
              null; // Reset uploaded ID when new file is selected
        });

        // Show feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected file: ${result.files.first.name}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file first')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final response = await _apiService.uploadDocument(_selectedFile!);

      setState(() {
        _isUploading = false;
        _uploadedDocumentId = response.documentId;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('File uploaded successfully: ${response.filename}')),
      );
    } catch (e) {
      setState(() {
        _isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    }
  }

  Future<void> _generateCourseFromDocument() async {
    if (_uploadedDocumentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a document first')),
      );
      return;
    }

    setState(() {
      _isGeneratingCourse = true;
    });

    try {
      final request = DocumentCourseRequest(
        documentId: _uploadedDocumentId!,
        additionalContext: _contextController.text,
        titleOverride:
            _titleController.text.isEmpty ? null : _titleController.text,
        targetAudience: 'General audience',
        complexityLevel: _selectedComplexity,
      );

      final courseResponse =
          await _apiService.generateCourseFromDocument(request);

      setState(() {
        _isGeneratingCourse = false;
      });

      // Navigate to content preview page
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ContentPreviewPage(courseData: courseResponse),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isGeneratingCourse = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate course: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Upload Document'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FocusAwareBackground(
        // Add FocusAwareBackground
        primaryColor: Colors.blue.shade400,
        secondaryColor: Colors.blue.shade600,
        opacity: 0.03,
        enableWaves: true,
        enableParticles: true,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload a document to generate a course',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Document upload section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _selectedFile != null
                              ? Icons.description
                              : Icons.cloud_upload_outlined,
                          size: 60,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFile != null
                              ? 'Selected: ${_selectedFile!.name}'
                              : 'Click to select a document',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _isUploading ? null : _pickFile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Select File'),
                        ),
                        if (_selectedFile != null) ...[
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _isUploading ? null : _uploadFile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: _isUploading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Upload Document'),
                          ),
                        ],
                      ],
                    ),
                  ),

                  if (_uploadedDocumentId != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Course Generation Options',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Course title field
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Course Title (optional)',
                        hintText: 'Leave blank for auto-generated title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Additional context field
                    TextField(
                      controller: _contextController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Additional Context',
                        hintText: 'E.g., Focus on practical applications',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Complexity level dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedComplexity,
                      decoration: InputDecoration(
                        labelText: 'Complexity Level',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      items: _complexityLevels.map((String level) {
                        // Capitalize first letter for display
                        String displayText =
                            level[0].toUpperCase() + level.substring(1);
                        return DropdownMenuItem<String>(
                          value: level,
                          child: Text(displayText),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedComplexity = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Generate course button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isGeneratingCourse
                            ? null
                            : _generateCourseFromDocument,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isGeneratingCourse
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Generate Course',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}
