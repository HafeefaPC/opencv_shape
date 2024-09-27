# Shape Detector App

## Overview

The **Shape Detector App** is a Flutter-based mobile application that detects basic geometric shapes (Triangle, Square, Rectangle, Circle) from images uploaded by the user. By leveraging the power of OpenCV for image processing, the app analyzes the contours of shapes in the image and identifies them. The detected shape is displayed directly on the screen in **red** text after the image is uploaded.

## Features

- **Image Upload**: Users can upload an image from their gallery for shape detection.
- **Shape Detection**: Detects common geometric shapes, including:
  - **Triangle**: Identified by three contour points.
  - **Square**: Identified by four contour points with an aspect ratio close to 1 (height/width).
  - **Rectangle**: Identified by four contour points with a height/width ratio significantly different from 1.
  - **Circle**: Identified by contours with more than four points and no sharp edges.
- **Real-time Display**: The detected shape is displayed immediately after the image is uploaded.
- **User Interface**: Simple and intuitive interface with an image display area and the name of the detected shape shown below the image in **red**.

## How It Works

1. **Image Upload**: The app uses the `image_picker` package to allow users to select an image from their device's gallery.
   
2. **Image Processing**:
   - The uploaded image is converted to grayscale to simplify the shape detection process.
   - A **Gaussian Blur** filter is applied to reduce noise and make the image smoother, which helps in detecting edges more accurately.
   - **Canny Edge Detection** is then applied to detect the edges in the image. This step identifies the boundaries of the shapes.
   
3. **Contour Detection**:
   - The app identifies contours in the image using OpenCV's contour-finding algorithm.
   - These contours are the outlines of the shapes detected in the image.

4. **Shape Identification**:
   - The app calculates the perimeter of each detected contour.
   - Based on the number of vertices in the contour, the app classifies the shape:
     - **3 vertices** → Triangle
     - **4 vertices** → Square (if the aspect ratio is close to 1) or Rectangle (if the aspect ratio is not close to 1)
     - **More than 4 vertices** → Circle (or a shape with no sharp corners)

5. **Result Display**:
   - After detecting the shape, the app displays the name of the shape below the uploaded image in **red**.

## Screenshots

![Shape Detector Screenshot](path_to_screenshot.png)

## Technologies Used

- **Flutter**: Used for building the mobile app UI and logic.
- **OpenCV**: A powerful image processing library used for shape detection. The OpenCV Dart package (`opencv_dart`) is used to integrate OpenCV functions with Flutter.
- **image_picker**: A Flutter plugin for selecting images from the device gallery.

## Project Structure

Here’s an overview of the project’s folder structure:

