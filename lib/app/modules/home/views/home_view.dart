import 'package:codingaja/app/modules/home/controllers/microphone_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../register/controllers/auth_controller.dart';
import '../../todo/views/todo_view.dart';
import '/app/modules/course/views/course_view.dart';
import '../controllers/home_controller.dart';
import '/app/modules/profile/views/profile_view.dart';
import '/app/modules/history/views/history_view.dart';
import '/app/modules/http_screen/views/http_view.dart';

class HomeView extends GetView<MicrophoneController> {
  // Declare the TextEditingController
  final TextEditingController _controller = TextEditingController();
  final authController = Get.find<AuthController>();
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengupdate _controller text setiap ada perubahan pada controller.text
    controller.text.listen((value) {
      _controller.text = value;
      _controller.selection = TextSelection.collapsed(
          offset: value.length);
    }
    );// Menjaga kursor tetap di akhir
    // Get AuthController instance

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(authController), // Pass authController
    );


  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(250),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 17, 31, 44),
        elevation: 0,
        flexibleSpace: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: _buildGreetingSection(),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: _buildOngoingCard(),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildGreetingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning,',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kevin Juliette 👋',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.notifications,
                color: const Color.fromARGB(255, 17, 31, 44),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Card _buildOngoingCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 15, 18, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        16), // Sesuaikan nilai ini untuk sudut yang tidak terlalu bulat
                    child: Image.asset(
                      'assets/images/course.jpeg',
                      height: 55,
                      width: 55,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _buildCourseInfo(),
              ],
            ),
            _buildProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Column _buildCourseInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Ongoing',
            style: TextStyle(
              color: Color.fromARGB(255, 17, 31, 44),
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Programming in Industry',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'by Abdul Sanchez',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Stack _buildProgressIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            value: 0.73,
            strokeWidth: 6,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color.fromARGB(255, 17, 31, 44),
            ),
            backgroundColor: Colors.grey[300],
          ),
        ),
        const Text(
          '73%',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        TextField(
        controller: _controller, // Pastikan _controller adalah TextEditingController
        decoration: InputDecoration(
          hintText: 'Cari sesuatu dengan suara...',
          prefixIcon: IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () async {
              if (controller.isListening.value) {
                // Jika sedang mendengarkan, hentikan mendengarkan
                controller.stopListening();
              } else {
                // Mulai mendengarkan ketika tombol mikrofon ditekan
                await controller.startListening();
              }
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) {
          // Memastikan controller.text adalah Rx<String> jika menggunakan GetX
          controller.text.value = value;
        },
      ),
          const SizedBox(height: 18.0),
          Expanded(
            child: ListView(
              children: [
                _buildMenuRow(
                  ['Coding', Icons.code],
                  ['Business', Icons.business],
                  ['Math', Icons.calculate],
                  ['Arts', Icons.brush],
                ),
                const SizedBox(height: 20),
                _buildMenuRow(
                  ['Music', Icons.music_note],
                  ['Book', Icons.book],
                  ['E-Sport', Icons.sports_esports],
                  ['More', Icons.more_horiz],
                ),
                const SizedBox(height: 25),
                _buildRecommendedCourses(),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Row _buildMenuRow(List<dynamic> item1, List<dynamic> item2,
      List<dynamic> item3, List<dynamic> item4) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMenuButton(item1[0] as String, item1[1] as IconData),
        _buildMenuButton(item2[0] as String, item2[1] as IconData),
        _buildMenuButton(item3[0] as String, item3[1] as IconData),
        _buildMenuButton(item4[0] as String, item4[1] as IconData),
      ],
    );
  }

  Widget _buildMenuButton(String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            // if (label == 'Coding') {
            //   Get.to(() => {});
            // } else if (label == 'Business') {
            //   Get.to(() => {});
            // } else if (label == 'Math') {
            //   Get.to(() => {});
            // } else if (label == 'Arts') {
            //   Get.to(() => {});
            // } else
            if (label == 'Music') {
              Get.to(() => CourseView());
            }
            if (label == 'Book') {
              Get.to(() => HttpView());
            }
            if (label == 'Business') {
              Get.to(() => TodoView());
            }
            // Tambahkan navigasi ke page lain sesuai kebutuhan
          },
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 30,
              color: Color.fromARGB(255, 17, 31, 44),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Column _buildRecommendedCourses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended for You',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 230,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildCourseCard(
                'UI/UX Design : User Centered Method',
                'Creative Arts',
                4.7,
                306,
                'assets/images/bg1.jpg',
              ),
              _buildCourseCard(
                'Guitar Pattern for Muscle Memory',
                'Music',
                4.8,
                215,
                'assets/images/bg2.jpeg',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildCourseCard(String title, String category, double rating,
      int reviews, String imagePath) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color.fromARGB(255, 17, 31, 44),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 5),
                    Text(
                      '$rating ($reviews reviews)',
                      style: const TextStyle(fontSize: 12),
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

  BottomNavigationBar _buildBottomNavigationBar(AuthController authController) {
    final AuthController authController = Get.find();
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        // Navigasi menggunakan if-else
        if (index == 0) {
          authController.logout();
        } else if (index == 1) {
          Get.to(() => HistoryView());
        } else if (index == 2) {
          Get.to(() => ProfileView());
        }
      },
    );
  }
}
