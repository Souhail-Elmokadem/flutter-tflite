import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testtp1android/screens/login_screen.dart';
import 'package:testtp1android/shared/shared_preferences/sharedNatwork.dart';
import 'package:testtp1android/shared/shared_preferences/shared_token.dart';

import 'main_screen.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Vous etes deja connecte"),
            ElevatedButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
              Sharednetwork.signOut(context);
            }, child: Text("Deconnexion"))
          ],
        ),
      ),
    );
  }
}
