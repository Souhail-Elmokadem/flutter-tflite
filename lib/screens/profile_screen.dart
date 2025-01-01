import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    print(user!.photoURL);
    if (user != null) {
      _displayNameController.text = user!.displayName ?? "";
      _emailController.text = user!.email ?? "";

      // Fetch the profile image from Firestore
      getProfileImage(user!.uid).then((base64Image) {
        if (base64Image != null) {
          setState(() {
            _imageFile = _decodeBase64Image(base64Image);
          });
        }
      });

    }
  }
  File _decodeBase64Image(String base64String) {
    final bytes = base64Decode(base64String);
    final tempFile = File('${(Directory.systemTemp.path)}/temp_image.png');
    tempFile.writeAsBytesSync(bytes);
    return tempFile;
  }
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  Future<String?> getProfileImage(String userId) async {
    try {
      // Fetch the document from Firestore
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance.collection('img').doc(userId).get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Get the 'profileImage' field from the document
        return docSnapshot['profileImage'];
      } else {
        // Document doesn't exist
        return null;
      }
    } catch (e) {
      // Handle any errors
      print('Error retrieving profile image: $e');
      return null;
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_imageFile == null || !_imageFile!.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a valid image!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert image to Base64 string
      String base64Image = base64Encode(_imageFile!.readAsBytesSync());

      // Ensure the Base64 string size is within Firestore limits
      if (base64Image.length > 1000000) {
        throw Exception('Image size exceeds Firestore limits!');
      }

      // Store the Base64 image string in Firestore
      await FirebaseFirestore.instance.collection('img').doc(user!.uid).set({
        'profileImage': base64Image,
      }, SetOptions(merge: true)); // Use merge to update instead of overwrite

      // Reload user and update the UI
      await user!.reload();
      user = FirebaseAuth.instance.currentUser;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile image updated successfully!')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await user!.updateDisplayName(_displayNameController.text);
        await user!.updateEmail(_emailController.text);
        await user!.reload();
        user = FirebaseAuth.instance.currentUser;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : (user?.photoURL != null
                                        ? NetworkImage(user!.photoURL!)
                                        : AssetImage("assets/img/person.png"))
                                    as ImageProvider,
                            maxRadius: 80,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, size: 30),
                              onPressed: _pickImage,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _displayNameController,
                      decoration: InputDecoration(
                        labelText: 'Display Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Display Name cannot be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _uploadProfileImage,
                      child: Text('Update Profile Image'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _updateProfile,
                      child: Text('Update Profile'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
