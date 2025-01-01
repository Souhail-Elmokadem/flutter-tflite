import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testtp1android/cubit/auth_cubit.dart';
import 'package:testtp1android/cubit/auth_state.dart';
import 'package:testtp1android/screens/main_screen.dart';
import 'package:testtp1android/screens/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        String email = _emailController.text.trim();
        print("under trait");
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: _passwordController.text.trim(),
        );
        print("success");
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        print(e.toString());
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: 'Sign up failed: ${e.message}'),
        // );
      }
    }
  }

  bool validateEmail(String value) {
    String pattern =
        r'^[\w\.-]+@[\w\.-]+\.\w+$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool validatePassword(String value) {
    return value.length >= 6;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 100,),
              Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 20.0,
                children: [
                  Image.asset("assets/img/tasks.png",width: 300,height: 300,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: 'Email',
                        prefixIcon: Icon(Icons.email),

                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!validateEmail(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: _passwordController,

                      decoration: const InputDecoration(
                          labelText: 'Password',
                        prefixIcon: Icon(Icons.password)
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (!validatePassword(value)) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),

                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width-50,
                    height: 50,
                    child: ElevatedButton(
                        onPressed:() {
                          if (_formKey.currentState!.validate()) {
                                signIn();
                          }

                        },
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.blue),
                            foregroundColor: WidgetStatePropertyAll(Colors.white)
                        ),
                        child: Text("Je me connect")),
                  ),
                  TextButton(onPressed: (){}, child: Text("Mots de passe oublie ?"))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
                }, child: Text("Vous n'avez pas un compte ? SignUp")),
              )

            ],
          ),
        ),
      ),
    );
  }

}
