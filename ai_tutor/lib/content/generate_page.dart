import 'package:flutter/material.dart';
import 'package:ai_tutor/services/api_service.dart';
import 'package:ai_tutor/models/course_models.dart';
import 'package:ai_tutor/content/content_preview_page.dart';
import 'package:ai_tutor/content/document_upload_page.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/focus_aware_background.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({super.key});

  @override
  State<GeneratePage> createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  String? _selectedOption;
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  late TextEditingController _topicController;

  @override
  void initState() {
    super.initState();
    _topicController = TextEditingController();
  }

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _showDropUpMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(60, 0, 0, 0),
      isDismissible: true,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuItem('Upload Document', Icons.description_outlined, () {
                Navigator.pop(context);
                // Use pushReplacement to avoid stacking screens
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DocumentUploadPage()),
                );
              }),
              _buildMenuItem('Upload Presentation', Icons.slideshow_outlined,
                  () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Presentation upload coming soon')),
                );
              }),
              _buildMenuItem('Upload Image', Icons.image_outlined, () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image upload coming soon')),
                );
              }),
              _buildMenuItem('Take an Image', Icons.photo_camera_outlined, () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Camera feature coming soon')),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(String text, IconData icon,
      [Function()? onTapOverride]) {
    final isSelected = _selectedOption == text;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.grey[600],
          ),
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isSelected
            ? const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 20,
              )
            : null,
        onTap: onTapOverride ??
            () {
              setState(() {
                _selectedOption = text;
              });
              Navigator.pop(context);
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FocusAwareBackground(
        primaryColor: Colors.blue.shade400,
        secondaryColor: Colors.blue.shade600,
        opacity: 0.03,
        enableWaves: true,
        enableParticles: true,
        child: SafeArea(
          child: Column(
            children: [
              const AppHeader(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      // Grey container with edit icon
                      Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.edit_outlined,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'What is your favorite topic?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Ask HexaElite AI row with selection indicator
                      Row(
                        children: [
                          const Icon(
                            Icons.star_border_rounded,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Ask HexaElite AI',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          if (_selectedOption != null)
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        _selectedOption!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedOption = null;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            size: 12,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          GestureDetector(
                            onTap: () => _showDropUpMenu(context),
                            child: Row(
                              children: [
                                Text(
                                  'Show more',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Input field
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _topicController,
                          decoration: InputDecoration(
                            hintText: 'Enter your Topic...',
                            hintStyle: TextStyle(
                              color: Colors.grey[
                                  400], // Adjusted for better visibility on grey[100]
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Action buttons above bottom navigation
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Home button
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.home_outlined,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Grid button
                            GestureDetector(
                              onTap: () => _showDropUpMenu(context),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.grid_view_outlined,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Generate Now button
                            Expanded(
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _isLoading
                                        ? null
                                        : () async {
                                            if (_topicController.text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Please enter a topic')),
                                              );
                                              return;
                                            }

                                            setState(() {
                                              _isLoading = true;
                                            });

                                            final request = CourseRequest(
                                              title: _topicController.text,
                                              description:
                                                  "A comprehensive course on ${_topicController.text}",
                                              targetAudience: "Beginners",
                                              timeAvailable: "1 week",
                                              preferredFormat:
                                                  "Text-based modules",
                                              learningObjectives: [],
                                            );

                                            try {
                                              final courseResponse =
                                                  await _apiService
                                                      .planCourse(request);
                                              // Navigate to ContentPreviewPage with courseResponse
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ContentPreviewPage(
                                                          courseData:
                                                              courseResponse),
                                                ),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Failed to plan course: $e')),
                                              );
                                            } finally {
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            }
                                          },
                                    borderRadius: BorderRadius.circular(22),
                                    child: _isLoading
                                        ? const Center(
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Generate Now',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: const Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
