import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends StateNotifier<Color> {
  ThemeNotifier() : super(const Color.fromARGB(255, 63, 17, 177),); //default seed colour

  void updateSeedColour(Color newColour) {
    state = newColour;
  }

  final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, Color>((ref) {
    return ThemeNotifier();
  });
}