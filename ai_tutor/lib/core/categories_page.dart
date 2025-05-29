import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/animated_background.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final _scrollController = ScrollController();
  String _selectedCategory = 'Recommended';
  int _currentIndex = 2; // Set to 2 for Categories tab

  final Map<String, GlobalKey> _sectionKeys = {
    'Recommended': GlobalKey(),
    'Popular': GlobalKey(),
    'Top Search': GlobalKey(),
    'New': GlobalKey(),
  };

  void _scrollToSection(String category) {
    final key = _sectionKeys[category];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      setState(() {
        _selectedCategory = category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // Search bar only
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Find Topic',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      prefixIcon:
                          Icon(Icons.search, color: Colors.grey, size: 20),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
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
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
