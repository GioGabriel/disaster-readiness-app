import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disaster_readiness_application/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



import 'login_page.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloudinary_public/cloudinary_public.dart';
//import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';




class LandingPage extends StatefulWidget {
  static const String landingPage = '/landing';

  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0; // To keep track of the selected item in the drawer

  final User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference _emergenciesCollection =
  FirebaseFirestore.instance.collection('emergencies');


  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  // final TextEditingController _emergencyDesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the current user's contact number when the landing page is initialized
    _fetchCurrentUserContactNumber();
    _fetchCurrentUserLocation();
  }

  List<String> firstDropdownOptions = [
    'Fire',
    'Car Accident',
    'Health Related Incident',
    'Nature Related Incidents',
    'Assault',
    'Robbery',
    'Fainting',
    'Gas Leak',
    'Building Collapse',
    'Lost or Missing Person',
    'Earthquake',
    'Flood',
    'Tornado',
    'Explosion',
    'Chemical Spill',
    'Power Outage',
    'Accidental Injury',
    'Animal Attack',
    'Suspicious Activity',
    'Others',
  ];

  Map<String, List<String>> secondDropdownOptions = {
    'Fire': ['Neighbor fire', 'In your house', 'Malls', 'Vehicle fires', 'Other'],
    'Car Accident': ['Collision', 'Hit and run', 'Multiple vehicles involved', 'Other'],
    'Health Related Incident': ['Heart attack', 'Laceration', 'Concussion', 'Other'],
    'Nature Related Incidents': ['Earthquake', 'Flood', 'Tornado', 'Other'],
    'Assault': ['Physical assault', 'Sexual assault', 'Other'],
    'Robbery': ['Armed robbery', 'Burglary', 'Other'],
    'Fainting': ['Sudden loss of consciousness', 'Other'],
    'Gas Leak': ['Natural gas leak', 'Other'],
    'Building Collapse': ['Partial collapse', 'Full collapse', 'Other'],
    'Lost or Missing Person': ['Child missing', 'Adult missing', 'Other'],
    'Earthquake': ['Minor tremors', 'Severe earthquake', 'Other'],
    'Flood': ['Localized flooding', 'Flash floods', 'Other'],
    'Tornado': ['Tornado warning', 'Tornado sighted', 'Other'],
    'Explosion': ['Blast', 'Industrial explosion', 'Other'],
    'Chemical Spill': ['Hazardous chemical spill', 'Other'],
    'Power Outage': ['Partial outage', 'Complete outage', 'Other'],
    'Accidental Injury': ['Cuts and bruises', 'Sprains and strains', 'Other'],
    'Animal Attack': ['Dog attack', 'Wild animal attack', 'Other'],
    'Suspicious Activity': ['Unattended package', 'Loitering', 'Other'],
    'Others': [''],
  };



  // Method to fetch the current user's contact number from Firestore
  Future<void> _fetchCurrentUserContactNumber() async {
    if (user != null) {
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      String contactNumber = userDoc['contact_number'] ?? '';
      _contactNumberController.text = contactNumber;
    }
  }
  Future<void> _fetchCurrentUserLocation() async {
    if (user != null) {
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      String location = userDoc['location'] ?? '';
      _locationController.text = location;
    }
  }

  //Alternative to uploading to firebase storage
  // Future<String> _uploadFileWithProgress(File file, String folderName) async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   Reference reference = storage.ref().child('$folderName/${DateTime.now().millisecondsSinceEpoch}');
  //
  //   // Start the upload
  //   UploadTask uploadTask = reference.putFile(file);
  //
  //   // Listen for upload changes and show the progress
  //   uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //     double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
  //     print('Upload progress: ${progress.toStringAsFixed(2)}%');
  //   });
  //
  //   // Wait for the upload to complete
  //   TaskSnapshot taskSnapshot = await uploadTask;
  //   String downloadURL = await taskSnapshot.ref.getDownloadURL();
  //   return downloadURL;
  // }


  // ALternative for firebase storage but has some errors
  // Future<String> _uploadFileToCloudinary(
  //     File file,
  //     String userEmail,
  //     String emergencyId,
  //     ) async {
  //   try {
  //     final cloudinary = CloudinaryPublic('718316557356426', 'dzddt8r3p');
  //     final response = await cloudinary.uploadFile(
  //       CloudinaryFile.fromFile(file.path),
  //       resourceType: CloudinaryResourceType.Image, // Change to 'video' for videos
  //       folder: 'Emergency Photos and Videos/$userEmail/$emergencyId',
  //     );
  //
  //     if (response.isSuccessful) {
  //       return response.secureUrl;
  //     } else {
  //       print('Error uploading file: ${response.error.message}');
  //       return '';
  //     }
  //   } catch (e) {
  //     print('Error uploading file: $e');
  //     return '';
  //   }
  // }
  //
  // Future<List<String>> _uploadFilesToCloudinary(
  //     List<File> files,
  //     String userEmail,
  //     String emergencyId,
  //     ) async {
  //   try {
  //     final cloudinary = CloudinaryPublic('718316557356426', 'dzddt8r3p');
  //     List<String> uploadedUrls = [];
  //
  //     for (var i = 0; i < files.length; i++) {
  //       final customPublicId = 'Emergency_Photos_and_Videos/$userEmail/$emergencyId/file$i';
  //       final response = await cloudinary.uploadFile(
  //         CloudinaryFile.fromFile(files[i].path),
  //         publicId: customPublicId,
  //       );
  //
  //       if (response.isSuccessful) {
  //         uploadedUrls.add(response.secureUrl);
  //       } else {
  //         print('Error uploading file: ${response.error?.message ?? "Unknown error"}');
  //       }
  //     }
  //
  //     return uploadedUrls;
  //   } catch (e) {
  //     print('Error uploading files: $e');
  //     return [];
  //   }
  // }
  //
  //




  void _sendEmergencySignal(BuildContext context) {

    String selectedFirstDropdownOption = firstDropdownOptions[0];
    String selectedSecondDropdownOption = secondDropdownOptions[selectedFirstDropdownOption]![0];
    String emergencyDescription = '';
    String location = _locationController.text;
    String contactNumber = _contactNumberController.text;
    DateTime currentTime = DateTime.now();
    String formattedDateTime = DateFormat('dd/MM/yyyy - h:mm a').format(currentTime);

    File? _selectedImage;
    File? _selectedVideo;
    Widget? _selectedImagePreview;
    Widget? _selectedVideoPreview;

    void _playVideo(File _selectedVideo) async {
      VideoPlayerController videoPlayerController = VideoPlayerController.file(_selectedVideo);
      await videoPlayerController.initialize();
      bool isPlaying = false; // To track video play state

      _selectedVideoPreview = Stack(
        children: [
          AspectRatio(
            aspectRatio: videoPlayerController.value.aspectRatio,
            child: VideoPlayer(videoPlayerController),
          ),
          Center(
            child: IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: 50,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (isPlaying) {
                    videoPlayerController.pause();
                  } else {
                    videoPlayerController.play();
                  }
                  isPlaying = !isPlaying;
                });
              },
            ),
          ),
        ],
      );

      videoPlayerController.addListener(() {
        if (!videoPlayerController.value.isPlaying) {
          setState(() {
            isPlaying = false;
          });
        }
      });

      videoPlayerController.setLooping(false);
    }



    void _fetchCurrentImageUploaded(File _selectedImage) {
      _selectedImagePreview = Image.file(
        _selectedImage,
        fit: BoxFit.cover,
        width: 200,
        height: 200,
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Colors.transparent,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue[200]!, Colors.blue[400]!],
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Emergency",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      if (_selectedImage != null) _selectedImagePreview ?? Container(),
                      if (_selectedVideo != null)
                        _selectedVideoPreview ?? Container(),
                        // AspectRatio(
                        //   aspectRatio: 16 / 9,
                        //   child: VideoPlayer(VideoPlayerController.file(_selectedVideo!)),
                        // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final pickedImage =
                              await ImagePicker().pickImage(source: ImageSource.camera);
                              if (pickedImage != null) {
                                setState(() {
                                  _selectedImage = File(pickedImage.path);
                                  _selectedImagePreview = Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                  );
                                  Fluttertoast.showToast(
                                    msg: 'Photo Uploaded Successfully',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  _fetchCurrentImageUploaded(_selectedImage!);
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 4.0,
                            ),
                            child: const Text("Add Photo"),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final pickedVideo =
                              await ImagePicker().pickVideo(source: ImageSource.camera);
                              if (pickedVideo != null) {
                                setState(() {
                                  _selectedVideo = File(pickedVideo.path);
                                  VideoPlayerController videoPlayerController = VideoPlayerController.file(_selectedVideo!);
                                  bool isPlaying = false;
                                  _selectedVideoPreview = Stack(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: videoPlayerController.value.aspectRatio,
                                        child: VideoPlayer(videoPlayerController),
                                      ),
                                      Center(
                                        child: IconButton(
                                          icon: Icon(
                                            isPlaying ? Icons.pause : Icons.play_arrow,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (isPlaying) {
                                                videoPlayerController.pause();
                                              } else {
                                                videoPlayerController.play();
                                              }
                                              isPlaying = !isPlaying;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  );

                                  videoPlayerController.addListener(() {
                                    if (!videoPlayerController.value.isPlaying) {
                                      setState(() {
                                        isPlaying = false;
                                      });
                                    }
                                  });

                                  videoPlayerController.setLooping(false);

                                  Fluttertoast.showToast(
                                    msg: 'Video Uploaded Successfully',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                  _playVideo(_selectedVideo!);
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 4.0,
                            ),
                            child: const Text("Add Video"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "What is the emergency?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedFirstDropdownOption,
                        items: firstDropdownOptions
                            .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFirstDropdownOption = value!;
                            // Reset the second dropdown value when the first dropdown changes
                            selectedSecondDropdownOption = secondDropdownOptions[value]![0];
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedSecondDropdownOption,
                        items: secondDropdownOptions[selectedFirstDropdownOption]!
                            .map((option) => DropdownMenuItem(
                          value: option,
                          child: Text(option),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSecondDropdownOption = value!;
                          });
                        },
                      ),
                      TextField(
                        // controller: _emergencyDesController,
                        onChanged: (value) => emergencyDescription = value,
                        decoration: const InputDecoration(
                          hintText: "Additional Description (optional)",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Current Emergency Location",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _locationController,
                        onChanged: (value) => location = value,
                        decoration: const InputDecoration(
                          hintText: "Enter your location",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Contact Number",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _contactNumberController,
                        onChanged: (value) => contactNumber = value,
                        decoration: const InputDecoration(
                          hintText: "Enter your contact number",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                if (_contactNumberController.text.isNotEmpty &&
                                    _locationController.text.isNotEmpty) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return const Center(
                                        child: SpinKitChasingDots(
                                          color: Colors.blue,
                                          size: 50.0,
                                        ),
                                      );
                                    },
                                  );

                                  DocumentReference emergencyRef =
                                  _emergenciesCollection.doc();

                                  String? currentEmail = user!.email;
                                  String currentEmergencyId = emergencyRef.id;
                                  String pathFolder =
                                      'Emergency Photos and Videos/$currentEmail/$currentEmergencyId';

                                  // String imageUrl = await _uploadFileToCloudinary(file, currentEmail, currentEmergencyId);
                                  emergencyRef.set({
                                    'userId': user!.uid,
                                    'active': true,
                                    'description': "$selectedFirstDropdownOption - $selectedSecondDropdownOption - $emergencyDescription",
                                    'location': location,
                                    'contactNumber': contactNumber,
                                    'email': user!.email,
                                    'dateTime': formattedDateTime,
                                    'status': "Verifying Information",
                                    'photoURL': '',
                                    'videoURL': '',
                                  }).then((_) async {
                                    if (_selectedImage != null) {
                                      String photoURL =
                                        await _uploadFilesToStorage(_selectedImage!, pathFolder);
                                      emergencyRef.update({
                                        'photoURL': photoURL,
                                      });
                                      Fluttertoast.showToast(
                                        msg: "Image Uploaded",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }

                                    if (_selectedVideo != null) {
                                      String videoURL =
                                      await _uploadFilesToStorage(_selectedVideo!, pathFolder);
                                      emergencyRef.update({
                                        'videoURL': videoURL,
                                      });
                                      Fluttertoast.showToast(
                                        msg: "Video Uploaded",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }

                                    Navigator.pop(context);
                                    Navigator.of(context).pop();
                                    Fluttertoast.showToast(
                                      msg: "Emergency Sent",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Please Input your Emergency",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 4.0,
                              ),
                              child: const Text("Send"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


  Future<String> _uploadFilesToStorage(File file, String folderName) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference =
    storage.ref().child('$folderName/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  //For Faster upload
  // Future<String> _uploadFileToStorage(File file, String folderName) async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   Reference reference = storage.ref().child('$folderName/${DateTime.now().millisecondsSinceEpoch}');
  //
  //   // Determine content type based on the file extension
  //   String contentType = 'image/jpeg'; // Default content type for images
  //   String extension = file.path.split('.').last.toLowerCase();
  //   if (extension == 'mp4' || extension == 'avi' || extension == 'mov') {
  //     contentType = 'video/mp4';
  //   }
  //
  //   // Set metadata for the file (you can adjust these options based on your requirements)
  //   final SettableMetadata metadata = SettableMetadata(
  //     contentType: contentType,
  //     customMetadata: {'uploaded_by': 'your_app_name'},
  //   );
  //
  //   // Upload the file in smaller chunks using putData method for videos or putFile for images
  //   if (contentType == 'video/mp4') {
  //     Uint8List fileData = await file.readAsBytes();
  //     UploadTask uploadTask = reference.putData(fileData, metadata);
  //
  //     // Monitor the upload process using stream events (optional but useful for progress tracking)
  //     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
  //       print('Upload progress: $progress %');
  //     });
  //
  //     // Wait for the upload to complete
  //     TaskSnapshot taskSnapshot = await uploadTask;
  //
  //     // Get the download URL
  //     String downloadURL = await taskSnapshot.ref.getDownloadURL();
  //     return downloadURL;
  //   } else {
  //     UploadTask uploadTask = reference.putFile(file, metadata);
  //
  //     // Monitor the upload process using stream events (optional but useful for progress tracking)
  //     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
  //       print('Upload progress: $progress %');
  //     });
  //
  //     // Wait for the upload to complete
  //     TaskSnapshot taskSnapshot = await uploadTask;
  //
  //     // Get the download URL
  //     String downloadURL = await taskSnapshot.ref.getDownloadURL();
  //     return downloadURL;
  //   }
  // }

  //For more faster Upload
  // Future<String> _uploadFilesToStorages(File file, String folderName) async {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   Reference reference = storage.ref().child('$folderName/${DateTime.now().millisecondsSinceEpoch}');
  //
  //   // Check if the file is a video
  //   bool isVideo = file.path.toLowerCase().endsWith('.mp4') ||
  //       file.path.toLowerCase().endsWith('.avi') ||
  //       file.path.toLowerCase().endsWith('.mov');
  //
  //   if (isVideo) {
  //     // Compress the video before uploading using flutter_ffmpeg
  //     final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  //     const String outputFilePath = '/path/to/compressed.mp4'; // Replace with your desired output file path
  //
  //     // Example command to compress video (you can adjust the parameters as needed)
  //     String command = '-i ${file.path} -c:v libx264 -preset slow -crf 25 -c:a aac $outputFilePath';
  //
  //     int rc = await _flutterFFmpeg.execute(command);
  //     if (rc != 0) {
  //       print('Compression failed with code: $rc');
  //       // Handle compression failure
  //
  //     }
  //
  //     // Upload the compressed video to Firebase Storage
  //     File compressedFile = File(outputFilePath);
  //     UploadTask uploadTask = reference.putFile(compressedFile);
  //
  //     // Monitor the upload progress using stream events (optional but useful for progress tracking)
  //     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
  //       print('Upload progress: $progress %');
  //     });
  //
  //     // Wait for the upload to complete
  //     TaskSnapshot taskSnapshot = await uploadTask;
  //
  //     // Get the download URL
  //     String downloadURL = await taskSnapshot.ref.getDownloadURL();
  //     return downloadURL;
  //   } else {
  //     // For images or other file types, use the original putFile method
  //     UploadTask uploadTask = reference.putFile(file);
  //
  //     // Monitor the upload process using stream events (optional but useful for progress tracking)
  //     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
  //       double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
  //       print('Upload progress: $progress %');
  //     });
  //
  //     // Wait for the upload to complete
  //     TaskSnapshot taskSnapshot = await uploadTask;
  //
  //     // Get the download URL
  //     String downloadURL = await taskSnapshot.ref.getDownloadURL();
  //     return downloadURL;
  //   }
  // }
  // Confirmation dialog for logout
  Future<bool> _onBackPressed(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Do you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              Fluttertoast.showToast(
                msg: "Logged Out",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const Center(
                    child: SpinKitChasingDots(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  );
                },
              );
            },

            child: const Text("Yes"),

          ),
        ],
      ),
    ).then((value) async {
      if (value == true) {
        Navigator.pop(context);
        await FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginPage.loginPage,
              (route) => false,
        );
      }
      return value ?? false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Landing Page"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.pop(context); // Close the drawer after navigation if needed.
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              title: const Text('Profile'),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.pop(context); // Close the drawer after navigation if needed.
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  ProfilePage.profilepage,
                      (route) => false,
                );
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            ListTile(
              title: const Text('Evacuation Guides'),
              selected: _selectedIndex == 2,
              onTap: () {
                Navigator.pop(context); // Close the drawer after navigation if needed.
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            ListTile(
              title: const Text('Emergency Hotlines'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.pop(context); // Close the drawer after navigation if needed.
                setState(() {
                  _selectedIndex = 3;
                });
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                bool logout = await _onBackPressed(context);
                if (logout) {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginPage.loginPage,
                        (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () => _onBackPressed(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final userData = snapshot.data?.data();
                  final username = userData?['name'] ?? 'User';
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Welcome, $username!",
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _sendEmergencySignal(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    child: Text(
                      "Emergency",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('news').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final newsList = snapshot.data?.docs ?? [];
                  return GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    padding: const EdgeInsets.all(16.0),
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(newsList.length, (index) {
                      final newsData = newsList[index].data();
                      final title = newsData['Title'] ?? '';
                      final description = newsData['Description'] ?? '';
                      return _buildNewsSection(context, title, description);
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsSection(BuildContext context, String sectionTitle, String newsContent) {
    const int maxChars = 50;
    String truncatedContent =
    newsContent.length > maxChars ? '${newsContent.substring(0, maxChars)}...' : newsContent;

    return GestureDetector(
      onTap: () {
        _showNewsDialog(context, sectionTitle, newsContent);
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sectionTitle,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              truncatedContent,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewsDialog(BuildContext context, String sectionTitle, String newsContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            sectionTitle,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            newsContent,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
