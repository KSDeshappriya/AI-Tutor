import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/animated_background.dart';

class ResultPage extends StatelessWidget {
  final String section;
  final int score;
  final int totalQuestions;

  const ResultPage({
    Key? key,
    required this.section,
    required this.score,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double percentage =
        totalQuestions > 0 ? (score / totalQuestions) * 100 : 0;

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
            children: [
              const AppHeader(),
              Expanded(
                child: _buildCongratulationsCard(context, percentage),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildCongratulationsCard(BuildContext context, double percentage) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          children: [
            // Stars with percentage
            _buildStarsWithPercentage(percentage),

            const SizedBox(height: 24),

            // Message
            Text(
              'Congratulations! You got ${percentage.toInt()}% on the ${section} quiz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

            // Score details
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Score:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$score / $totalQuestions',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: totalQuestions > 0 ? score / totalQuestions : 0,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.blue,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Certificate generation text
            Text(
              'Click here to Generate Your Certificate',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            // Generate certificate button
            Container(
              width: 220,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(25),
              ),
              child: InkWell(
                onTap: () {
                  // Add certificate generation logic here
                },
                borderRadius: BorderRadius.circular(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Generate Certificate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Back to lesson button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.book_outlined),
              label: const Text('Back to Lessons'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.blue.shade700,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStarsWithPercentage(double percentage) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((0.2 * 255).toInt()),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          // Percentage and stars
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Custom star design with SVG-like approach
              SizedBox(
                width: 200,
                height: 100,
                child: CustomPaint(
                  painter: StarsPainter(),
                ),
              ),

              // Percentage
              Text(
                "${percentage.toInt()}%",
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4285F4), // Google blue color
                ),
              ),

              // Congratulation text
              const Text(
                "Congratulations",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4285F4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for drawing the stars in a circular pattern
class StarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Calculate center point
    final center = Offset(size.width / 2, size.height / 2);

    // Determine radiuses
    final outerRadius = size.width * 0.4;
    final innerRadius = size.width * 0.2;

    // Paint for the stars and lines
    final Paint paint = Paint()
      ..color = const Color(0xFFFFC107) // Material amber color
      ..style = PaintingStyle.fill;

    // Draw the stars and lines
    for (int i = 0; i < 5; i++) {
      final double angle = i * 2 * math.pi / 5;

      // Calculate star position
      final double starX = center.dx + outerRadius * math.cos(angle);
      final double starY = center.dy + outerRadius * math.sin(angle);

      // Draw line from center to star
      canvas.drawLine(
        Offset(center.dx + innerRadius * math.cos(angle),
            center.dy + innerRadius * math.sin(angle)),
        Offset(starX, starY),
        Paint()
          ..color = const Color(0xFFFFC107)
          ..strokeWidth = 2,
      );

      // Draw star
      _drawStar(canvas, Offset(starX, starY), size.width * 0.05, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();

    for (int i = 0; i < 5; i++) {
      final double outerAngle = i * 2 * math.pi / 5 - math.pi / 2;
      final double innerAngle = (i + 0.5) * 2 * math.pi / 5 - math.pi / 2;

      if (i == 0) {
        path.moveTo(
          center.dx + size * math.cos(outerAngle),
          center.dy + size * math.sin(outerAngle),
        );
      } else {
        path.lineTo(
          center.dx + size * math.cos(outerAngle),
          center.dy + size * math.sin(outerAngle),
        );
      }

      path.lineTo(
        center.dx + size * 0.4 * math.cos(innerAngle),
        center.dy + size * 0.4 * math.sin(innerAngle),
      );
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
