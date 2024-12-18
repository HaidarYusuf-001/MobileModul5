import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';

import 'location_page.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _image;
  final TextEditingController _alamatController = TextEditingController();
  late double latitude;
  late double longitude;

  final double latTempatLes = -7.920662;
  final double lonTempatLes = 112.593743;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        setState(() {
          _alamatController.text = address; // Memasukkan alamat ke TextField
        });
      }
    } catch (e) {
      print("Gagal mendapatkan alamat: $e");
    }
  }

  void _openGoogleMaps() async {
    final String googleMapsUrl = "https://www.google.com/maps?q=$latitude,$longitude";
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not open Google Maps';
    }
  }

  void _openGoogleMapsTempatLes() async {
    final String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&origin=$latitude,$longitude&destination=$latTempatLes,$lonTempatLes";
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not open Google Maps';
    }
  }


  // Update bagian untuk menampilkan halaman LocationPage dan mengirimkan lokasi ke field Alamat
  void _openLocationPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPage(
          onLocationSelected: (location) {
            setState(() {
              _alamatController.text = location;
              final coordinates = location.split(",");
              latitude = double.parse(coordinates[0]);
              longitude = double.parse(coordinates[1]);
            });
          },
        ),
      ),
    );
    await _getAddressFromCoordinates();
  }

  

  // Menghitung jarak antara dua titik menggunakan rumus Haversine
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Radius bumi dalam km
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLon / 2) * sin(dLon / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = R * c; // Dalam km
    return distance;
  }

  // Mengubah derajat ke radian
  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  // Fungsi untuk menampilkan jarak ke Universitas Brawijaya
  void _showDistanceToTempatLes() {
    double distance = _calculateDistance(latitude, longitude, latTempatLes, lonTempatLes);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Jarak ke Tempat Les'),
          content: Text('Jarak Anda saat ini ke Tempat Les adalah: ${distance.toStringAsFixed(2)} km'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildProfileHeader(),
            const SizedBox(height: 30),
            buildProfileForm(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF111F2C),
      toolbarHeight: 80,
      title: const Text(
        'Profile',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  // Method untuk membuat Header Profil
  Widget buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF111F2C),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 4,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : const AssetImage('assets/images/yy.png') as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showImagePickerOptions(context),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        );
      },
    );
  }

  // Method untuk membuat Form Profil
  Widget buildProfileForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _showDistanceToTempatLes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111F2C),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'Hitung Jarak',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10), // Untuk memberikan jarak antara tombol
              Expanded(
                child: ElevatedButton(
                  onPressed: _openGoogleMapsTempatLes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111F2C),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'Lokasi tempat les',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Text(
            'Lengkapi Profil',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          buildTextField(label: 'Nama Lengkap', hint: 'Masukkan nama lengkap!'),
          const SizedBox(height: 15),
          buildTextField(label: 'Email', hint: 'Masukkan email!'),
          const SizedBox(height: 15),
          buildTextField(label: 'Username', hint: 'Masukkan username!'),
          const SizedBox(height: 15),
          buildTextField(label: 'Alamat', hint: 'Masukkan alamat!', controller: _alamatController),
          const SizedBox(height: 5),
          // Cari Lokasi Saya button
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _openLocationPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111F2C),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'Track using AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: ElevatedButton(
                  onPressed: _openGoogleMaps,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111F2C),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 8,
                  ),
                  child: const Text(
                    'View on Gmaps',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          buildTextField(label: 'Umur', hint: 'Masukkan umur!'),
          const SizedBox(height: 15),
          buildTextField(label: 'Institusi', hint: 'Masukkan institusi!'),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Save logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF111F2C),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 8,
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildTextField({required String label, required String hint, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Color(0xFF1C5D99), width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


Widget buildFriendList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Temanmu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              buildFriendAvatar('assets/images/yy.png', 'Han'),
              buildFriendAvatar('assets/images/yy.png', 'Han'),
              buildFriendAvatar('assets/images/yy.png', 'Han'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFriendAvatar(String imagePath, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage(imagePath),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
