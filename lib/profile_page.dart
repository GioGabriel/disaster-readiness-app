import 'package:disaster_readiness_application/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:disaster_readiness_application/login_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilePage extends StatefulWidget {
  static const String profilepage = '/profile';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _displayName;
  String? _location;
  String? _contactNumber;
  int _selectedIndex = 1;

  Future<void> _loadUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final DocumentSnapshot userSnapshot =
      await _firestore.collection('users').doc(user.uid).get();
      if (userSnapshot.exists) {
        setState(() {
          _displayName = userSnapshot['name'];
          _location = userSnapshot['location'];
          _contactNumber = userSnapshot['contact_number'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _deleteAccount() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        await user.delete();
        Navigator.pushNamedAndRemoveUntil(
            context, LoginPage.loginPage, (route) => false);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> _sendChangePasswordEmail() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        await _auth.sendPasswordResetEmail(email: user.email!);
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: 'Change password email sent to ${user.email}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LandingPage.landingPage,
                      (route) => false,
                );
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              title: const Text('Profile'),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.pop(context);
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
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  ProfilePage.profilepage,
                      (route) => false,
                );
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            ListTile(
              title: const Text('Emergency Hotlines'),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  ProfilePage.profilepage,
                      (route) => false,
                );
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
      body: Center( // Center the Card and Buttons
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Center the content inside the Card
                    children: [
                      const Text(
                        'Name:',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Text(
                        _displayName ?? 'Loading...',
                        style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Email:',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Text(
                        _auth.currentUser?.email ?? '',
                        style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Location:',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Text(
                        _location ?? 'Loading...',
                        style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Contact Number:',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Text(
                        _contactNumber ?? 'Loading...',
                        style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center, // Center the buttons vertically
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(
                                    displayName: _displayName,
                                    location: _location,
                                    contactNumber: _contactNumber,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blue, // Match the button color to the text
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 20.0,
                              ),
                            ),
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Delete Account"),
                                    content: const Text(
                                        "Are you sure you want to delete your account?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
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
                                          await _deleteAccount();
                                          Fluttertoast.showToast(
                                            msg: "Account Deleted",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        },
                                        child: const Text("Delete"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Match the button color to the text
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 20.0,
                              ),
                            ),
                            child: const Text(
                              'Delete Account',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Change Password"),
                                    content: const Text(
                                        "Send a change password email to your email address?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
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
                                          await _sendChangePasswordEmail();
                                        },
                                        child: const Text("Send"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // Match the button color to the text
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 20.0,
                              ),
                            ),
                            child: const Text(
                              'Change Password',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



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

class EditProfilePage extends StatefulWidget {
  final String? displayName;
  final String? location;
  final String? contactNumber;

  EditProfilePage({
    this.displayName,
    this.location,
    this.contactNumber,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? _displayName;
  String? _location;
  String? _contactNumber;

  @override
  void initState() {
    super.initState();
    _displayName = widget.displayName;
    _location = widget.location;
    _contactNumber = widget.contactNumber;
  }

  Future<void> _updateUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(user.uid);
      await userRef.update({
        'name': _displayName,
        'location': _location,
        'contact_number': _contactNumber,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _displayName,
                onChanged: (value) {
                  setState(() {
                    _displayName = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _location,
                onChanged: (value) {
                  setState(() {
                    _location = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Location',
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _contactNumber,
                onChanged: (value) {
                  setState(() {
                    _contactNumber = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _updateUserData();
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//For Changing Password inside the profile page
// class ChangePasswordPage extends StatefulWidget {
//   @override
//   _ChangePasswordPageState createState() => _ChangePasswordPageState();
// }

// class _ChangePasswordPageState extends State<ChangePasswordPage> {
//   String? _newPassword;
//
//   // Function to change the user's password using Firebase
//   Future<void> _changePassword() async {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         await user.updatePassword(_newPassword!);
//         Fluttertoast.showToast(
//           msg: 'Password Changed Successfully',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//           fontSize: 16.0,
//         );
//       } catch (e) {
//         // Handle password change error
//         print(e.toString());
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Change Password'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 onChanged: (value) {
//                   setState(() {
//                     _newPassword = value;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'New Password',
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   _changePassword();
//                 },
//                 child: const Text('Change Password'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
