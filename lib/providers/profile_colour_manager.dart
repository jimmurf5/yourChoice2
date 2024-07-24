import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:your_choice/notifiers/theme_notifier.dart';
import 'package:your_choice/providers/profile_colours_notifier.dart';

//provider to create an instance of the ProfileColourManager
final profileColourManagerProvider = Provider<ProfileColourManager>((ref) {
  return ProfileColourManager(ref);
});

class ProfileColourManager {
  //declare an object to allow this provider to interact with other providers
  final ProviderRef ref;

  //constructor for ProfileColourManager
  ProfileColourManager(this.ref);

  //method to handle profile colour selection and theme update
  Future<void> selectProfileColour(String profileId) async {
    //load the profile colour from firebase for the provided profileId
    //and update the profile colour state using profileColoursProvider
    final profileColour = await ref.read(profileColoursProvider(profileId).notifier).fetchProfileColour();

    //update the global theme colour with the profile colour
    //using the themeNotifierProvider
    ref.read(themeNotifierProvider.notifier).updateSeedColour(profileColour);
  }
}