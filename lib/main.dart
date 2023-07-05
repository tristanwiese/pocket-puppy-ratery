import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Services/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login_Register/auth_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    getPrefs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SeniorRatWatcher(),
      child: MaterialApp(
        title: 'Pocket Puppy Ratery',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldKey,
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: primaryThemeColor),
          colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: primaryThemeColor,
              onPrimary: Colors.black87,
              secondary: secondaryThemeColor,
              onSecondary: Colors.black54,
              error: Colors.red[300]!,
              onError: Colors.white,
              background: Colors.white,
              onBackground: Colors.black87,
              surface: Colors.white,
              onSurface: Colors.black87),
          fontFamily: "PT Sans",
        ),
        home: const AuthState(),
      ),
    );
  }
}
