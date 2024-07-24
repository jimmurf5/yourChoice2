import 'package:your_choice/services/profile_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider to access the profileFirestoreService
final profileFireStoreServiceProvider = Provider<ProfileFirestoreService>((ref) {
  return ProfileFirestoreService();
});

//StateNotifierProvider to manage the colour state for a specific profile
//returns a profile notifier instance
final profileColoursProvider = StateNotifierProvider.family<ProfileColoursNotifier, Color, String>((ref, profileId){
  final firestoreService = ref.watch(profileFireStoreServiceProvider);
  return ProfileColoursNotifier(firestoreService, profileId);
});

//stateNotifier class to manage profile colours
class ProfileColoursNotifier extends StateNotifier<Color> {
  final ProfileFirestoreService firestoreService;
  final String profileId;

  // Constructor to initialize the state with a default color and load the color from Firestore
  ProfileColoursNotifier(this.firestoreService, this.profileId) : super(Colors.blue) {
    _loadProfileColour();
  }

  // Method to load the profile color from Firestore
  Future<void> _loadProfileColour() async {
    Color? color = await firestoreService.getProfileColor(profileId);
    state = color ?? Colors.blue; // Use the color from Firestore or default to blue
  }

  // Method to update the profile colour in Firestore
  Future<void> updateProfileColour(Color color) async {
    state = color;
    await firestoreService.updateProfileColour(profileId, color);
  }

  //public method to load the colour and return it
Future<Color> fetchProfileColour() async {
    await _loadProfileColour();
    return state;
}
}