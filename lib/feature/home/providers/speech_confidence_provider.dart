import 'package:hooks_riverpod/hooks_riverpod.dart';

class _SpeechConfidenceProvider extends StateNotifier<double> {
  _SpeechConfidenceProvider() : super(1);

  set confidence(double val) => state = val % 1;
  double get confidence => state;
}

final speechConfidenceRef = StateNotifierProvider<_SpeechConfidenceProvider, double>(
    (_) => _SpeechConfidenceProvider());
