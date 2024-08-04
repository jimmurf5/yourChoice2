import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Method to get the profile colour from Firestore
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
    //ensuring null is not returned
    return Colors.blue; // default colour
  }

  // Method to update the profile colour in Firestore
  Future<void> updateProfileColour(String profileId, Color color) async {
    // Update the document with the new colour value
    await _db.collection('profiles').doc(profileId).set({'colour': color.value}, SetOptions(merge: true));
  }
}