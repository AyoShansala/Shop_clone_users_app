import 'dart:io';
import 'package:amazon_universal_app/global/global.dart';
import 'package:amazon_universal_app/splashScreen/my_splash_screen.dart';
import 'package:amazon_universal_app/widgets/custom_text_field.dart';
import 'package:amazon_universal_app/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationTabPage extends StatefulWidget {
  const RegistrationTabPage({super.key});

  @override
  State<RegistrationTabPage> createState() => _RegistrationTabPageState();
}

class _RegistrationTabPageState extends State<RegistrationTabPage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String downloadUrlImage = "";

  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();

  //Take an image from gallery to save profile image.......................
  getImageFromGallery() async {
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgXFile;
    });
  }

  //validate all the fields and image is already exist.....................
  formValidation() async {
    if (imgXFile == null) //image is not selected
    {
      Fluttertoast.showToast(msg: 'Please select an image.');
    } else //image is already selected
    {
      //password is equal to confirm password
      if (passwordTextEditingController.text ==
          confirmPasswordTextEditingController.text) {
        if (nameTextEditingController.text.isNotEmpty &&
            emailTextEditingController.text.isNotEmpty &&
            passwordTextEditingController.text.isNotEmpty &&
            confirmPasswordTextEditingController.text.isNotEmpty) {
          showDialog(
            context: context,
            builder: (c) {
              return LoadingDialogWidget(
                message: "Registering your account",
              );
            },
          );
          //1.upload image to storage
          String fileName = DateTime.now().microsecond.toString();
          fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
              .ref()
              .child("usersImages")
              .child(fileName);

          fStorage.UploadTask uploadImageTask =
              storageRef.putFile(File(imgXFile!.path));

          fStorage.TaskSnapshot taskSnapshot =
              await uploadImageTask.whenComplete(() {});

          taskSnapshot.ref.getDownloadURL().then((urlImage) {
            downloadUrlImage = urlImage;
          });
          //2.save the user info to firestore databse
          saveInformationToDatabse();
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
                  "Please complete the form. Do not leave any text filed empty");
        }
      } else //password is not equal to confirm password
      {
        Fluttertoast.showToast(
            msg: "password and confirm password do not match");
      }
    }
  }

  saveInformationToDatabse() async {
    //authenticate the user first
    User? currentUser;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((errorMessage) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occured: \n $errorMessage");
    });
    if (currentUser != null) {
      //save the information to database and save locally
      saveInfoToFirestoreAndLocally(currentUser!);
    }
  }

  saveInfoToFirestoreAndLocally(User currentUser) async {
    //saveto firestore
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": nameTextEditingController.text.trim(),
      "photoUrl": downloadUrlImage,
      "status": "approved",
      "userCart": ['initialValue'],
    });
    //save locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email!);
    await sharedPreferences!
        .setString("name", nameTextEditingController.text.trim());
    await sharedPreferences!.setString("photoUrl", downloadUrlImage);
    await sharedPreferences!.setStringList("userCart", ['initialValue']);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => MySplashScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            //get-captured image
            GestureDetector(
              onTap: () {
                getImageFromGallery();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage:
                    imgXFile == null ? null : FileImage(File(imgXFile!.path)),
                child: imgXFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        color: Colors.grey,
                        size: MediaQuery.of(context).size.width * 0.20,
                      )
                    : null,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            //input form fields...........................................
            Form(
              key: formKey,
              child: Column(
                children: [
                  //name
                  CustomTextField(
                    textEditingController: nameTextEditingController,
                    iconData: Icons.person,
                    hintText: "Name",
                    isObsecre: false,
                    enabled: true,
                  ),
                  //email
                  CustomTextField(
                    textEditingController: emailTextEditingController,
                    iconData: Icons.email,
                    hintText: "Email",
                    isObsecre: false,
                    enabled: true,
                  ),
                  //password
                  CustomTextField(
                    textEditingController: passwordTextEditingController,
                    iconData: Icons.lock,
                    hintText: "Password",
                    isObsecre: true,
                    enabled: true,
                  ),
                  //conform password
                  CustomTextField(
                    textEditingController: confirmPasswordTextEditingController,
                    iconData: Icons.person,
                    hintText: "Confirm Password",
                    isObsecre: true,
                    enabled: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 12,
                  )),
              onPressed: () {
                formValidation();
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
