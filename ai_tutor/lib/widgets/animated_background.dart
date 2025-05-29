import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final Color primaryColor;
  final Color secondaryColor;
  final bool enableParticles;
  final bool enableWaves;
  final double opacity;
  final bool isPaused; // New parameter to pause animations

  const AnimatedBackground({
    super.key,
    required this.child,
    this.primaryColor = const Color(0xFF2196F3),
    this.secondaryColor = const Color(0xFF1976D2),
    this.enableParticles = true,
    this.enableWaves = true,
    this.opacity = 0.05,
    this.isPaused = false, // Default to not paused
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late final AnimationController _controller1;
  late final AnimationController _controller2;
  late final AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _controller2 = AnimationController(
      duration: const Duration(seconds: 40),
      vsync: this,
    )..repeat(reverse: true);

    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void didUpdateWidget(AnimatedBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle pausing/resuming animations when isPaused changes
    if (widget.isPaused && !oldWidget.isPaused) {
      _controller1.stop();
      _controller2.stop();
      _particleController.stop();
    } else if (!widget.isPaused && oldWidget.isPaused) {
      _controller1.repeat();
      _controller2.repeat(reverse: true);
      _particleController.repeat();
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // When paused, we still show the background but without animation
    return Stack(
      children: [
        // Animated background
        Positioned.fill(
          child: AnimatedBuilder(
            animation: Listenable.merge(
                [_controller1, _controller2, _particleController]),
            builder: (context, child) {
              return CustomPaint(
                painter: _BackgroundPainter(
                  animation1: _controller1,
                  animation2: _controller2,
                  particleAnimation: _particleController,
                  primaryColor: widget.primaryColor,
                  secondaryColor: widget.secondaryColor,
                  enableParticles: widget.enableParticles && !widget.isPaused,
                  enableWaves: widget.enableWaves && !widget.isPaused,
                  opacity: widget.opacity,
                ),
              );
            },
          ),
        ),
        // Content
        widget.child,
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final Animation<double> animation1;
  final Animation<double> animation2;
  final Animation<double> particleAnimation;
  final Color primaryColor;
  final Color secondaryColor;
  final bool enableParticles;
  final bool enableWaves;
  final double opacity;

  _BackgroundPainter({
    required this.animation1,
    required this.animation2,
    required this.particleAnimation,
    required this.primaryColor,
    required this.secondaryColor,
    required this.enableParticles,
    required this.enableWaves,
    required this.opacity,
  }) : super(
            repaint:
                Listenable.merge([animation1, animation2, particleAnimation]));

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor.withOpacity(opacity),
          secondaryColor.withOpacity(opacity),
        ],
      ).createShader(Offset.zero & size);

    if (enableWaves) {
      _drawWaves(canvas, size, paint);
    }

    if (enableParticles) {
      _drawParticles(canvas, size);
    }
  }

  void _drawWaves(Canvas canvas, Size size, Paint paint) {
    final time1 = animation1.value;
    final time2 = animation2.value;

    final wave1Points = List.generate(
      size.width.toInt(),
      (x) {
        final normalizedX = x / size.width;
        final offset =
            math.sin(normalizedX * 2 * math.pi + time1 * 2 * math.pi) * 20.0;
        final y = size.height * 0.3 + offset;
        return Offset(x.toDouble(), y);
      },
    );

    final wave2Points = List.generate(
      size.width.toInt(),
      (x) {
        final normalizedX = x / size.width;
        final offset =
            math.cos(normalizedX * 3 * math.pi + time2 * 2 * math.pi) * 15.0;
        final y = size.height * 0.6 + offset;
        return Offset(x.toDouble(), y);
      },
    );

    // Draw waves
    _drawWavePath(canvas, size, wave1Points, paint);
    _drawWavePath(canvas, size, wave2Points, paint);
  }

  void _drawWavePath(
      Canvas canvas, Size size, List<Offset> points, Paint paint) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, points.first.dy);

    for (var i = 1; i < points.length - 2; i += 2) {
      final x1 = points[i].dx;
      final y1 = points[i].dy;
      final x2 = points[i + 1].dx;
      final y2 = points[i + 1].dy;
      path.quadraticBezierTo(x1, y1, x2, y2);
    }

    path
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawParticles(Canvas canvas, Size size) {
    final particleTime = particleAnimation.value;
    final particlePaint = Paint()
      ..color = primaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent pattern

    for (var i = 0; i < 50; i++) {
      final angle = (i * math.pi * 2 / 50) + (particleTime * math.pi * 2);
      final radius =
          (math.sin(particleTime * math.pi * 2 + i) + 1) * size.width / 4;

      final x = size.width / 2 + math.cos(angle) * radius;
      final y = size.height / 2 + math.sin(angle) * radius;

      final particleSize = 2.0 + random.nextDouble() * 3;
      canvas.drawCircle(Offset(x, y), particleSize, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) =>
      oldDelegate.animation1 != animation1 ||
      oldDelegate.animation2 != animation2 ||
      oldDelegate.particleAnimation != particleAnimation ||
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.enableParticles != enableParticles ||
      oldDelegate.enableWaves != enableWaves ||
      oldDelegate.opacity != opacity;
}
