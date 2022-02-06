import 'package:hooks_riverpod/hooks_riverpod.dart';

class _SpeechTextProvider extends StateNotifier<String> {
  _SpeechTextProvider() : super('Press the button to start transcription');

  set text(String val) => state = val;
  String get text => state;
}

final speechTextRef =
    StateNotifierProvider<_SpeechTextProvider, String>((_) => _SpeechTextProvider());
