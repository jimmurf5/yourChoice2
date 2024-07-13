import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:your_choice/screens/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:your_choice/screens/splash_screen.dart';
import 'package:your_choice/services/firestore_service.dart';
import 'firebase_options.dart';
import 'package:your_choice/screens/admin_home.dart';
import 'package:your_choice/data/card_data.dart';

//set theme data
final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 63, 17, 177),
  ),
  useMaterial3: true,
  // textTheme: GoogleFonts.robotoTextTheme(),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Temporary flag to trigger data seeding
  const bool shouldSeedData = false;

  if (shouldSeedData) {
    final FirestoreService firestoreService = FirestoreService();
    await firestoreService.seedData(availMessageCards, availableCategories);
  }

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      theme: theme,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }

            if (snapshot.hasData) {
              return const AdminHome();
            }

            return const AuthScreen();
          }),
    );
  }
}
