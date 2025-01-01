import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:testtp1android/screens/ai_screen.dart';
import 'package:testtp1android/screens/cart_screen.dart';
import 'package:testtp1android/screens/home_screen.dart';
import 'package:testtp1android/screens/profile_screen.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currInd = 0;

  void changePage(int index) {
    setState(() {
      currInd = index;
    });
  }

  List<Widget> pages = [
    const HomeScreen(),
    // const LoginPage(),
      AiScreen(),
    const CartScreen(),
    // const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Navigator.pushReplacementNamed(context, '/login');
      });
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          user.displayName?? "Unknown User",
          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: null,
              accountEmail: Text(user.email ?? "Unknown User"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/img/person.png"),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("About Us"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IndexedStack(
            index: currInd,
            children: pages,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currInd,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          // BottomNavigationBarItem(icon: Icon(Icons.login), label: "Login"),
           BottomNavigationBarItem(icon: Icon(Icons.rocket_launch), label: "Ai"),
          BottomNavigationBarItem(icon: Icon(Icons.card_travel), label: "Card"),
        ],
        onTap: changePage,
      ),
    );
  }
}
