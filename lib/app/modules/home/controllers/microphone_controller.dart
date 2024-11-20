import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MicrophoneController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  var isListening = false.obs; // Status pendengaran
  var text = "".obs; // Teks hasil pengenalan suara

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  // Inisialisasi speech recognition
  void _initSpeech() async {
    try {
      bool available = await _speech.initialize();
      if (!available) {
        print("Speech recognition is not available.");
      }
    } catch (e) {
      print("Error initializing speech recognition: $e");
    }
  }

  // Memulai proses pengenalan suara
  Future<void> startListening() async {
    // Ubah menjadi Future<void>
    try {
      isListening.value = true;
      await _speech.listen(
        onResult: (result) {
          text.value = result.recognizedWords; // Simpan teks hasil pengenalan
        },
        listenFor: Duration(minutes: 1), // Durasi maksimal mendengarkan
        pauseFor:
        Duration(seconds: 100), // Berhenti otomatis jika tidak ada input
        onSoundLevelChange: (level) {
          print("Sound level: $level");
        },
      );
    } catch (e) {
      print("Error during listening: $e");
    }
  }

  // Menghentikan proses pengenalan suara
  Future<void> stopListening() async {
    // Ubah menjadi Future<void>
    isListening.value = false;
    await _speech.stop();
  }
}