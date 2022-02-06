import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:transcript_flutter/feature/home/providers/speech_providers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final SpeechToText _speech;
  String _text = 'Press the button to start transcription';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: HookConsumer(
            builder: (context, ref, child) => Text(
                'Confidence: ${(ref.watch(speechConfidenceRef) * 100).toStringAsFixed(1)}%')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: HookConsumer(
        builder: (context, ref, child) => AvatarGlow(
          animate: ref.watch(speechListeningRef),
          glowColor: Theme.of(context).primaryColor,
          endRadius: 75,
          duration: const Duration(seconds: 2),
          repeatPauseDuration: const Duration(microseconds: 100),
          repeat: true,
          child: child!,
        ),
        child: FloatingActionButton(
          child: Icon(ProviderScope.containerOf(context).read(speechListeningRef)
              ? Icons.mic
              : Icons.mic_none),
          onPressed: _listen,
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: Text(
            _text,
            style: const TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void _listen() async {
    if (!ProviderScope.containerOf(context).read(speechListeningRef)) {
      bool available = await _speech.initialize();
      if (available) {
        ProviderScope.containerOf(context)
            .read(speechListeningRef.notifier)
            .listening = true;
        _speech.listen(
          onResult: (val) => setState(
            () {
              _text = val.recognizedWords;
              if (val.hasConfidenceRating && val.confidence > 0) {
                ProviderScope.containerOf(context)
                    .read(speechConfidenceRef.notifier)
                    .confidence = val.confidence;
              }
            },
          ),
        );
      }
    } else {
      ProviderScope.containerOf(context)
          .read(speechListeningRef.notifier)
          .listening = false;
      _speech.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
  }
}
