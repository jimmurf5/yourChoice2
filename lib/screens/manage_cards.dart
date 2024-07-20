import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/widgets/image_input.dart';

class ManageCards extends StatefulWidget {
  final String profileId;

  const ManageCards({required this.profileId, super.key});

  @override
  State<ManageCards> createState() {
    return _ManageCardsState();
  }
}

class _ManageCardsState extends State<ManageCards> {
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Manage Cards'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                //go to make custom card, add code here
              },
              label: const Text('Curate Cards'),
              icon: const Icon(FontAwesomeIcons.usersGear),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(labelText: 'Card Title'),
              controller: _titleController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
            const SizedBox(height: 20),
            const ImageInput(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                //save the pic
              },
              icon: const Icon(FontAwesomeIcons.plus),
              label: const Text('Create Card'),
            ),
          ],
        ),
      ),
    );
  }
}
