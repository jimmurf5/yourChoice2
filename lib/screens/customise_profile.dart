import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomiseProfile extends StatelessWidget {
  final String profileId;
  final String profileName;

  const CustomiseProfile({super.key, required this.profileId, required this.profileName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Customise Profile'),
            Text(
              'Profile name: $profileName',
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton.icon(onPressed: () {
              // code here to go to tree page and pass profileId
            },
              icon: const Icon(FontAwesomeIcons.tree),
              label: const Text("Create Tree"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(onPressed: () {
              // code here to go to tree page and pass profileId
            },
              icon: const Icon(FontAwesomeIcons.plus),
              label: const Text("Manage Cards"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(onPressed: () {
              // code here to go to tree page and pass profileId
            },
              icon: const Icon(FontAwesomeIcons.toggleOn),
              label: const Text("User Mode"),
            ),
          ],
        ),
      ),
    );
  }
}
