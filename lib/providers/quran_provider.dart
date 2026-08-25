import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:islamic_app/models/surah_model.dart';
import 'package:islamic_app/services/quran_service.dart';

enum QuranLoadStatus { idle, loading, ready, error }

class QuranProvider extends ChangeNotifier {
  final QuranService _service;
  final AudioPlayer _audioPlayer;

  StreamSubscription? _playerStateSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _completeSub;

  QuranProvider({QuranService? service, AudioPlayer? audioPlayer})
      : _service = service ?? QuranService(),
        _audioPlayer = audioPlayer ?? AudioPlayer() {
    _initAudio();
  }

  static const _bookmarksKey = 'quran_bookmarked_ayahs';
  static const _lastSurahKey = 'quran_last_selected_surah';

  QuranLoadStatus surahListStatus = QuranLoadStatus.idle;
  QuranLoadStatus ayahsStatus = QuranLoadStatus.idle;
  String? errorMessage;

  List<SurahModel> allSurahs = [];
  List<SurahModel> filteredSurahs = [];

  SurahModel? currentSurah;
  List<AyahModel> currentAyahs = [];

  // Audio Playback State
  int? activeAyahNumber;
  bool isAudioPlaying = false;
  bool isAudioLoading = false;
  Duration audioPosition = Duration.zero;
  Duration audioDuration = Duration.zero;

  double get audioProgress {
    if (audioDuration.inMilliseconds <= 0) return 0.0;
    return (audioPosition.inMilliseconds / audioDuration.inMilliseconds)
        .clamp(0.0, 1.0);
  }

  final Set<String> _bookmarkedKeys = {};
  bool isBookmarked(AyahModel ayah) => _bookmarkedKeys.contains(ayah.key);

  void _initAudio() {
    _configureSpeakerAudio();

    _playerStateSub = _audioPlayer.onPlayerStateChanged.listen((state) {
      isAudioPlaying = state == PlayerState.playing;
      if (state == PlayerState.playing || state == PlayerState.paused) {
        isAudioLoading = false;
      }
      notifyListeners();
    });

    _positionSub = _audioPlayer.onPositionChanged.listen((pos) {
      audioPosition = pos;
      notifyListeners();
    });

    _durationSub = _audioPlayer.onDurationChanged.listen((dur) {
      audioDuration = dur;
      isAudioLoading = false;
      notifyListeners();
    });

    _completeSub = _audioPlayer.onPlayerComplete.listen((_) {
      isAudioPlaying = false;
      audioPosition = Duration.zero;
      notifyListeners();
      // Smoothly advance to the next Ayah in the Surah
      playNextAyah();
    });
  }

