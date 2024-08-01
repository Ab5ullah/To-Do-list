import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_to_do_app/utils/app_colors.dart';

class User_Profile extends StatelessWidget {
  @override
  String imageURL = '';
  String ImageUrl = '';

  final imageContainerHeight = 350.0;
  final imageContainerWidth = 400.0;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image:
                AssetImage("img/welcome.jpg"), // Replace with your image path
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 60.0,
              backgroundColor:
                  Colors.grey, // Set background color for the circle avatar
              child: SizedBox(
                height: imageContainerHeight, // Define the desired height
                width: imageContainerWidth, // Define the desired width
                child: ImageUrl.isNotEmpty
                    ? Image.network(
                        ImageUrl,
                        fit:
                            BoxFit.cover, // Adjust the fit based on your design
                      )
                    : Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ), // Show an icon if ImageUrl is empty
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 150,
              decoration: BoxDecoration(
                color: AppColors.textGrey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      print('${file?.path}');
                      if (file == null) return;
                      //unique file name
                      String uniqueFilename =
                          DateTime.now().microsecondsSinceEpoch.toString();
                      //Get reference to storage root
                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          FirebaseStorage.instance.ref().child('images');
                      //create a reference for the image to be stored
                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFilename);
                      try {
                        //store the file
                        await referenceImageToUpload.putFile(File(file.path));
                        imageURL =
                            await referenceImageToUpload.getDownloadURL();
                      } catch (error) {}
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt,
                            color: Colors.black), // Set icon color to black
                        SizedBox(width: 8),
                        Text(
                          'Add Image',
                          style: TextStyle(
                              color: Colors.black), // Set text color to black
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Add some spacing
            Text(
              'Flutter Developer',
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: 'SourceSansPro',
                color: AppColors.smallTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            ContactCard(
              icon: Icons.phone,
              text: '+229 96119149',
            ),
            ContactCard(
              icon: Icons.email,
              text: 'fadcrepin@gmail.com',
            ),
          ],
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle the onTap action here
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.teal,
          ),
          title: Text(
            text,
            style: TextStyle(
              fontFamily: 'SourceSansPro',
              fontSize: 20,
              color: Colors.teal.shade900,
            ),
          ),
        ),
      ),
    );
  }
}
