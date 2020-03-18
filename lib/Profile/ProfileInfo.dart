
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gymforce/DataModel/UserInfoModel.dart';
import 'package:gymforce/DataService/FireStoreService.dart';
import 'package:gymforce/DataService/SharedPref.dart';
import 'package:gymforce/LocationTrackerState/LocationTrackerState.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../ConfigScreen.dart';

const api = "AIzaSyDuP1jyx4u74ECQ1FwAt1i5JBa3M6AqaQ0";

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final myController = TextEditingController();
  File _image;
  String _uploadedFileURL;
  FireStoreService fireStoreService = FireStoreService();
  SharedPref sharedPref = SharedPref();
  String gotLoc;
  String gotLocAsAddress;

  @override
  Future<void> initState() {
    super.initState();
    // getting the location which is saved in shared pref,
    if (gotLoc == null) {
      sharedPref.getLocation("locations").then((List<String> s) => setState(() {
        gotLoc = s[0];
      }));
    }

    if (gotLocAsAddress == null) {
      sharedPref
          .getLocationAsAddress("address")
          .then((String s) => setState(() {
        gotLocAsAddress = s;
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final user = Provider.of<UserModel>(context);
    final appState = Provider.of<LocationTrackerState>(context);
    appState.addressTextController.text = gotLocAsAddress;
    ProgressDialog pr;
    pr = new ProgressDialog(context);

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print('Image Path $_image');
      });
      if (_image != null) {
        pr.show();
        Future.delayed(Duration(seconds: 10)).then((value) {
          pr.hide();
        });
        StorageReference storageReference = FirebaseStorage.instance
            .ref()
            .child('chats/${Path.basename(_image.path)}}');
        StorageUploadTask uploadTask = storageReference.putFile(_image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        print("please waittttttttttttt UPLOADING");

        print('File Uploaded');
        await storageReference.getDownloadURL().then((fileURL) {
          setState(()async {
            _uploadedFileURL = fileURL;
            await  fireStoreService.updateUserImage(_uploadedFileURL);
          });
        });

      }
    }

//    Future uploadFile() async {
//      StorageReference storageReference = FirebaseStorage.instance
//          .ref()
//          .child('chats/${Path.basename(_image.path)}}');
//      StorageUploadTask uploadTask = storageReference.putFile(_image);
//      StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
//
//      print('File Uploaded');
//      storageReference.getDownloadURL().then((fileURL) {
//        setState(() {
//          _uploadedFileURL = fileURL;
//          fireStoreService.updateUserImage(_uploadedFileURL);
//        });
//      });
//    }

    Future updateTheName(String updateName) async {
      String searchKey = updateName.substring(0, 1).toUpperCase();
      fireStoreService.updateUserName(updateName, searchKey);
    }

    return StreamBuilder<UserInfoModel>(
        stream: FireStoreService(uid: user.uid).userInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserInfoModel userInfoModel = snapshot.data;
            // myController.text = userInfoModel.name;
            return SafeArea(
              child: Scaffold(
                // resizeToAvoidBottomInset: false,
                backgroundColor: Color.fromARGB(255, 240, 240, 240),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          color: Color.fromARGB(255, 238, 238, 238),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(20, 10),
                              color: Color.fromARGB(50, 0, 0, 0),
                              blurRadius: 30,
                            ),
                            BoxShadow(
                                offset: Offset(-10, -10),
                                color: Color.fromARGB(150, 255, 255, 255),
                                blurRadius: 10)
                          ],
                        ),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 5,
                              bottom: 5,
                              child: CircleAvatar(
                                radius: 70.0,
                                backgroundImage:
                                NetworkImage(userInfoModel.imageUrl),
                              ),
                            ),
                            Positioned(
                              top: 60,
                              left: 70,
                              child: Padding(
                                padding: EdgeInsets.all(30),
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.camera,
                                    size: 31.0,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    getImage();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(255, 238, 238, 238),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(20, 10),
                              color: Color.fromARGB(50, 0, 0, 0),
                              blurRadius: 30,
                            ),
                            BoxShadow(
                                offset: Offset(-10, -10),
                                color: Color.fromARGB(150, 255, 255, 255),
                                blurRadius: 10)
                          ],
                        ),
                        margin: EdgeInsets.all(20),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: TextField(
                            onSubmitted: (String n) {
                              setState(() {
                                updateTheName(n);
                              });
                            },
                            decoration: InputDecoration(
                              labelText: userInfoModel.name,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  borderSide:
                                  BorderSide(color: Color(0xff476cfb))),
                            ),
                          ),
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 50),
                              child: Text('Example: Gym name  Street name  City name',style: TextStyle(
                                color: Colors.grey,
                              ),)),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromARGB(255, 238, 238, 238),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(20, 10),
                                  color: Color.fromARGB(50, 0, 0, 0),
                                  blurRadius: 30,
                                ),
                                BoxShadow(
                                    offset: Offset(-10, -10),
                                    color: Color.fromARGB(150, 255, 255, 255),
                                    blurRadius: 10)
                              ],
                            ),
                            margin: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 50),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: TextField(
                                onSubmitted: ( String n) {
                                  setState(() {
                                    appState.addressTextController.text =n;
                                    appState.onLookupCoordinatesPressed(context);
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: gotLocAsAddress ==null || gotLocAsAddress== ''? 'Update Location':gotLocAsAddress,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                      borderSide:
                                      BorderSide(color: Color(0xff476cfb))),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
