import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text("History", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(
              255, 17, 31, 44), // Set AppBar background color to blue
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context); // Handle back button press
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              onPressed: () {
                // Handle profile icon press
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: TabBar(
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 4.0,
                      color: Color.fromARGB(255, 17, 31, 44),
                    ), // Blue line below the tab
                    insets: EdgeInsets.zero, // No padding around the line
                  ),
                  tabs: [
                    Tab(text: 'All'),
                    Tab(text: 'Arts'),
                    Tab(text: 'Music'),
                    Tab(text: 'Other'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            CourseList(), // Widget for "All" courses
            CourseList(), // Widget for "Arts" courses
            CourseList(), // Widget for "Music" courses
            CourseList(), // Widget for "Other" courses
          ],
        ),
      ),
    );
  }
}

// Dummy course list for the tabs
class CourseList extends StatelessWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        CourseCard(
          imageUrl:
              'https://business-portal-bucket.s3.amazonaws.com/media/images/41e172c318357d632f53b92d8cb38661_large_cover.original.jpg',
          title: 'DOTA 2: Laning Phase 101',
          category: 'E-Sport',
          instructor: 'Clarissa',
          rating: 4.7,
          reviews: 306,
          progress: 100,
          totalSessions: 10,
        ),
        CourseCard(
          imageUrl:
              'https://s3-publishing-cmn-svc-prd.s3.ap-southeast-1.amazonaws.com/article/quiNaaM39JvDVkapk_3aL/original/040264200_1559039725-Anak-Belajar-Piano-Saat-Libur-Lebaran-Ini-Manfaatnya-By-Romrodphoto-Shutterstock.jpg',
          title: 'How To Play Piano',
          category: 'Music',
          instructor: 'Sabdul Agym',
          rating: 4.9,
          reviews: 560,
          progress: 100,
          totalSessions: 10,
        ),
      ],
    );
  }
}

// CourseCard widget for displaying individual courses
class CourseCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String category;
  final String instructor;
  final double rating;
  final int reviews;
  final int progress;
  final int totalSessions;

  const CourseCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.category,
    required this.instructor,
    required this.rating,
    required this.reviews,
    required this.progress,
    required this.totalSessions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'by $instructor',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Spacer(),
                    Text(
                      category,
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '$rating/5.0 • $reviews Reviews',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: Colors.grey[200],
                  color: const Color.fromARGB(255, 17, 31, 44),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$progress%'),
                    Text('Sessions: $progress/$totalSessions'),
                  ],
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle continue course press
                    },
                    child: Text(
                      'Continue Course',
                      style: TextStyle(
                        color: Color.fromARGB(255, 17, 31, 44),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
