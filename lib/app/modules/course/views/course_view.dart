import 'package:flutter/material.dart';

import 'package:get/get.dart';

class CourseView extends StatelessWidget {
  const CourseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image and back button
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.4, // Menetapkan tinggi header
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/piano.jpeg', // Gambar dari assets
                      ),
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
                      color: Colors.white, // Warna background lingkaran
                    ),
                    padding: EdgeInsets.all(
                        1), // Padding untuk ruang di sekitar ikon
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 17, 31, 44),
                      ), // Warna ikon menjadi 4A6DFA
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
                            color: Color(0xFFEBEBEB), // Warna border lingkaran
                            width: 2, // Ketebalan garis lingkaran
                          ),
                        ),
                        padding: EdgeInsets.all(
                            8), // Padding untuk memberikan ruang di sekitar ikon
                        child: Icon(
                          Icons
                              .bookmark_border, // Menggunakan ikon bookmark outline
                          color: Colors.black, // Warna garis luar menjadi hitam
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Author and Music category side by side
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/author_avatar.png', // Gambar avatar dari assets
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Nama dan Music
                              Text(
                                'Richard Bustos',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFFA4A4A4),
                                ),
                              ),
                              SizedBox(width: 8), // Jarak antara nama dan Music
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4), // Padding di dalam kotak
                                decoration: BoxDecoration(
                                  color: Color(
                                      0xFFF3E6F7), // Warna background kotak
                                  borderRadius: BorderRadius.circular(
                                      4), // Corner radius 8
                                ),
                                child: Text(
                                  'Music',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Color(0xFFFA58F0), // Warna teks Music
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
                      // Published Section
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white, // Background putih
                          borderRadius:
                              BorderRadius.circular(20), // Corner radius 20
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_calendar_outlined,
                              color: Color.fromARGB(255, 17, 31, 44),
                            ), // Warna ikon
                            SizedBox(width: 8), // Jarak antara ikon dan teks
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
                      // Enrolled Section
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white, // Background putih
                          borderRadius:
                              BorderRadius.circular(20), // Corner radius 20
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.people_outlined,
                              color: Color.fromARGB(255, 17, 31, 44),
                            ), // Warna ikon
                            SizedBox(width: 8), // Jarak antara ikon dan teks
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
                    'Dive Deep into the Fundamentals of Design Principles, '
                    'Master the Latest Tools and Techniques, and Gain Insightful '
                    'Industry Perspectives from Seasoned Professionals.',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFA4A4A4)),
                  ),
                  SizedBox(height: 40),
                  // Course sections
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
                      SizedBox(
                          width:
                              8), // Jarak antara "Courses" dan jumlah sections
                      Text(
                        '(12 sections ~ 7 hours 34 minutes)', // Teks yang diletakkan di samping "Courses"
                        style: TextStyle(
                          fontSize: 14, // Ukuran teks diubah menjadi 14
                          color: Color(
                              0xFFA4A4A4), // Warna teks diubah menjadi #A4A4A4
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Text('01.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16)), // Menjaga penomoran
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Design Hierarchy:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14, // Ukuran font yang sama
                            color: Colors.black, // Warna yang sama
                          ),
                        ),
                        Text(
                          "Hik's Law Approach",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14, // Ukuran font yang sama
                            color: Colors.black, // Warna yang sama
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize:
                          MainAxisSize.min, // Menghindari pemborosan ruang
                      children: [
                        Row(
                          children: [
                            Icon(Icons.remove_red_eye_outlined,
                                size: 20,
                                color: Color(
                                    0xFFA4A4A4)), // Mengubah warna ikon play
                            SizedBox(width: 4),
                            Text('327',
                                style: TextStyle(
                                    color: Color(0xFFA4A4A4),
                                    fontSize:
                                        14)), // Warna teks 327 juga diubah
                          ],
                        ),
                        SizedBox(width: 60), // Jarak antara play dan lock icon
                        Icon(Icons.lock_outline,
                            color:
                                Color(0xFFA4A4A4)), // Mengubah warna ikon lock
                      ],
                    ),
                  ),
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
