import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/models/message_card.dart';
import 'package:your_choice/screens/select_card.dart';
import 'package:your_choice/widgets/message_card_item.dart';


class ChooseMessageCard extends StatefulWidget {
  final String textInButton;
  final String profileId;

  const ChooseMessageCard({
    super.key,
    required this.textInButton,
    required this.profileId
  });

  @override
  State<ChooseMessageCard> createState() {
    return _ChooseMessageCardState();
  }
}

class _ChooseMessageCardState extends State<ChooseMessageCard> {
  //declare a message card to hold messageCard if one is selected
  MessageCard? messageCard;

  // a function to select a message card
  // navigate to select card
  void _selectMessageCard() async {
    // assign selected card to card return by selectCard
    final selectedCard = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
      SelectCard(profileId: widget.profileId),
      ),
    );

    // Update the state with the selected message card
    setState(() {
      messageCard = selectedCard;
    });
  }

  @override
  Widget build(BuildContext context) {
    //if no card selected display button
    Widget display = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            _selectMessageCard();
            //take the user to menu to choose messageCard
          },
          label: Text(widget.textInButton),
          icon: const Icon(FontAwesomeIcons.comment),
        ),
      ],
    );

    //if messageCard selected show message card
    //wrap in gesture detector for re-selection
    if (messageCard != null) {
      display = GestureDetector(
        onTap: _selectMessageCard, //allow reselection
          child: MessageCardItem(messageCard: messageCard!),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      height: 80,
      width: double.infinity,
      alignment: Alignment.center,
      child: display,
    );
  }
}
