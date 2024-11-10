
**Problem Statement:** _Enhancing Object Recognition for the Visually Impaired_

## 📜 Introduction

The VisionMate app helps visually impaired individuals navigate their surroundings using real-time, on-device trained models. Through voice guidance offered by the app, it provides user-friendly interface that helps user access features of the app in thier desired language.

The app uses technologies to detect objects, guide users, and provide a smooth, user-friendly experience. By combining these features, VisionMate serves as a reliable application that enhances freedom and confidence for those with visual impairments.


## ✨ Features

- Offline functionality
- Real-time object detection
- Distance Estimation
- Language selection during installation
- Speech Utterance (Text-to-speech)
- Multilingual Interface (Translation)
- Vibration integration
  
## 💻 Technology Stack

- Flutter
- Ultralytics
- Google ML Kit
- flutter_tts 
- MongoDB
- NodeJS
- vibration 

## Architecture

### 1. Mobile Application
The VisionMate app is built using Flutter, enabling a cross-platform experience.

### 2. Core Functionalities

- **Object Detection:**
  The app leverages Ultralytics YOLO models to perform real-time object detection.
  
- **Multilingual Interface:**
  Google ML Kit translates labels into language selected by the user. 

- **Text-to-Speech (TTS) Integration:**  
  Using `flutter_tts`, the app converts the translated labels into voice prompts, providing auditory feedback to the user.

### 3. Data Flow & System Communication

- **On-device Processing:**  
  All machine learning models, including Google ML Kit are run on-device to ensure the app functions seamlessly offline, without reliance on internet connectivity.

- **Haptic Feedback & Audio Guidance:**  
  The app offers real-time haptic and voice alerts to notify users of obstacles, ensuring a safe and independent navigation experience.

### 4. Data Storage

- **MongoDB Database:**  
  The app uses MongoDB database to store user data ensuring smooth functionality of the application.

This architecture ensures that the VisionMate app provides reliable, offline, real-time assistance to visually impaired individuals, enhancing their mobility and independence.





## 🟢 Access

📱 App's APK file location: https://tinyurl.com/techpirates-download

## Presentation
[(https://www.canva.com/design/DAGTxXxn5V4/mhbhS0H_JQ6bRbZCb8DEcw/view?utm_content=DAGTxXxn5V4&utm_campaign=share_your_design&utm_medium=link&utm_source=shareyourdesignpanel)]
