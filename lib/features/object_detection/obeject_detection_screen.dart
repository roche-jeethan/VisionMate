import 'package:camera/camera.dart';
//dont touch it
import 'package:flutter/material.dart';
import 'package:tech_pirates/core/utils/colors.dart';

import 'package:tflite_v2/tflite_v2.dart'; // Assuming you're using the tflite package

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  State<ObjectDetectionScreen> createState() => _HomeState();
}

class _HomeState extends State<ObjectDetectionScreen> {
  List<CameraDescription>? cameras;
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = 'Hil';

  @override
  void initState() {
    super.initState();
    loadCamera();
    loadModel();
  }

  @override
  void dispose() {
    // Dispose of cameraController and TensorFlow Lite to free resources
    cameraController?.dispose();
    Tflite.close(); // Free TensorFlow Lite resources
    super.dispose();
  }

  // Function to load available cameras
  loadCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // Use lower resolution to reduce resource usage
        cameraController = CameraController(cameras[0], ResolutionPreset.low);
        await cameraController?.initialize();
        if (!mounted) return;

        setState(() {
          print("Camera initialized");
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      } else {
        print("No cameras found.");
      }
    } catch (e) {
      print("Error loading camera: $e");
    }
  }

  // Function to run the model on each frame
  runModel() async {
    if (cameraImage != null) {
      try {
        var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          rotation: 90,
          numResults: 2,
          threshold: 0.1,
          asynch: true,
        );
        setState(() {
          if (predictions != null && predictions.isNotEmpty) {
            output = predictions[0]['label']; // Get the first prediction
          }
        });
      } catch (e) {
        print("Error running model: $e");
      }
    }
  }

  // Function to load TensorFlow Lite model
  loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model3c.tflite",
        labels: "assets/labels.txt",
      );
      print("Model loaded successfully");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 2,
                      color: color2,
                    )),
                child: cameraController != null &&
                        cameraController!.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: cameraController!.value.aspectRatio,
                        child: CameraPreview(cameraController!),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ), // Show loading indicator
              ),
            ),
            Container(
              height: 40,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 2, color: color2),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  "$output is detected",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
