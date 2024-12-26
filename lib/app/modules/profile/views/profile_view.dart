import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
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
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _umurController = TextEditingController();
  final TextEditingController _institusiController = TextEditingController();

  late double latitude = 0.0;
  late double longitude = 0.0;

  final double latTempatLes = -7.920662;
  final double lonTempatLes = 112.593743;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _alamatController.dispose();
    _umurController.dispose();
    _institusiController.dispose();
    super.dispose();
  }

  Future<void> _saveProfileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Save text fields
      await prefs.setString('nama', _namaController.text);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('alamat', _alamatController.text);
      await prefs.setString('umur', _umurController.text);
      await prefs.setString('institusi', _institusiController.text);

      // Save coordinates
      await prefs.setDouble('latitude', latitude);
      await prefs.setDouble('longitude', longitude);

      // Save image path
      if (_image != null) {
        await prefs.setString('imagePath', _image!.path);
      }

      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error menyimpan profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadProfileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        _namaController.text = prefs.getString('nama') ?? '';
        _emailController.text = prefs.getString('email') ?? '';
        _usernameController.text = prefs.getString('username') ?? '';
        _alamatController.text = prefs.getString('alamat') ?? '';
        _umurController.text = prefs.getString('umur') ?? '';
        _institusiController.text = prefs.getString('institusi') ?? '';
        latitude = prefs.getDouble('latitude') ?? 0.0;
        longitude = prefs.getDouble('longitude') ?? 0.0;

        String? imagePath = prefs.getString('imagePath');
        if (imagePath != null && File(imagePath).existsSync()) {
          _image = File(imagePath);
        }
      });
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

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
          _alamatController.text = address;
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

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371;
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);
    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLon / 2) * sin(dLon / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = R * c;
    return distance;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

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
    const SizedBox(width: 10),
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
    buildCustomTextField('Nama Lengkap', 'Masukkan nama lengkap!', _namaController),
    const SizedBox(height: 15),
    buildCustomTextField('Email', 'Masukkan email!', _emailController),
    const SizedBox(height: 15),
    buildCustomTextField('Username', 'Masukkan username!', _usernameController),
    const SizedBox(height: 15),
    buildCustomTextField('Alamat', 'Masukkan alamat!', _alamatController),
    const SizedBox(height: 5),
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
          buildCustomTextField('Umur', 'Masukkan umur!', _umurController),
          const SizedBox(height: 15),
          buildCustomTextField('Institusi', 'Masukkan institusi!', _institusiController),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _saveProfileData,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF111F2C),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 8,
            ),
            child: const Text(
              'Simpan Profil',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomTextField(
      String labelText, String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}