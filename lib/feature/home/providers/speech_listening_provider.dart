import 'package:hooks_riverpod/hooks_riverpod.dart';

class _SpeechListeningProvider extends StateNotifier<bool> {
  _SpeechListeningProvider() : super(false);

  set listening(bool val) => state = val;
  bool get listening => state;
}

final speechListeningRef = StateNotifierProvider<_SpeechListeningProvider, bool>(
    (_) => _SpeechListeningProvider());
