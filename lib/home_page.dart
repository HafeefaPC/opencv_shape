import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _image;
  String _detectedShape = "";

  // Function to detect the shape from the image
  Future<String> detectShape(String imagePath) async {
    try {
      // Read the image using OpenCV
      var image = cv.imread(imagePath);

      // Convert the image to grayscale
      var grayImage = cv.cvtColor(image, cv.COLOR_BGR2GRAY);

      // Apply Gaussian Blur to reduce noise
      var blurredImage =
          cv.gaussianBlur(grayImage, cv.Size(5, 5) as (int, int), 0);

      // Detect edges using the Canny algorithm
      var edges = cv.canny(blurredImage, 100, 200);

      // Find contours
      var contours =
          (cv.findContours(edges, cv.RETR_TREE, cv.CHAIN_APPROX_SIMPLE)).item1;

      // Iterate through contours and detect shapes
      for (var contour in contours) {
        var perimeter = cv.arcLength(contour, true);
        var approx = cv.approxPolyDP(contour, 0.02 * perimeter, true);

        // Detect different shapes based on the number of contour points
        if (approx.length == 3) {
          return "Triangle";
        } else if (approx.length == 4) {
          var rect = cv.boundingRect(approx);
          var aspectRatio = rect.width / rect.height;
          return (aspectRatio >= 0.95 && aspectRatio <= 1.05)
              ? "Square"
              : "Rectangle";
        } else if (approx.length > 4) {
          return "Circle";
        }
      }
      return "Shape not recognized";
    } catch (e) {
      // Error handling in case image processing fails
      print("Error processing image: $e");
      return "Error processing image";
    }
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _detectedShape = "";
      });

      // Detect the shape in the selected image
      String shape = await detectShape(pickedFile.path);
      setState(() {
        _detectedShape = shape;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shape Detector")),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? Text("No image selected.")
                  : Column(
                      children: [
                        Image.file(_image!),
                        SizedBox(height: 20),
                        Text(
                          _detectedShape.isNotEmpty
                              ? "Detected Shape: $_detectedShape"
                              : "Detecting shape...",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ],
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Upload Image"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on (cv.Contours, cv.Mat) {
  get item1 => null;
}
