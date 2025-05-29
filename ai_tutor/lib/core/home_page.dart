import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/animated_background.dart';
import '../content/generate_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  String _selectedCategory = 'Popular';
  int _currentIndex = 0;
  int _currentFeaturedIndex = 0;
  Timer? _featuredTimer;

  final List<Map<String, dynamic>> _featuredCourses = [
    {
      'title': 'Learn Ethical Hacking',
      'duration': '8 weeks',
      'rating': '4.8',
      'students': '2.5k',
      'icon': Icons.security,
    },
    {
      'title': 'Python Programming',
      'duration': '6 weeks',
      'rating': '4.9',
      'students': '3.2k',
      'icon': Icons.code,
    },
    {
      'title': 'Web Development',
      'duration': '10 weeks',
      'rating': '4.7',
      'students': '1.8k',
      'icon': Icons.web,
    },
    {
      'title': 'Mobile App Development',
      'duration': '12 weeks',
      'rating': '4.6',
      'students': '2.1k',
      'icon': Icons.phone_android,
    },
  ];

  final Map<String, GlobalKey> _sectionKeys = {
    'Popular': GlobalKey(),
    'Recommended': GlobalKey(),
    'New': GlobalKey(),
    'Adventure': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _startFeaturedTimer();
  }

  @override
  void dispose() {
    _featuredTimer?.cancel();
    super.dispose();
  }

  void _startFeaturedTimer() {
    _featuredTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _currentFeaturedIndex =
            (_currentFeaturedIndex + 1) % _featuredCourses.length;
      });
    });
  }

  void _scrollToSection(String category) {
    final key = _sectionKeys[category];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
      setState(() {
        _selectedCategory = category;
      });
    }
  }

  void _onNavTap(int index) {
    if (index == 1) {
      // Navigate to Generate page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GeneratePage()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerCard() {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCourse = _featuredCourses[_currentFeaturedIndex];

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeader(),
              const SizedBox(height: 16), // Breathing space
              // Featured Section with auto-rotation
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 1000),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: Container(
                    key: ValueKey<int>(_currentFeaturedIndex),
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Icon(
                            currentCourse['icon'],
                            size: 140,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Featured Course',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentCourse['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildFeatureItem(Icons.access_time,
                                          currentCourse['duration']),
                                      const SizedBox(width: 16),
                                      _buildFeatureItem(Icons.star,
                                          '${currentCourse['rating']} rating'),
                                      const SizedBox(width: 16),
                                      _buildFeatureItem(Icons.people,
                                          '${currentCourse['students']} students'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Additional breathing space
              // Search and Generate section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Find Topic',
                            hintStyle: TextStyle(
                                color: Colors.grey[400], fontSize: 14),
                            prefixIcon: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[200]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade400,
                              Colors.blue.shade700
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const GeneratePage()),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Generate',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.bolt,
                                    color: Colors.white,
                                    size: 16,
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
              const SizedBox(height: 20),
              SizedBox(
                height: 32,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildCategoryButton('Recommended'),
                    _buildCategoryButton('Popular'),
                    _buildCategoryButton('Top Search'),
                    _buildCategoryButton('New'),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    _buildSection(
                      'Recommended',
                      [
                        _buildAspenCard('Blockchain', ' Recommended',
                            'assets/course_img/blockchain.png', '5min'),
                        _buildAspenCard(
                            ' Bussiness Management',
                            ' Recommended',
                            'assets/course_img/bussinessmanagement.png',
                            '7min'),
                        _buildAspenCard('Cloud Engineering', ' Recommended',
                            'assets/course_img/cloudengineering.png', '4min'),
                      ],
                    ),
                    
                    _buildSection(
                      'Popular',
                      [
                        _buildLocationCard('Artificial Intelligence', '4.1',
                            'assets/course_img/ai.png'),
                        _buildLocationCard('Data Analysis', '4.5',
                            'assets/course_img/analysis.png'),
                        _buildLocationCard(
                            'Big Data', '4.3', 'assets/course_img/bigdata.png'),
                      ],
                    ),
                    
                    _buildSection(
                      'Top Search',
                      [
                        _buildLocationCard('Data Warehouse', '4.7',
                            'assets/course_img/datawarehouse.png'),
                        _buildLocationCard('Human Resource Management', '4.4',
                            'assets/course_img/hr.png'),
                        _buildLocationCard(
                            'IOT', '4.6', 'assets/course_img/iot.png'),
                      ],
                    ),
                    _buildSection(
                      'New',
                      [
                        _buildAspenCard('Network Management', 'New',
                            'assets/course_img/networkmanagement.png', '3min'),
                        _buildAspenCard('Network Engineering', 'New',
                            'assets/course_img/networkengineering.png', '2min'),
                        _buildAspenCard('Power BI', 'New',
                            'assets/course_img/powerbi.png', '4min'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildCategoryButton(String text) {
    final isSelected = _selectedCategory == text;
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: ElevatedButton(
        onPressed: () => _scrollToSection(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : const Color(0xFFF5F5F5),
          foregroundColor: isSelected ? Colors.white : Colors.black,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          minimumSize: const Size(0, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      key: _sectionKeys[title],
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add navigation to see all page
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'See all',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            itemBuilder: (context, index) => Container(
              width: 200,
              margin: EdgeInsets.only(right: index < items.length - 1 ? 12 : 0),
              child: items[index],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard(String title, String rating, String imagePath) {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 32,
                height: 32,
                child: IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    size: 16,
                  ),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAspenCard(
      String title, String label, String imagePath, String duration) {
    return AspectRatio(
      aspectRatio: 0.8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
