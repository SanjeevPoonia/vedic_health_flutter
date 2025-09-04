import 'package:flutter/material.dart';
import 'package:vedic_health/views/appointments/membership/join_membership_screen.dart';

// Dummy Video and dummy data to match the image
class Video {
  final String title;
  final String imagePath;
  final String duration;
  final String instructor;

  Video({
    required this.title,
    required this.imagePath,
    required this.duration,
    required this.instructor,
  });
}

final List<Video> beginnerVideos = [
  Video(
    title: "Surya Namaskar: Practice",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Trataka Candle Meditation",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Surya Namaskar: Practice",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Trataka Candle Meditation",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Surya Namaskar: Practice",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Trataka Candle Meditation",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Surya Namaskar: Practice",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Trataka Candle Meditation",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
];

final List<Video> advantageVideos = [
  Video(
    title: "Trataka Candle Meditation",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
];
final List<Video> hathaVideos = [
  Video(
    title: "Surya Namaskar: Practice",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
];
final List<Video> powerVideos = [
  Video(
    title: "Surya Namaskar: Practice",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
];

// Main screen widget
class YogaClassesScreen extends StatefulWidget {
  const YogaClassesScreen({super.key});

  @override
  _YogaClassesScreenState createState() => _YogaClassesScreenState();
}

class _YogaClassesScreenState extends State<YogaClassesScreen> {
  String _selectedFilterKey = 'All classes';

  final List<String> _filterOptions = [
    'All classes',
    'Beginner Yoga',
    'Advantage Yoga',
    'Hatha Yoga',
    'Power Yoga',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),

            // Filter Chips Carousel
            _buildFilterChips(),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Conditionally show content based on the selected filter
                      if (_selectedFilterKey == 'All classes') ...[
                        _buildVideoSection(
                            "BEGINNER YOGA VIDEOS", beginnerVideos),
                        const SizedBox(height: 20),
                        _buildVideoSection(
                            "ADVANTAGE YOGA VIDEOS", advantageVideos),
                        const SizedBox(height: 20),
                        _buildMembershipBanner(),
                        const SizedBox(height: 20),
                        _buildVideoSection("HATHA YOGA VIDEOS", hathaVideos),
                        const SizedBox(height: 20),
                        _buildVideoSection("POWER YOGA VIDEOS", powerVideos),
                        const SizedBox(height: 20),
                      ] else if (_selectedFilterKey == 'Beginner Yoga') ...[
                        _buildBeginnerYogaGrid(),
                      ] else if (_selectedFilterKey == 'Advantage Yoga') ...[
                        _buildVideoSection(
                            "ADVANTAGE YOGA VIDEOS", advantageVideos),
                      ] else if (_selectedFilterKey == 'Hatha Yoga') ...[
                        _buildVideoSection("HATHA YOGA VIDEOS", hathaVideos),
                      ] else if (_selectedFilterKey == 'Power Yoga') ...[
                        _buildVideoSection("POWER YOGA VIDEOS", powerVideos),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios_new_sharp,
                  size: 17, color: Colors.black),
            ),
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    "Yoga Classes",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilterKey == filter;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterKey = filter;
                });
              },
              child: Chip(
                label: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor:
                    isSelected ? const Color(0xFFF38328) : Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide.none,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoSection(String title, List<Video> videos) {
    if (videos.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (title.toLowerCase().contains('beginner yoga')) {
                  setState(() {
                    _selectedFilterKey = 'Beginner Yoga';
                  });
                } else if (title.toLowerCase().contains('advantage yoga')) {
                  setState(() {
                    _selectedFilterKey = 'Advantage Yoga';
                  });
                } else if (title.toLowerCase().contains('hatha yoga')) {
                  setState(() {
                    _selectedFilterKey = 'Hatha Yoga';
                  });
                } else if (title.toLowerCase().contains('power yoga')) {
                  setState(() {
                    _selectedFilterKey = 'Power Yoga';
                  });
                }
              },
              child: const Text(
                "See all",
                style: TextStyle(
                  color: Color(0xFF5A89AD),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...videos.map((video) => _buildVideoCard(video)).toList(),
      ],
    );
  }

  // New widget for the Beginner Yoga grid layout
  Widget _buildBeginnerYogaGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "BEGINNER YOGA VIDEOS",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Implement "See all" functionality for Beginner Yoga
              },
              child: const Text(
                "See all",
                style: TextStyle(
                  color: Color(0xFF5A89AD),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8, // Adjust to fit the content well
          ),
          itemCount: beginnerVideos.length,
          itemBuilder: (context, index) {
            return _buildGridVideoCard(beginnerVideos[index]);
          },
        ),
      ],
    );
  }

  Widget _buildGridVideoCard(Video video) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.asset(
              video.imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF662A09),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${video.duration} min",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      " | ",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        video.instructor,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(Video video) {
    // Existing list-style video card, used for "All classes" view
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(video.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      video.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Learn sun salutations and focus on form, precision, breath and timing....",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "${video.duration} min",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF865940),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          " | ",
                          style: TextStyle(
                            color: Color(0xFF865940),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          video.instructor,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF865940),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const JoinMembershipScreen(),
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF38328),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Join our membership",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Choose now and start experiencing the full value of our community!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
