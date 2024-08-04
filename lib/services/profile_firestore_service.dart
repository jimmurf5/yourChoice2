import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A service class that handles Firestore operations related to profile colours,
/// specifically for getting and updating profile colors.
class ProfileFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetches the profile colour from Firestore for the given profile ID.
  ///
  /// This method retrieves the document for the specified profile, checks if
  /// the colour field exists, and returns it. If the colour field does not exist,
  /// a default colour is returned.
  ///
  /// [profileId] - The ID of the profile to fetch the color for.
  ///
  /// Returns a [Color] object representing the profile color.
  Future<Color> getProfileColor(String profileId) async {
    // Fetch the document for the profile
    DocumentSnapshot doc = await _db.collection('profiles').doc(profileId).get();
    // Check if the doc exists and contains the colour field
    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('colour')) {

        // Return the colour if it exists
        return Color(data['colour']);
      }
    }
    // Return a default colour if it does not exist
    // ensuring null is not returned
    return Colors.blue; // default colour
  }

  /// Updates the profile colour in Firestore for the given profile ID.
  ///
  /// This method sets the new colour value in the document
  /// for the specified profile.
  ///
  /// [profileId] - The ID of the profile to update the colour for.
  /// [color] - The new [Color] object to set as the profile colour.
  Future<void> updateProfileColour(String profileId, Color color) async {
    // Update the document with the new colour value
    await _db
        .collection('profiles')
        .doc(profileId)
        .set({'colour': color.value}, SetOptions(merge: true));
  }
}