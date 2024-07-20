import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/screens/communication_hub.dart';
import 'package:your_choice/screens/manage_cards.dart';

class CustomiseProfile extends StatelessWidget {
  final String profileId;
  final String profileName;

  const CustomiseProfile(
      {super.key, required this.profileId, required this.profileName});

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
        actions: [
          IconButton(
              onPressed: () {
                // code to allow colour to be adjusted
              },
              icon: const Icon(Icons.palette_outlined)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300, //width for the buttons
              child: ElevatedButton.icon(
                onPressed: () {
                  // code here to go to tree page and pass profileId
                },
                icon: const Icon(FontAwesomeIcons.tree),
                label: const Text("Create Tree"),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 300, // width for the buttons
              child: ElevatedButton.icon(
                onPressed: () {
                  //navigate to manage cards on pressed
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ManageCards(profileId: profileId),
                      ),
                  );
                },
                icon: const Icon(FontAwesomeIcons.plus),
                label: const Text("Manage Cards"),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 300, //  width for the buttons
              child: ElevatedButton.icon(
                onPressed: () {
                  //navigate to communication hub on pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CommunicationHub(profileId: profileId),
                    )
                  );
                },
                icon: const Icon(FontAwesomeIcons.toggleOn),
                label: const Text("Profile Mode"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
