import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/screens/communication_hub.dart';
import 'package:your_choice/screens/manage_cards.dart';
import 'package:your_choice/screens/manage_trees.dart';
import 'package:your_choice/widgets/colour_picker.dart';

class CustomiseProfile extends StatefulWidget {
  final String profileId;
  final String profileName;

  const CustomiseProfile(
      {super.key,
        required this.profileId,
        required this.profileName
      });

  @override
  State<CustomiseProfile> createState() => _CustomiseProfileState();
}

class _CustomiseProfileState extends State<CustomiseProfile> {
  ///method to open the modal bottom sheet
  void _openChangeColourOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => ColourPicker(profileId: widget.profileId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Customise Profile'),
            Text(
              'Profile name: ${widget.profileName}',
              style: const TextStyle(
                fontSize: 12.0,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: _openChangeColourOverlay,
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
                  Navigator.push(
                    context,
                    /*Navigate to manage trees and pass true for the bool as
                    * we are currently in user mode*/
                    MaterialPageRoute(
                        builder: (context) =>
                          ManageTrees(
                            profileId: widget.profileId,
                            isUserMode: true,
                          ),
                    )
                  );
                },
                icon: const Icon(FontAwesomeIcons.tree),
                label: const Text("Manages Trees"),
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
                          ManageCards(profileId: widget.profileId),
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
                            CommunicationHub(profileId: widget.profileId),
                      ));
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
