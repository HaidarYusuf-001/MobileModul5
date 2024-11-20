import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/course_controller.dart';

class CourseView extends StatelessWidget {
  const CourseView({super.key});

  @override
  Widget build(BuildContext context) {
    final CourseController controller = Get.put(CourseController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image and back button
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/piano.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(1),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 17, 31, 44),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title with bookmark icon
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Guitar Pattern to Improve Your Muscle Memory',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFEBEBEB),
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.bookmark_border,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Author and Music category side by side
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                        AssetImage('assets/images/author_avatar.png'),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Richard Bustos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFFA4A4A4),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF3E6F7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Music',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFA58F0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Published and Enrolled centered
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit_calendar_outlined,
                                color: Color.fromARGB(255, 17, 31, 44)),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Published',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '18 March 2022',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.people_outlined,
                                color: Color.fromARGB(255, 17, 31, 44)),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Enrolled',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '1,579 Peoples',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Dive Deep into the Fundamentals of Design Principles...',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFA4A4A4)),
                  ),
                  SizedBox(height: 40),
                  // Courses Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Courses',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '(12 sections ~ 7 hours 34 minutes)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFA4A4A4),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Text('01.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Design Hierarchy:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Hik's Law Approach",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(Icons.lock_outline, color: Color(0xFFA4A4A4)),
                  ),
                  SizedBox(height: 16),
                  // Audio Player Section
                  Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Audio Player',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (controller.currentAudioTitle.isNotEmpty)
                        Text(
                          'Playing: ${controller.currentAudioTitle.value}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.audioList.length,
                        itemBuilder: (context, index) {
                          final audio = controller.audioList[index];
                          return ListTile(
                            title: Text(audio['title']!),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.play_arrow,
                                color: controller.currentAudioTitle.value ==
                                    audio['title']
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                controller.playAudio(
                                  audio['file']!,
                                  audio['title']!,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      if (controller.isPlaying.value)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.pause),
                                  onPressed: controller.pauseAudio,
                                ),
                                IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  onPressed: controller.resumeAudio,
                                ),
                              ],
                            ),
                            Slider(
                              value: controller.position.value.inSeconds.toDouble(),
                              min: 0,
                              max: controller.duration.value.inSeconds.toDouble(),
                              onChanged: (value) {
                                controller.seekAudio(Duration(seconds: value.toInt()));
                              },
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: controller.stopAudio,
                          child: Text('Stop Audio'),
                        ),
                    ],
                  )),
                  SizedBox(height: 45),
                  // Price and Buy button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Price',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Rp190.000',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 17, 31, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text('Buy Course',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
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
}
