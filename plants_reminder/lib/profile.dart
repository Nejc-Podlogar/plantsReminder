import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:plants_reminder/circular_progress_indicator.dart';
import 'package:plants_reminder/locale_database.dart';
import 'package:plants_reminder/utility.dart';
import 'storage.dart';
import 'package:path_provider/path_provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  State createState() => _Profile();
}

class _Profile extends State<Profile> {
  io.File _image;
  bool _isLoading = false;

  Storage storage = new Storage();

  String username = 'plants_user';
  String email = 'plants_user@gmail.com';
  int numb_of_plants = 5;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });

    storage.readImage('profile_image').then((io.File image) {
      setState(() {
        if (image.path != '') {
          _image = image;
        }
      });
    });

    _getProfileInfo();
  }

  _imgFromCamera() async {
    io.File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });

    final appDir = await getApplicationDocumentsDirectory();
    image.copy('${appDir.path}/profile_image');
  }

  _imgFromGallery() async {
    io.File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });

    final appDir = await getApplicationDocumentsDirectory();
    image.copy('${appDir.path}/profile_image');
  }

  _getProfileInfo() async {
    Map<String, dynamic> map = {};
    map['row_guid'] = await DatabaseHelper.getUserGuid();
    dynamic profile =
        await Utility.httpPostRequest(Utility.getProfileInfo, map);

    print(profile);
    // primer odgovora:
    // {email: dejvidkovac@gmail.com, plants_count: 0, success: true, username: w3m3l}
    if (profile["success"] == true) {
      username = profile["username"];
      email = profile["email"];
      numb_of_plants = profile["plants_count"];
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //return ListView();
    return _isLoading
        ? CustomCircularProgressIndicator()
        : Center(
            child: Container(
              //color: Colors.grey[800],
              child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: CircleAvatar(
                          radius: 55,
                          //backgroundColor: Color(0xffFDCF09),
                          backgroundColor: Theme.of(context).accentColor,
                          child: _image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(
                                    _image,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 100,
                                  height: 100,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[800],
                                  ),
                                ),
                        )),
                    //CircleAvatar(
                    //  foregroundImage: NetworkImage(''), // TODO: lokalna slika pol
                    //  backgroundColor: Colors.blue,
                    //  radius: 40.0,
                    //),
                    SizedBox(height: 5.0),
                    //ElevatedButton(
                    //  child: Text("Click to add/change profile photo"),
                    //  onPressed: () {}, // TODO
                    //),
                    SizedBox(height: 30.0),
                    Text(
                      "USERNAME:",
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "$username",
                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "E-MAIL:",
                      style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "$email",
                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "NUMBER OF PLANTS:",
                      style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "$numb_of_plants",
                      style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
