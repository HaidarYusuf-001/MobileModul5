import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class CourseController extends GetxController {
  // AudioPlayer instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Reactive variables to track playback status, duration, and position
  var isPlaying = false.obs;
  var isPaused = false.obs;
  var duration = Duration.zero.obs;
  var position = Duration.zero.obs;

  // Track current audio title
  var currentAudioTitle = ''.obs;

  // Audio list for demo purposes (replace with actual data)
  final audioList = [
    {'title': 'Relaxing Piano', 'file': 'audio/song1.mp3'},
    {'title': 'Guitar Melody', 'file': 'audio/song2.mp3'},
  ];

  @override
  void onInit() {
    super.onInit();

    // Listen for duration changes (total duration of the audio)
    _audioPlayer.onDurationChanged.listen((d) {
      duration.value = d;
    });

    // Listen for position changes (current position of the audio)
    _audioPlayer.onPositionChanged.listen((p) {
      position.value = p;
    });
  }

  @override
  void onClose() {
    _audioPlayer.dispose(); // Clean up when the controller is disposed
    super.onClose();
  }

  // Play audio from the given file (URL or asset)
  Future<void> playAudio(String file, String title) async {
    await _audioPlayer.play(AssetSource(file)); // Play from asset
    currentAudioTitle.value = title;
    isPlaying.value = true;
    isPaused.value = false;
  }

  // Pause audio
  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
    isPaused.value = true;
  }

  // Resume audio from where it was paused
  Future<void> resumeAudio() async {
    await _audioPlayer.resume();
    isPaused.value = false;
  }

  // Stop audio and reset position to the beginning
  Future<void> stopAudio() async {
    await _audioPlayer.stop();
    isPaused.value = false;
    position.value = Duration.zero;
    currentAudioTitle.value = '';
  }

  // Seek to a specific position in the audio
  void seekAudio(Duration newPosition) {
    _audioPlayer.seek(newPosition);
  }
}
