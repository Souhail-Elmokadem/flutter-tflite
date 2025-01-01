import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testtp1android/cubit/auth_cubit.dart';
import 'package:testtp1android/cubit/auth_state.dart';
import 'package:testtp1android/screens/main_screen.dart';
import 'package:testtp1android/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool validateEmail(String value) {
    String pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }
  bool validatePassword(String value) {
    return value.length >= 6;
  }

  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        String email = _emailController.text.trim();
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: _passwordController.text.trim(),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: $e')),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 10,),
                Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 20.0,
                  children: [
                    Image.asset("assets/img/tasks.png",width: 300,height: 300,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            labelText: 'Name'
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            labelText: 'Email'
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
                        decoration: InputDecoration(
                            labelText: 'Password'
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
            
                          onPressed:(){
                            if (_formKey.currentState!.validate()) {
                              signUp();
                            }                        },
                          style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.blue),
                              foregroundColor: WidgetStatePropertyAll(Colors.white)
                          ),
                          child: Text("Register")),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("avez vous un compte ? SignIn")),
                )
            
              ],
            ),
          ),
        ),
      ),
    );
  }

}
