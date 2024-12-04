import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'background.dart'; // Import Background
class LocationPage extends StatefulWidget {
  final Function(String) onLocationSelected;

  const LocationPage({Key? key, required this.onLocationSelected}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _location = "Menunggu lokasi...";
  bool _isLoading = false; // Menandakan apakah sedang mencari lokasi
  late double latitude;
  late double longitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true; // Mulai proses loading
    });

    try {
      // Meminta izin lokasi
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        setState(() {
          _location = "Izin lokasi ditolak!";
          _isLoading = false; // Selesai proses loading
        });
        return;
      }

      // Mendapatkan lokasi saat ini
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;

      // Mendapatkan alamat berdasarkan koordinat
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      String address = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

      setState(() {
        _location = "Lat: $latitude, Lon: $longitude\nAlamat: $address";
        _isLoading = false; // Selesai proses loading
      });

      // Mengirim lokasi kembali ke halaman profil
      widget.onLocationSelected("$latitude,$longitude, $address");
    } catch (e) {
      setState(() {
        _location = "Gagal mendapatkan lokasi: $e";
        _isLoading = false; // Selesai proses loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF111F2C),
        title: const Text("Lokasi Saya"),
        centerTitle: true,
      ),
      body: Background(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Menambahkan Card untuk informasi lokasi
              Card(
                elevation: 5, // Elevasi untuk bayangan standar
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // Warna bayangan
                        spreadRadius: 2, // Jarak penyebaran bayangan
                        blurRadius: 5, // Ukuran kabur bayangan
                         // Posisi bayangan (horizontal, vertical)
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _isLoading
                        ? const CircularProgressIndicator() // Indikator loading saat proses berjalan
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lokasi Anda saat ini:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _location,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 20),

                        // Menambahkan tulisan dan gambar "Apakah alamat ini benar?"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Apakah alamat ini benar?',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              'assets/images/notof.png', // Ganti dengan path gambar Anda
                              width: 20, // Ukuran gambar kecil
                              height: 20, // Ukuran gambar kecil
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Menambahkan tombol dengan ikon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Mengatur tombol agar terdistribusi
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context); // Kembali ke halaman profil
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF111F2C),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 8,
                              ),
                              icon: const Icon(
                                Icons.check, // Menggunakan ikon bawaan Flutter
                                color: Colors.white, // Warna ikon
                                size: 20, // Ukuran ikon
                              ),
                              label: const Text(
                                'Benar!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _isLoading ? null : _getCurrentLocation, // Nonaktifkan tombol saat loading
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1C7ED6),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                elevation: 8,
                              ),
                              icon: const Icon(
                                Icons.refresh, // Ikon refresh untuk mencari ulang
                                color: Colors.white,
                                size: 20,
                              ),
                              label: const Text(
                                'Cari Ulang',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),

    );
  }
}