  Future<void> _configureSpeakerAudio() async {
    try {
      await AudioPlayer.global.setAudioContext(
        AudioContext(
          android: const AudioContextAndroid(
            isSpeakerphoneOn: true,
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioMode: AndroidAudioMode.normal,
          ),
          iOS: AudioContextIOS(
            category: AVAudioSessionCategory.playback,
            options: const {
              AVAudioSessionOptions.defaultToSpeaker,
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error setting speaker audio context: $e');
    }
  }

  Future<void> init() async {
    await _loadBookmarks();
    await fetchSurahList();
    final savedSurahNumber = await _loadLastSelectedSurah();
    // Default to last selected Surah from SharedPreferences, or Surah 18 (Al-Kahf) for first time.
    await fetchSurah(savedSurahNumber ?? 18);
  }

  Future<void> fetchSurahList() async {
    surahListStatus = QuranLoadStatus.loading;
    notifyListeners();
    try {
      allSurahs = await _service.fetchSurahList();
      filteredSurahs = allSurahs;
      surahListStatus = QuranLoadStatus.ready;
    } catch (e) {
      errorMessage = e.toString();
      surahListStatus = QuranLoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> fetchSurah(int number) async {
    await stopAudio();
    activeAyahNumber = 1;
    ayahsStatus = QuranLoadStatus.loading;
    notifyListeners();
    try {
      currentAyahs = await _service.fetchSurahAyahs(number);
      currentSurah = allSurahs.isNotEmpty
          ? allSurahs.firstWhere(
              (s) => s.number == number,
              orElse: () => allSurahs.first,
            )
          : null;
      ayahsStatus = QuranLoadStatus.ready;
      await _saveLastSelectedSurah(number);
    } catch (e) {
      errorMessage = e.toString();
      ayahsStatus = QuranLoadStatus.error;
    }
    notifyListeners();
  }

  void searchSurahs(String query) {
    if (query.trim().isEmpty) {
      filteredSurahs = allSurahs;
    } else {
      final q = query.toLowerCase();
      filteredSurahs = allSurahs
          .where(
            (s) =>
                s.englishName.toLowerCase().contains(q) ||
                s.englishNameTranslation.toLowerCase().contains(q) ||
                s.name.contains(query) ||
                s.number.toString() == query,
          )
          .toList();
    }
    notifyListeners();
  }

  void selectAyah(int ayahNumber) {
    activeAyahNumber = ayahNumber;
    notifyListeners();
  }

  Future<void> playAyah(int ayahNumber) async {
    if (currentAyahs.isEmpty) return;

    final targetAyah = currentAyahs.firstWhere(
      (a) => a.numberInSurah == ayahNumber,
      orElse: () => currentAyahs.first,
    );

    activeAyahNumber = targetAyah.numberInSurah;
    isAudioLoading = true;
    audioPosition = Duration.zero;
    audioDuration = Duration.zero;
    notifyListeners();

    try {
      await _configureSpeakerAudio();
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(targetAyah.effectiveAudioUrl));
      isAudioPlaying = true;
    } catch (e) {
      isAudioLoading = false;
      isAudioPlaying = false;
      debugPrint('Error playing ayah audio: $e');
    }
    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (isAudioPlaying) {
      await pauseAudio();
    } else {
      if (audioPosition > Duration.zero &&
          audioDuration > Duration.zero &&
          !isAudioLoading) {
        await resumeAudio();
      } else {
        await playAyah(activeAyahNumber ?? 1);
      }
    }
  }

  Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
      isAudioPlaying = false;
    } catch (e) {
      debugPrint('Error pausing audio: $e');
    }
    notifyListeners();
  }

  Future<void> resumeAudio() async {
    try {
      await _configureSpeakerAudio();
      await _audioPlayer.resume();
      isAudioPlaying = true;
    } catch (e) {
      debugPrint('Error resuming audio: $e');
    }
    notifyListeners();
  }

  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (_) {}
    isAudioPlaying = false;
    isAudioLoading = false;
    audioPosition = Duration.zero;
    audioDuration = Duration.zero;
    notifyListeners();
  }

  Future<void> seekAudio(Duration position) async {
    try {
      await _audioPlayer.seek(position);
    } catch (e) {
      debugPrint('Error seeking audio: $e');
    }
  }

  Future<void> seekAudioProgress(double progress) async {
    if (audioDuration.inMilliseconds > 0) {
      final targetMs = (audioDuration.inMilliseconds * progress).round();
      await seekAudio(Duration(milliseconds: targetMs));
    }
  }

  Future<void> skipForward() async {
    if (audioDuration.inMilliseconds > 0) {
      final newPos = audioPosition + const Duration(seconds: 10);
      if (newPos >= audioDuration) {
        await playNextAyah();
      } else {
        await seekAudio(newPos);
      }
    } else {
      await playNextAyah();
    }
  }

  Future<void> skipBackward() async {
    if (audioPosition.inSeconds > 3) {
      await seekAudio(Duration.zero);
    } else {
      await playPreviousAyah();
    }
  }

  Future<void> playNextAyah() async {
    if (currentAyahs.isEmpty) return;
    final currentNum = activeAyahNumber ?? 1;
    final currentIndex =
        currentAyahs.indexWhere((a) => a.numberInSurah == currentNum);

    if (currentIndex != -1 && currentIndex + 1 < currentAyahs.length) {
      final nextAyah = currentAyahs[currentIndex + 1];
      await playAyah(nextAyah.numberInSurah);
    } else {
      await stopAudio();
    }
  }

  Future<void> playPreviousAyah() async {
    if (currentAyahs.isEmpty) return;
    final currentNum = activeAyahNumber ?? 1;
    final currentIndex =
        currentAyahs.indexWhere((a) => a.numberInSurah == currentNum);

    if (currentIndex > 0) {
      final prevAyah = currentAyahs[currentIndex - 1];
      await playAyah(prevAyah.numberInSurah);
    } else {
      await seekAudio(Duration.zero);
    }
  }

  Future<void> toggleBookmark(AyahModel ayah) async {
    if (_bookmarkedKeys.contains(ayah.key)) {
      _bookmarkedKeys.remove(ayah.key);
    } else {
      _bookmarkedKeys.add(ayah.key);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_bookmarksKey, _bookmarkedKeys.toList());
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    _bookmarkedKeys.addAll(prefs.getStringList(_bookmarksKey) ?? []);
  }

  Future<void> _saveLastSelectedSurah(int number) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSurahKey, number);
    } catch (_) {}
  }

  Future<int?> _loadLastSelectedSurah() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_lastSurahKey);
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _playerStateSub?.cancel();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _completeSub?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
