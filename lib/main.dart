import 'package:flutter/material.dart';
import 'package:testtp1android/screens/Home.dart';
import 'package:testtp1android/screens/ai_screen.dart';
import 'package:testtp1android/screens/cart_screen.dart';
import 'package:testtp1android/screens/home_screen.dart';
import 'package:testtp1android/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testtp1android/screens/register_screen.dart';
import 'package:testtp1android/shared/shared_preferences/sharedNatwork.dart';
import 'cubit/auth_cubit.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:firebase_core/firebase_core.dart';


import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Sharednetwork.cashInitializer();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
        routes: {
          '/home': (context) => HomePage(),
          '/login':(context) => LoginScreen(),
          '/register':(context) => RegisterScreen(),
        },
      ),
    );
  }
}