import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:tech_pirates/bloc/language_bloc/bloc/lang_bloc.dart';
import 'package:tech_pirates/bloc/object_detect_bloc/bloc/object_det_bloc.dart';
import 'dart:math';

import 'package:tech_pirates/ui/home.dart';
import 'package:vibration/vibration.dart'; // Import math for calculations

class YoloVideo extends StatefulWidget {
  const YoloVideo({super.key});

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  //
  // Minimum time before repeating the same detection

  //for speec -end

  // Declare needed variables
  late CameraController controller;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  late List<CameraDescription> camerass;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  double confidenceThreshold = 0.5;

  // Variables for speech and tracking
  String previousResult = "";
  DateTime previousSpeechTime = DateTime.now();
  Duration repeatDuration = const Duration(seconds: 3);

  // Add focal length and known object height for distance calculation
  final double focalLength =
      130.0; // Adjust this based on your camera's specification
  final double knownObjectHeight = 1.7; // Example: height of a person in meters

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    camerass = await availableCameras(); // Fetch available cameras
    vision = FlutterVision(); // Initialize FlutterVision

    controller = CameraController(
      camerass[0],
      ResolutionPreset.low, // Use low resolution
      enableAudio: false, // Disable audio
    );

    try {
      await controller.initialize();
    } catch (e) {
      print("Camera initialization failed: $e");
    }

    await loadYoloModel();

    setState(() {
      isLoaded = true;
      isDetecting = false;
      yoloResults = [];
    });
  }

  @override
  void dispose() {
    controller.dispose();
    vision.closeYoloModel(); // Removed await as it shouldn't be async
    super.dispose();
  }

  // Loading YOLO model with error handling
  Future<void> loadYoloModel() async {
    try {
      await vision.loadYoloModel(
        labels: 'assets/labels1.txt', // Updated labels file
        modelPath: 'assets/model.tflite', // Updated model file
        modelVersion: "yolov8", // You can keep this or change as needed
        numThreads: 1,
        useGpu: false, // Change to false if GPU issues arise
      );
      setState(() {
        isLoaded = true;
      });
    } catch (e) {
      print("Error loading YOLO model: $e");
      setState(() {
        isLoaded = false; // Update the state if the model fails to load
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: () async {
          Vibration.vibrate(pattern: [500, 500]);
          await Future.delayed(Duration(milliseconds: 600));
          await startDetection();
        },
        onTap: () async {
          Vibration.vibrate(duration: 500);
          await Future.delayed(Duration(milliseconds: 600));
          await stopDetection();
        },
        onLongPress: () async {
          Vibration.vibrate(pattern: [1000, 1000]);
          await Future.delayed(Duration(milliseconds: 600));
          bool isCurrentlyShowing =
              context.read<ObjectDetBloc>().state is DetectObjectState;
          context
              .read<ObjectDetBloc>()
              .add(DetectObjectEvent(isState: !isCurrentlyShowing));
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
            ...displayBoxesAroundRecognizedObjects(size),
            Positioned(
              bottom: 75,
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 5,
                    color: Colors.white,
                    style: BorderStyle.solid,
                  ),
                ),
                child: isDetecting
                    ? IconButton(
                        onPressed: () async {
                          stopDetection();
                        },
                        icon: const Icon(
                          Icons.stop,
                          color: Colors.red,
                        ),
                        iconSize: 50,
                      )
                    : IconButton(
                        onPressed: () async {
                          await startDetection();
                        },
                        icon: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                        iconSize: 50,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Real-time object detection function
  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    print("Processing frame...");
    final result = await vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );

    if (result.isNotEmpty) {
      print("Objects detected: ${result.length}");
      setState(() {
        yoloResults = result;
      });

      bool isSpeaking = false;

      for (var detectedObject in result) {
        if (!isSpeaking) {
          // Only speak if no speech is currently in progress
          // Extract object details
          double objectHeightInImage =
              detectedObject["box"][3] - detectedObject["box"][1];
          double distance = calculateDistance(objectHeightInImage);
          String objectName = detectedObject['tag'];
          String speechMessage =
              "$objectName, Distance: ${distance.toStringAsFixed(2)} meters";

          // Avoid repeating the same detection within a short time frame
          if (speechMessage != previousResult ||
              DateTime.now().difference(previousSpeechTime) > repeatDuration) {
            // Set flags before starting speech
            isSpeaking = true;
            previousResult = speechMessage;
            previousSpeechTime = DateTime.now();

            // Ensure the widget is still mounted before using context
            if (!mounted) return;

            // Dispatch the speech message event to LangBloc
            context.read<LangBloc>().add(LanguageAlertEvent(speechMessage));

            // Wait for the speech to finish before allowing the next one
            await Future.delayed(
                const Duration(seconds: 2)); // Wait for TTS completion

            // Speech completed, reset the flag
            isSpeaking = false;
          }
        }
      }
    } else {
      print("No objects detected.");
    }
  }

  //to alert user

  // Start video stream and detection
  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });

    if (controller.value.isStreamingImages) {
      return;
    }

    int frameCount = 0; // Initialize frameCount here
    const int processEveryNthFrame = 3; // Process every 3rd frame

    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        frameCount++; // Increment frameCount

        // Process every 3rd frame
        if (frameCount % processEveryNthFrame == 0) {
          yoloOnFrame(image);
        }
      }
    });
  }

  // Stop detection
  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  // Function to calculate distance of an object
  double calculateDistance(double objectHeightInImage) {
    // Using the formula: Distance = (Real Height * Focal Length) / Object Height in Image
    // This assumes height is in pixels for the objectHeightInImage and meters for knownObjectHeight
    return (knownObjectHeight * focalLength) / objectHeightInImage;
  }

  // Display bounding boxes around detected objects
  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (cameraImage == null || yoloResults.isEmpty) return [];

    double factorX = screen.width / (cameraImage?.width ?? 1);
    double factorY = screen.height / (cameraImage?.height ?? 1);
    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

      // Calculate distance based on object height in the image
      double distance = calculateDistance(objectHeight);

      return Positioned(
        left: objectX,
        top: objectY,
        width: objectWidth,
        height: objectHeight,
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(2)}% | Dist: ${distance.toStringAsFixed(2)}m",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: const Color.fromARGB(255, 115, 0, 255),
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}

//to calculate the
