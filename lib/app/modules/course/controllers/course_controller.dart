import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class CourseController extends GetxController {
  final AudioPlayer audioPlayer = AudioPlayer(); // Objek utama audio player
  final audioList = [
    {'title': 'Relaxing Piano', 'file': 'audio/song1.mp3'},
    {'title': 'Guitar Melody', 'file': 'audio/song2.mp3'},
  ];

  final currentAudioTitle = ''.obs; // Untuk menampilkan judul audio yang diputar
  final isPlaying = false.obs; // Untuk mengetahui status pemutaran

  Future<void> playAudio(String file, String title) async {
    try {
      currentAudioTitle.value = title;
      await audioPlayer.stop(); // Hentikan audio sebelumnya jika ada
      await audioPlayer.play(AssetSource(file)); // Mainkan file dari asset
      isPlaying.value = true; // Set status menjadi playing
    } catch (e) {
      Get.snackbar('Error', 'Failed to play audio: $e');
    }
  }

  void stopAudio() async {
    await audioPlayer.stop(); // Hentikan audio
    isPlaying.value = false;
    currentAudioTitle.value = '';
  }

  @override
  void onClose() {
    audioPlayer.dispose(); // Hentikan dan bersihkan resource audio player
    super.onClose();
  }
}
