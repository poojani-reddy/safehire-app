import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/job_provider.dart';
import 'providers/user_provider.dart';
import 'services/theme_service.dart';
import 'services/auth_service.dart';

import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 🔹 Initialize Firebase for Web & Mobile
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "API_KEY",
          authDomain: "safehire-b301a.firebaseapp.com",
          projectId: "safehire-b301a",
          storageBucket: "safehire-b301a.appspot.com",
          messagingSenderId: "802592780194",
          appId: "1:802592780194:web:6dc07ee4bb8df6dc224cfb",
          measurementId: "G-VXEJZSG69X",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  runApp(const SafeHireApp());
}

class SafeHireApp extends StatelessWidget {
  const SafeHireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => JobProvider()),  // Job Analysis & AI Assistant
        ChangeNotifierProvider(create: (_) => UserProvider()), // User Auth & Data
        ChangeNotifierProvider(create: (_) => ThemeService()), // Light/Dark Mode
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return FutureBuilder<bool>(
            future: AuthService().checkAutoLogin(),
            builder: (context, snapshot) {
              String initialRoute = snapshot.data == true ? '/home' : '/login';

              return MaterialApp(
                title: 'SafeHire',
                debugShowCheckedModeBanner: false,
                theme: themeService.theme,
                initialRoute: initialRoute,
                routes: {
                  '/': (context) => const SplashScreen(),
                  '/login': (context) => const LoginScreen(),
                  '/home': (context) => const HomeScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
