import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login.dart';
import 'signup.dart';
import 'home_city.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen to auth state
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while checking auth state
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else {
          // Navigate based on auth state
          User? user = snapshot.data;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Montserrat',
              textTheme: const TextTheme(
                bodyLarge: TextStyle(fontWeight: FontWeight.w800),
                bodyMedium: TextStyle(fontWeight: FontWeight.w600),
                titleLarge: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            home: user != null ? const HomeCity() : const LoginPage(),
            routes: {
              '/signup': (context) =>
                  const SignupPage(), // Define the signup route
            },
          );
        }
      },
    );
  }
}
