import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:your_choice/models/category.dart';
import 'package:your_choice/repositories/auth_repository.dart';
import 'package:your_choice/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:your_choice/screens/splash_screen.dart';
import 'package:your_choice/services/hive/message_card_cache_service.dart';
import 'package:your_choice/services/template_and_cat_seeder_service.dart';
import 'firebase_options.dart';
import 'package:your_choice/screens/admin_home.dart';
import 'package:your_choice/data/card_data.dart';
import 'package:your_choice/notifiers/theme_notifier.dart';
import 'package:flutter/services.dart';


import 'models/message_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the orientation to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialise hive
  await Hive.initFlutter();
  //register the adapter for the messageCard class and category
  Hive.registerAdapter(MessageCardAdapter());
  Hive.registerAdapter(CategoryAdapter());

  /*open a hive box named 'messageCard' to store MessageCards
  * and one for the categories*/
  await Hive.openBox<MessageCard>('messageCards');
  await Hive.openBox<Category>('categories');

  /*clear the cache on each restart during this testing and dev phase
  * create an instance of messageCardService to clear the cache*/
  final messageCardCacheService = MessageCardCacheService.forClearCacheAll();
  print('Clearing the cache and associated images');
  await messageCardCacheService.clearCacheAll();

  // Temporary flag to trigger data seeding
  const bool shouldSeedData = false;

  if (shouldSeedData) {
    final TemplateAndCatSeederService seederService = TemplateAndCatSeederService();
    await seederService.seedData(availMessageCards, availableCategories);
  }

  // Initialize the AuthRepository
  final AuthRepository authRepository = AuthRepository();

  // Run the app and wrap it with ProviderScope for Riverpod state management
  runApp(
    // Initialize the AuthRepository
    ProviderScope(
      child: App(
        authRepository: authRepository,
      ),
    ),
  ); //Wrap app with provider scope
}

class App extends ConsumerWidget {
  final AuthRepository authRepository;
  const App({required this.authRepository, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Debug statement
    print(authRepository);

    //watch the theme notifier provider for changes in colour
    final seedColour = ref.watch(themeNotifierProvider);

    // Define the theme based on the watched color
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seedColour),
      useMaterial3: true,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      theme: theme,
      home: StreamBuilder(
        // Use authRepository to listen for authentication state changes
          stream: authRepository.authStateChange(),
          builder: (ctx, snapshot) {
            // Show a splash screen while waiting for the authentication state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            // If the user is authenticated, navigate to the AdminHome screen
            if (snapshot.hasData) {
              return const AdminHome();
            }

            // If the user is not authenticated, navigate to the AuthScreen
            return const AuthScreen();
          }),
    );
  }
}
