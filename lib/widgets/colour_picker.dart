import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_colours_notifier.dart';

class ColourPicker extends ConsumerStatefulWidget {
  final String profileId;

  const ColourPicker({required this.profileId, super.key});

  @override
  ConsumerState<ColourPicker> createState() {
    return _ColourPickerState();
  }
}

class _ColourPickerState extends ConsumerState<ColourPicker> {
  Color _currentColour = Colors.blue; // Default colour

  //limit the available colours
  List<Color> availColours = [
    Colors.red,
    Colors.deepPurple,
    Colors.blue,
    Colors.yellow,
    Colors.greenAccent,
    Colors.deepOrangeAccent,
    Colors.pink,
    Colors.green
  ];

  @override
  void initState() {
    super.initState();
    // Initialize the colour from the provider
    _currentColour = ref.read(profileColoursProvider(widget.profileId)) ?? Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlockPicker(
            pickerColor: _currentColour,
            availableColors: availColours,
            onColorChanged: (colour) {
              setState(() {
                _currentColour = colour;
              });
              ref.read(profileColoursProvider(widget.profileId).notifier).updateProfileColour(colour);
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

