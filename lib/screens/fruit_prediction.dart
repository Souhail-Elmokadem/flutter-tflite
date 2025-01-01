import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FruitPredictor extends StatefulWidget {
  @override
  _FruitPredictorState createState() => _FruitPredictorState();
}

class _FruitPredictorState extends State<FruitPredictor> {
  String result = "";

  // Function to perform inference
  Future<void> classifyImage(String imagePath) async {
    // var recognitions = await Tflite.runModelOnImage(
    //   path: imagePath,
    //   numResults: 3,  // Number of classes you want to classify
    //   threshold: 0.1,  // Confidence threshold
    // );

    setState(() {
      // result = recognitions.toString();  // Display the classification result
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            String imagePath = "assets/img/banana.png";  // Replace with actual image path
            await classifyImage(imagePath);
          },
          child: Text('Classify Fruit'),
        ),
        SizedBox(height: 20),
        Text(
          // result
          "",
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}