import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:location/location.dart' as location;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class RegisterPage extends StatefulWidget {
  static const String registerPage = '/register';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  Position? currentLocation;

  DateTime? lastBackPressedTime;

  Future<void> _registerWithEmailAndPassword(BuildContext context) async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String contactNumber = _contactNumberController.text.trim();
    final String location = _locationController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty||
        contactNumber.isEmpty||
        location.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill in all the fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (password != confirmPassword) {
      Fluttertoast.showToast(
        msg: "Password do not match! Please retype again",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
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
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      Navigator.pop(context);

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Store user data in Firestore
      final newUser = {
        'name': name,
        'email': email,
        'contact_number': contactNumber,
        'location': location,
      };
      await _usersCollection.doc(userCredential.user!.uid).set(newUser);

      // ignore: use_build_context_synchronously

      Fluttertoast.showToast(
        msg: "Registration Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Future.delayed(const Duration(seconds: 2), () {
        // Replace the below line with your desired page navigation
        // For example, to navigate to the RegisterPage:
        Navigator.pushNamed(context, LoginPage.loginPage);
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Email already Exist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _getLocation() async {

    bool _serviceEnabled;
    LocationPermission _permissionGranted;

    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if(!_serviceEnabled){
        return;
      }


    _permissionGranted = await Geolocator.checkPermission();
    if(_permissionGranted == LocationPermission.denied){
      _permissionGranted = await Geolocator.requestPermission();
      if(_permissionGranted != LocationPermission.denied){
        return;
      }
    }

    if(_permissionGranted == LocationPermission.deniedForever){
      return;
    }

    Position _position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    List<geocoding.Placemark>? placemarks = await geocoding.placemarkFromCoordinates(
        _position.latitude,
        _position.longitude,
    );
    geocoding.Placemark place = placemarks.first;


    // String name = "${place.name}";
    // RegExp regExp = RegExp(r'Blk\s+(\d+)\s*(L(\d+))?', caseSensitive: false);
    // RegExpMatch? match = regExp.firstMatch(name);
    // String? block = match?.group(1);
    // String? lot = match?.group(3);
    if (placemarks != null && placemarks.isNotEmpty){

      String address =
          " ${_position.latitude}, ${_position.longitude}, ${place.thoroughfare}, ${place.subLocality} ${place.locality}, ${place.administrativeArea}, ${place.country}";
      setState(() {
        currentLocation = _position;
        _locationController.text = address;
      });
    }else{
      setState(() {
        currentLocation = _position;
        _locationController.text = "Location not available";
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[200]!, Colors.blue[400]!],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Disaster Readiness Monitoring Application",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24.0),
                const Text(
                  "Register for your Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 36.0),
                TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "User Name",
                    prefixIcon: const Icon(Icons.man_2_rounded, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "User Email",
                    prefixIcon: const Icon(Icons.mail_rounded, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                TextField(
                  controller: _contactNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Contact Number",
                    prefixIcon: const Icon(Icons.phone, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 18.0),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      controller: _locationController,
                      keyboardType: TextInputType.streetAddress,
                      decoration: InputDecoration(
                        hintText: "Address/Location",
                        prefixIcon: const Icon(Icons.location_city, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: ()  {
                            _getLocation();
                        },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 8.0,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Get Location"),
                    )
                  ],
                ),
                const SizedBox(height: 26.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "User Password",
                    prefixIcon:
                    const Icon(Icons.security_rounded, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 26.0),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Confirm Password",
                    prefixIcon:
                    const Icon(Icons.security_rounded, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 88.0),
                ElevatedButton(
                  onPressed: () {
                    _registerWithEmailAndPassword(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 8.0,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Register"),
                ),
                const SizedBox(height: 12.0),
                const SizedBox(height: 12.0),
                Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    children: [
                      TextSpan(
                        text: "Login Here",
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              LoginPage.loginPage,
                                  (Route<dynamic> route) => false,
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
