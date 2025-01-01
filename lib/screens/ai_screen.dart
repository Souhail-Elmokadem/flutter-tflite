import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;  // Import the image package

class AiScreen extends StatefulWidget {
  AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  Interpreter? _interpreter;
  List<String> _labels = ['Apple', 'Banana', 'Grape', 'Mango', 'Strawberry'];
  String _result = "Choose an image ";
  File? _image;



  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  // Load the TensorFlow Lite model
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      print("Model loaded successfully");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  // Function to classify an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = "Classifying...";  // Update UI to show that classification is in progress
      });

      // Call the classify function after updating the UI
      await _classifyImage(_image!);
    }
  }

  Future<void> _classifyImage(File image) async {
    try {
      // Preprocess the image (resize and normalize)
      var input = await _preprocessImage(image);

      // Initialize the output tensor to be a list of doubles
      var output = List.generate(1, (i) => List.generate(_labels.length, (j) => 0.0));

      // Run inference
      _interpreter?.run(input, output);

      // Print the raw output probabilities
      print("Output: $output");

      // Get the index of the highest probability
      var maxIndex = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));

      // Set the result as the class label corresponding to the highest probability
      setState(() {
        _result = _labels[maxIndex];  // Use the index to get the label from _labels
      });
    } catch (e) {
      setState(() {
        _result = "Error classifying image";  // Update result in case of error
      });
      print("Error classifying image: $e");
    }
  }





  // Preprocess the image to fit the model input
  Future<List<List<List<List<double>>>>> _preprocessImage(File image) async {
    var imageBytes = await image.readAsBytes();

    // Decode the image to an img.Image object using the image package
    img.Image? imageData = img.decodeImage(Uint8List.fromList(imageBytes));

    // Resize the image to 150x150 using the image package's copyResize method
    img.Image resizedImage = img.copyResize(imageData!, width: 150, height: 150);

    // Normalize the image data (scale pixel values between 0 and 1)
    List<List<List<double>>> processedData = List.generate(150, (i) {
      return List.generate(150, (j) {
        var pixel = resizedImage.getPixel(j, i);
        // Normalize each RGB component to a double between 0 and 1
        return [
          img.getRed(pixel) / 255.0,
          img.getGreen(pixel) / 255.0,
          img.getBlue(pixel) / 255.0
        ];
      });
    });

    // Reshape to [1, 150, 150, 3] for TensorFlow Lite input
    var inputTensor = processedData.map((row) {
      return row.map((pixel) {
        return List<double>.from(pixel);  // Convert the pixel values to List<double>
      }).toList();
    }).toList();

    return [inputTensor];  // Wrap in outer list to match model's expected shape
  }

  // Select an image from the gallery


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fruit Classifier")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text("No image selected")
                : Image.file(_image!),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Pick an image to classify"),
            ),
          ],
        ),
      ),
    );
  }
}
