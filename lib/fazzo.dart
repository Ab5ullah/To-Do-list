import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _imageUrl;
  User? _user;
  String? fullName;
  String? _email;
  io.File? _imageFile;
  String? bio;
  String? location;
  Timestamp? dob;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    if (_user != null) {
      _emailController.text = _user!.email!;
      _fetchUserData();
    } else {
      print("No user is currently signed in.");
    }
  }

  void _fetchUserData() async {
    if (_user == null) return;
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          fullName = snapshot['fullName'];
          _email = snapshot['email'];
          _imageUrl = snapshot['imageUrl'];
          fullNameController.text = fullName ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _showEditAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User Account'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEditField(Icons.person, 'Username', fullNameController),
                _buildEditField(Icons.email, 'Email', _emailController),
                _buildEditField(
                  Icons.lock,
                  'Password',
                  _passwordController,
                  isPassword: true,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _updateUserData();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditField(
    IconData icon,
    String label,
    TextEditingController controller, {
    bool isPassword = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Future<void> _updateUserData() async {
    if (_user == null) return;

    String newUsername = fullNameController.text.trim();
    String newEmail = _emailController.text.trim();
    String newPassword = _passwordController.text.trim();

    try {
      // Update email
      if (newEmail.isNotEmpty && newEmail != _email) {
        await _user!.updateEmail(newEmail);
        await _user!.sendEmailVerification();
      }

      // Update password
      if (newPassword.isNotEmpty) {
        await _user!.updatePassword(newPassword);
      }

      // Upload image if it exists
      String imageUrl = _imageUrl ?? '';
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }

      // Update user data with image URL
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(_user!.uid);

      // Check if the user data document exists
      bool userDataExists = (await userRef.get()).exists;

      // If user data document doesn't exist, create it
      if (!userDataExists) {
        await userRef.set({
          'fullName': newUsername,
          'email': newEmail,
          'imageUrl': imageUrl,
        });
      } else {
        // If user data document exists, update it
        await userRef.update({
          'fullName': newUsername,
          'email': newEmail,
          'imageUrl': imageUrl,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile: $e'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: SingleChildScrollView(
            child: Text('Are you sure you want to sign out?'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/getstarted',
                  (route) => false,
                );
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  Future<String> _uploadImage(io.File imageFile) async {
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref =
        FirebaseStorage.instance.ref().child('images/$imageName.jpg');
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot storageTaskSnapshot = await uploadTask;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void _removeImageFromStorage(String imageUrl) {
    Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
    ref.delete().then((_) {
      print("Image deleted successfully!");
    }).catchError((error) {
      print("Error deleting image: $error");
    });
  }

  void _handleImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      io.File imageFile = io.File(pickedFile.path);
      String imageUrl = await _uploadImage(imageFile);
      setState(() {
        _imageFile = imageFile;
        _imageUrl = imageUrl;
      });
    }
  }

  void _changeProfilePicture() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Update Image'),
                onTap: () {
                  Navigator.pop(context);
                  _handleImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Add Image'),
                onTap: () {
                  Navigator.pop(context);
                  _handleImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Remove Image'),
                onTap: () {
                  Navigator.pop(context);
                  if (_imageUrl != null) {
                    _removeImageFromStorage(_imageUrl!);
                    setState(() {
                      _imageFile = null;
                      _imageUrl = null;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelpAndSupportDialog() {
    String query = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Help and Support'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  maxLines: 3,
                  onChanged: (value) {
                    query = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your problem or query...',
                  ),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    _sendQueryToSupport(query);
                    Navigator.of(context).pop();
                  },
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _sendQueryToSupport(String query) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('User not logged in.');
      return;
    }

    final String username = 'your_email@gmail.com'; // replace with your email

    // Sending the query to support (This is a placeholder. Implement your own method to send the query)
    print('Query sent to support: $query');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _showEditAccountDialog,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _showSignOutDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_imageUrl != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_imageUrl!),
                )
              else
                CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _changeProfilePicture,
                child: Text('Change Profile Picture'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _showHelpAndSupportDialog,
                child: Text('Help and Support'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
