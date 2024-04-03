import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import 'ImageLocation.dart';
import 'package:exif/exif.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({Key? key}) : super(key: key);

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  bool ismapVisible=false;
  List<File> _images = [];
  String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
  final picker = ImagePicker();
  String? downloadedImageURL;

  Future<void> getGalleryImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
      } else {
        print('No Image Selected');
      }
    });
  }

  Future<void> uploadImages() async {
    try {
      for (var image in _images) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Specify the content type (image format)
        String contentType = 'image/jpeg'; // Example: JPEG format

        firebase_storage.SettableMetadata metadata =
            firebase_storage.SettableMetadata(
          contentType: contentType,
          customMetadata: {
            'latitude': position.latitude.toString(),
            'longitude': position.longitude.toString(),
          },
        );

        String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

        // Upload image to Firebase Storage with specified format
        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref('/images/$fileName');

        firebase_storage.UploadTask uploadTask = ref.putFile(image, metadata);

        await uploadTask.whenComplete(() async {
          // Fetch metadata of the uploaded image
          firebase_storage.FullMetadata uploadedMetadata =
              await ref.getMetadata();

          // Extract latitude and longitude from the metadata
          double? latitude =
              double.tryParse(uploadedMetadata.customMetadata!['latitude']!);
          double? longitude =
              double.tryParse(uploadedMetadata.customMetadata!['longitude']!);

          print('Latitude: $latitude, Longitude: $longitude');
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed:(){
      getGalleryImage();
      setState(() {

      });
    },
          child: Text('Select Image from Gallery'),
        ),
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: Center(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  height: 300,
                  width: 200,
                  child: Column(
                    children: [
                      Image.file(
                        _images[index],
                        width: 100,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Fetch metadata of the uploaded image
                          firebase_storage.FullMetadata uploadedMetadata =
                          await firebase_storage.FirebaseStorage.instance
                              .ref('/images/$fileName')
                              .getMetadata();

                          // Extract latitude and longitude from the metadata
                          double? latitude =
                          double.tryParse(uploadedMetadata.customMetadata!['latitude']!);
                          double? longitude =
                          double.tryParse(uploadedMetadata.customMetadata!['longitude']!);

                          if (latitude != null && longitude != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageLocation(
                                  // latitude: latitude,
                                  // longitude: longitude,
                                  // imageUrl: uploadedMetadata.fullPath,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text('Show image location'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _images.isEmpty ? null : uploadImages,
                        child: Text('Upload Images'),
                      ),




                    ],
                  ),
                );
              },
            ),
          ),
        ),

        SizedBox(height: 20),
        if (downloadedImageURL != null)
          Image.network(
            downloadedImageURL!,
            width: 100,
            height: 200,
          )

      ],
    );
  }
}
