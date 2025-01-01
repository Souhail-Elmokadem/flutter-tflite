import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class AiScreen extends StatefulWidget {
  AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Interpreter? interpreter;
  List<double> output = [];
  List<String> labels = ['apple', 'banana', 'orange'];  // Example labels (replace with your own labels)

  // Load the TensorFlow Lite model
  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/model_ML/fruits_model.tflite');
      print("Model loaded successfully!");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  // Preprocess the image (resize and normalize it)
  List<List<List<List<double>>>> preprocessImage(File image) {
    final rawImage = img.decodeImage(image.readAsBytesSync())!;
    final resizedImage = img.copyResize(rawImage, width: 224, height: 224); // Resize to 224x224
    final inputImage = List.generate(1, (i) => List.generate(224, (j) => List.generate(224, (k) => List.filled(3, 0.0))));

    for (int i = 0; i < 224; i++) {
      for (int j = 0; j < 224; j++) {
        final pixel = resizedImage.getPixel(i, j);
        final red = (img.getRed(pixel) / 255.0);   // Normalize Red channel
        final green = (img.getGreen(pixel) / 255.0); // Normalize Green channel
        final blue = (img.getBlue(pixel) / 255.0);   // Normalize Blue channel

        inputImage[0][i][j][0] = red;   // Red channel
        inputImage[0][i][j][1] = green; // Green channel
        inputImage[0][i][j][2] = blue;  // Blue channel
      }
    }
    return inputImage;
  }

  // Pick an image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await predictImage(File(pickedFile.path));  // Predict once the image is picked
    }
  }

  // Predict using the model
  Future<void> predictImage(File image) async {
    try {
      final input = preprocessImage(image);  // Preprocess the image
      output = List.filled(labels.length, 0.0);

      // Run inference
      if(interpreter != null){
        interpreter!.run(input, output);
      }
      // Get the index of the highest probability
      int predictedLabelIndex = output.indexOf(output.reduce((a, b) => a > b ? a : b));
      String predictedLabel = labels[predictedLabelIndex];

      print("Prediction: $predictedLabel with confidence: ${output[predictedLabelIndex]}");

      setState(() {
        // Update UI with prediction results
      });
      print(output);

    } catch (e) {
      print("Error during prediction: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadModel();  // Load model when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Fruit Prediction")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!)
                : Text("No image selected"),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.upload),
              label: Text('Upload Image'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Prediction: ${output.isNotEmpty ? labels[output.indexOf(output.reduce((a, b) => a > b ? a : b))] : 'No prediction yet'}",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
