import 'package:flutter/material.dart';
import 'animated_background.dart';

class FocusAwareBackground extends StatefulWidget {
  final Widget child;
  final Color primaryColor;
  final Color secondaryColor;
  final bool enableParticles;
  final bool enableWaves;
  final double opacity;

  const FocusAwareBackground({
    super.key,
    required this.child,
    this.primaryColor = const Color(0xFF2196F3),
    this.secondaryColor = const Color(0xFF1976D2),
    this.enableParticles = true,
    this.enableWaves = true,
    this.opacity = 0.05,
  });

  @override
  State<FocusAwareBackground> createState() => _FocusAwareBackgroundState();
}

class _FocusAwareBackgroundState extends State<FocusAwareBackground> {
  bool _isPaused = false;
  final FocusNode _focusDetector = FocusNode();

  @override
  void initState() {
    super.initState();
    // Listen to global focus changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.addListener(_onFocusChange);
    });
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_onFocusChange);
    _focusDetector.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    // Check if any text field is focused
    final hasFocus = FocusManager.instance.primaryFocus?.hasFocus ?? false;
    final primaryFocusContext = FocusManager.instance.primaryFocus?.context;

    if (primaryFocusContext != null) {
      final isTextFieldFocused = primaryFocusContext.widget is EditableText ||
          primaryFocusContext.widget is TextField ||
          primaryFocusContext.widget is TextFormField;

      setState(() {
        _isPaused = isTextFieldFocused;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      primaryColor: widget.primaryColor,
      secondaryColor: widget.secondaryColor,
      enableParticles: widget.enableParticles,
      enableWaves: widget.enableWaves,
      opacity: widget.opacity,
      isPaused: _isPaused,
      child: widget.child,
    );
  }
}
