import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DisplayTree extends StatelessWidget {
  final DocumentSnapshot treeSnapshot;

  const DisplayTree({
    super.key,
    required this.treeSnapshot,
  });

  @override
  Widget build(BuildContext context) {
    // Create an instance of TTSService to use for text-to-speech functionality
    //final TTSService ttsService = TTSService();
    var treeData = treeSnapshot.data() as Map<String, dynamic>;
    var treeTitle = '${treeData['treeTitle']}'; //store the tree title

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(treeTitle),
        actions: [
          IconButton(
              onPressed: () async {
                //await ttsService.flutterTts.speak(treeTitle);
              },
              icon: const Icon(FontAwesomeIcons.comment),
          )
        ],
      ),
    );
  }}