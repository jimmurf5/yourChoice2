import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:your_choice/models/message_card.dart';
import 'package:your_choice/widgets/category_item.dart';
import 'package:your_choice/widgets/long_press_button.dart';
import 'package:your_choice/widgets/message_card_item.dart';
import 'package:your_choice/services/message_card_service.dart';
import '../models/category.dart';

class CommunicationHub extends StatefulWidget {
  final String profileId;

  const CommunicationHub({super.key, required this.profileId});

  @override
  State<CommunicationHub> createState() {
    return _CommunicationHubState();
  }
}

class _CommunicationHubState extends State<CommunicationHub> {
  FlutterTts flutterTts = FlutterTts(); //initialize flutter tts
  int selectedCategory = 3; //default the selected category to category 3
  List<MessageCard> selectedCards = [];
  late MessageCardService messageCardService;

  @override
  void initState() {
    super.initState();
    // Initialize the service
    messageCardService = MessageCardService(profileId: widget.profileId);
    print('messageCardService initialized with profileId: ${widget.profileId}');
    initializeTts();
  }

  void initializeTts() {
    flutterTts.setLanguage("en-UK");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
    flutterTts.setPitch(1.0);

    flutterTts.setStartHandler(() {
      print("TTS Started");
    });

    flutterTts.setCompletionHandler(() {
      print("TTS Completed");
    });

    flutterTts.setErrorHandler((msg) {
      print("TTS Error: $msg");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communication Hub'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        //remove the default arrow provided by flutter in the app bar
        automaticallyImplyLeading: false,
        leading: //button to navigate profile to saved decision trees
            IconButton(
                onPressed: () {
                  //logic to show decision tress
                },
                icon: const Icon(FontAwesomeIcons.tree),
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
        actions: <Widget>[
          //only allow profile to leave the comm hub screen on a long press
          //call on long press widget
          //current long press set at 8 seconds
          LongPressButton(
            onLongPressCompleted: Navigator.of(context)
                .pop, //pop back to admin home on successful long press
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [
          //this is a panel to display clicked message cards
          Container(
            height: 150,
            color: Theme.of(context).colorScheme.onSecondary,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //iterate through the list of selected messageCards and display in this row
                children: selectedCards.map((singleCard) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: MessageCardItem(messageCard: singleCard),
                  );
                }).toList(),
              ),
            ),
          ),
          // row with play button and trash can to read the selected cards
          // and clear them respectively
          Container(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    setState(() {
                      selectedCards.clear();
                    });
                    await flutterTts.speak('Clear!');
                  },
                  icon: const Icon(FontAwesomeIcons.trashCan),
                  iconSize:25,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                IconButton(
                  //on pressed tts to read out the maximum of three items
                  // held in the selected cards list
                  //shown in the display panel
                  onPressed: () async {
                    for (var card in selectedCards) {
                      await flutterTts.speak(card.title);
                      await flutterTts.awaitSpeakCompletion(true);
                    }
                  },
                  icon: const Icon(FontAwesomeIcons.play),
                  iconSize:45,
                  alignment: Alignment.center,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ],
            ),
          ),
          //vertically scrolling column with message cards
          Expanded(
              //ternary to deal with category being = 1 (history)
              child: selectedCategory == 1
                  ? FutureBuilder<List<MessageCard>>(
                      future: messageCardService.updateHistoryCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final cardDeck = snapshot.data!;
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: cardDeck.length,
                          itemBuilder: (context, index) {
                            final card = cardDeck[index];
                            return GestureDetector(
                              onTap: () async {
                                setState(() {
                                  if (selectedCards.length < 3) {
                                    selectedCards.add(card);
                                  }
                                });
                                await flutterTts.speak(card.title);
                                await messageCardService.selectCard(card);
                              },
                              child: MessageCardItem(messageCard: card),
                            );
                          },
                        );
                      },
                    )
                  : StreamBuilder<QuerySnapshot>(
                      //get the message Card data from firebase only for our selected profile matching the chosen category
                      stream: FirebaseFirestore.instance
                          .collection('profiles')
                          .doc(widget.profileId)
                          .collection('messageCards')
                          .where('categoryId', isEqualTo: selectedCategory)
                          .snapshots(),
                      builder: (context, snapshot) {
                        // Check for any errors
                        if (snapshot.hasError) {
                          print("Error fetching data: ${snapshot.error}");
                          return Center(
                              child: Text(
                                  'Error fetching data: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final cardDeck = snapshot.data!.docs.map((doc) {
                          print("MessageCard Data: ${doc.data()}");
                          return MessageCard.fromMap(
                              doc.data() as Map<String, dynamic>);
                        }).toList();
                        return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: cardDeck.length,
                            itemBuilder: (context, index) {
                              final card = cardDeck[index];
                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    if (selectedCards.length < 3) {
                                      selectedCards.add(card);
                                    }
                                  });
                                  //read out the title of the messageCard on tap
                                  await flutterTts.speak(card.title);
                                  //call method to record click hx for history category
                                  await messageCardService.selectCard(card);
                                },
                                child: MessageCardItem(messageCard: card),
                              );
                            });
                      },
                    ),
          ),
          //horizontally scrolling row for the categories
          Container(
            color: Theme.of(context).colorScheme.onSecondary,
            child: SizedBox(
              height: 120.0,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    //check to make sure snapshot has data and is not null
                    return const Center(child: CircularProgressIndicator());
                  }
                  final categories = snapshot.data!.docs.map((doc) {
                    return Category.fromMap(doc.data() as Map<String, dynamic>);
                  }).toList();
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: GestureDetector(
                            //set the category on tap of any of the scrollable categories
                            onTap: () async {
                              setState(() {
                                print(
                                    "Selected Category ID: ${category.categoryId}");
                                selectedCategory = category.categoryId;
                              });
                              //read out the category of the messageCard on tap
                              await flutterTts.speak(category.title);
                            },
                            child: CategoryItem(
                                category:
                                    category), //use category item widget to display categories
                          ),
                        );
                      });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
