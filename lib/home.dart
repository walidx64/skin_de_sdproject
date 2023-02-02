import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import 'chat.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Declare a Future variable to hold the selected image file
  Future<File>? imageFile;
  // Declare a File variable to hold the selected image
  File? _image;
  // Declare a String variable to hold the result of image classification
  String result = '';
  // Declare an ImagePicker variable
  ImagePicker? imagePicker;

  // Function to select a photo from the gallery
  selectPhotoFromGallery() async {
    XFile? pickedFile =
        await imagePicker!.pickImage(source: ImageSource.gallery);
    _image = File(pickedFile!.path);
    // Call setState to update the UI with the selected image
    setState(() {
      _image;
      doImageClassification();
    });
  }

  // Function to capture a photo using the camera
  capturePhotoFromCamera() async {
    // Use the ImagePicker to capture a photo using the camera
    XFile? pickedFile =
        await imagePicker!.pickImage(source: ImageSource.camera);
    _image = File(pickedFile!.path);
    // Call setState to update the UI with the captured photo
    setState(() {
      _image;
      doImageClassification();
    });
  }

  // Function to load the TensorFlow Lite data model files
  loadDataModelFiles() async {
    // Load the TensorFlow Lite model and label files
    String? output = await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
      numThreads: 1, // number of threads to run the model
      isAsset:
          true, // flag to indicate if the model and label files are in the assets folder
      useGpuDelegate: false, // flag to indicate if GPU delegate should be used
    );
    print(output);
  }

  @override
  void initState() {
    // Call the superclass initState method
    super.initState();
    // Initialize the ImagePicker
    imagePicker = ImagePicker();
    // Load the TensorFlow Lite data model files
    loadDataModelFiles();
  }

  // Function to perform image classification using TensorFlow Lite
  doImageClassification() async {
    // Run the image through the TensorFlow Lite model
    var recognitions = await Tflite.runModelOnImage(
      path: _image!.path, // path to the image file
      imageMean: 0.0, // mean value for normalizing the image
      imageStd: 255.0, // standard deviation value for normalizing the image
      numResults: 1, // number of results to return
      threshold: 0.1, // threshold value for filtering results
      asynch: true, // flag to indicate if the operation should run async
    );
    setState(() {
      result = '';
    });
    recognitions.forEach((element) {
      setState(() {
        print(element.toString());
        result += element['label'] + '\n';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('DreamWorks - Project'),
        leading: const Icon(Icons.health_and_safety),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/undraw_Doctors.png'),
                fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 50.0),
            Container(
              margin: const EdgeInsets.only(top: 20.0),
              child: Stack(
                children: [
                  Center(
                    child: TextButton(
                      onPressed: selectPhotoFromGallery,
                      onLongPress: capturePhotoFromCamera,
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 30.0, right: 35.0, left: 10.0),
                        child: _image != null
                            ? Image.file(
                                _image!,
                                height: 360.0,
                                width: 400.0,
                                fit: BoxFit.contain,
                              )
                            : Container(
                                width: 140.0,
                                height: 190.0,
                                child: const Icon(
                                  Icons.image_search,
                                  color: Colors.red,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: selectPhotoFromGallery,
                          child: const Text('Gallery'),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: capturePhotoFromCamera,
                          child: const Text('Camera'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(
            //   height: 20.0,
            // ),
            Container(
                //margin: const EdgeInsets.only(top: 20.0),
                child: Column(
              children: [
                const Text(
                  " Skin diseases detection Results ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white,
                      backgroundColor: Colors.black),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "$result",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      color: Colors.white,
                      backgroundColor: Colors.red),
                ),
                ElevatedButton(
                  onPressed: () {
                    //Get.snackbar('Feature Coming soon', 'Update in progress');
                    Get.bottomSheet(
                      Wrap(
                        children: [
                          ListTile(
                              leading: const Icon(Icons.medical_services),
                              title: const Text('DereamWorks - Chat NOW!'),
                              onTap: () {
                                Get.to(
                                  const chatPage(),
                                );
                              }),
                          ListTile(
                            leading: const Icon(Icons.medical_services),
                            title: const Text('Dr Harris - Chat NOW!'),
                            onTap: () {
                              Get.snackbar(
                                  'Feature Coming soon', 'Update in progress');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.medical_services),
                            title: const Text('Dr Maximilian - Chat NOW!'),
                            onTap: () {
                              Get.snackbar(
                                  'Feature Coming soon', 'Update in progress');
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.medical_services),
                            title: const Text('Dr Maiia - Chat NOW!'),
                            onTap: () {
                              Get.snackbar(
                                  'Feature Coming soon', 'Update in progress');
                            },
                          )
                        ],
                      ),
                      backgroundColor: Colors.white,
                    );
                  },
                  child: const Text('Make Appointment'),
                ),
                const Text(
                  'Developed By Walid Islam',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       Get.to(chatPage());
                //     },
                //     child: Text('Next'))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
