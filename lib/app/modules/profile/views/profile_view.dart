import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
            buildFriendList(),
          ],
        ),
      ),
    );
  }

  // Method untuk membuat AppBar
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF111F2C),
      toolbarHeight: 80,
      title: const Text(
        'Profile',
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white
        ),
      ),
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white), // Mengubah warna tombol back menjadi putih
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

  // Method untuk menampilkan opsi pemilihan gambar
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
          buildTextField(label: 'Alamat', hint: 'Masukkan alamat!'),
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

  // Method untuk membuat TextField
  Widget buildTextField({required String label, required String hint}) {
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

  // Method untuk membuat daftar teman
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

  // Method untuk membangun avatar teman
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
}
