import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'auth/login_page.dart';
import 'widgets/animated_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase for web
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA8zSt_0YNcx6wt5ycWYclol1N-r8CJawk",
        authDomain: "bettingbot-b585b.firebaseapp.com",
        projectId: "bettingbot-b585b",
        storageBucket: "bettingbot-b585b.firebasestorage.app",
        messagingSenderId: "117923418172",
        appId: "1:117923418172:web:820026f15c25d239f1b339",
        measurementId: "G-XCFD38EMSH",
      )
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HexaElite AI Tutor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Base background image
          Positioned.fill(
            child: Image.asset(
              'assets/mountain_bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Dark gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          // Animated background overlay
          Positioned.fill(
            child: AnimatedBackground(
              primaryColor: Colors.blue.shade400.withOpacity(0.3),
              secondaryColor: Colors.blue.shade800.withOpacity(0.3),
              opacity: 0.05,
              enableWaves: true,
              enableParticles: true,
              child: const SizedBox.expand(),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 50),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.blue.shade500,
                              Colors.blue.shade100,
                            ],
                          ).createShader(bounds),
                          child: const Text(
                            'HexaElite',
                            style: TextStyle(
                              fontSize: 54,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'AI Tutor',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.blue.shade200,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(209, 66, 164, 245)
                              .withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/hexaelite_logo.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
                const Spacer(),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'Plan your',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue.shade100,
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.blue.shade600,
                            Colors.blue.shade200,
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'Study',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'with',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue.shade100,
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.blue.shade400, Colors.blue.shade100],
                        ).createShader(bounds),
                        child: const Text(
                          'HexaElite AI Tutor',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade500,
                            Colors.blue.shade200,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade700.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Explore',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
