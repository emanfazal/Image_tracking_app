import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:flutter/material.dart';

import 'Components/ImageFromGalleryContainer.dart';
import 'HomeScreen.dart';
class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;
  ImageContainer imageContainer=ImageContainer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UploadImageScreen'),
      ),
body: SingleChildScrollView(
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Center(
         child: ImageContainer(),
      ),
     SizedBox(height: 30,),


      ElevatedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder:  (context)=>HomeScreen()));
      }, child:Text('Show Map')),



    ],
  ),
),
    );
  }
}
