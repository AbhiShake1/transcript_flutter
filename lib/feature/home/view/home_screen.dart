import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:transcript_flutter/feature/home/providers/speech_providers.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SpeechToText speech = SpeechToText();
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
          onPressed: () => _listen(context, speech),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: HookConsumer(
            builder: (context, ref, child) => Text(
              ref.watch(speechTextRef),
              style: const TextStyle(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _listen(BuildContext context, SpeechToText speech) async {
    final ref = ProviderScope.containerOf(context);
    if (!ref.read(speechListeningRef)) {
      bool available = await speech.initialize();
      if (available) {
        ref.read(speechListeningRef.notifier).listening = true;
        speech.listen(onResult: (val) {
          ref.read(speechTextRef.notifier).text = val.recognizedWords;
          if (val.hasConfidenceRating && val.confidence > 0) {
            ref.read(speechConfidenceRef.notifier).confidence = val.confidence;
          }
        });
      }
    } else {
      ref.read(speechListeningRef.notifier).listening = false;
      speech.stop();
    }
  }
}
