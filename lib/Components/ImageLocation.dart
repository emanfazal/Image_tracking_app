import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class ImageLocation extends StatefulWidget {
  @override
  _ImageLocationState createState() => _ImageLocationState();
}

class _ImageLocationState extends State<ImageLocation> {
  late GoogleMapController _controller;
  bool isListVisible = false;
  bool mapVisible = false;
  File? _image;
  bool _uploading = false;
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  LatLng? _selectedLocation;
  ImagePicker picker = ImagePicker();
  List<Marker> markers = [];
  List<String> uploadedImageURLs = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Location location = Location();
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      LocationData currentLocation = await location.getLocation();

      setState(() {
        _selectedLocation = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> _uploadImage() async {
    setState(() {
      _uploading = true;
    });

    try {
      if (_image != null) {
        String? fileExtension = _image!.path.split('.').last;
        String fileName = '$uniqueFileName.$fileExtension';

        firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(fileName);
        firebase_storage.UploadTask uploadTask = ref.putFile(
          _image!,
          firebase_storage.SettableMetadata(
            contentType: 'image/$fileExtension',
            customMetadata: <String, String>{
              'uploaded_by': 'user_id',
              'timestamp': DateTime.now().toString(),
              'latitude': _selectedLocation!.latitude.toString(),
              'longitude': _selectedLocation!.longitude.toString(),
            },
          ),
        );

        await uploadTask.whenComplete(() async {
          String imageUrl = await ref.getDownloadURL();

          setState(() {
            _uploading = false;
            _image = null;
            isListVisible = true; // Set list visible after upload
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image uploaded successfully!'),
            ),
          );

          _addMarkerToMap(_selectedLocation!, imageUrl);
          uploadedImageURLs.add(imageUrl);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select an image first.'),
          ),
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
      setState(() {
        _uploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading image. Please try again later.'),
        ),
      );
    }
  }

  Future<void> _addMarkerToMap(LatLng position, String imageUrl) async {
    Uint8List imageData = await _getImageDataFromUrl(imageUrl);

    // Set your desired height and width for the custom marker
    double markerHeight = 0.0;
    double markerWidth = 0.0;

    // Create a resized image
    ui.Image? resizedImage;
    try {
      resizedImage = await decodeImageFromList(imageData);
    } catch (e) {
      print('Error decoding image: $e');
    }

    if (resizedImage != null) {
      // Convert ByteData to Uint8List
      ByteData? byteData =
      await resizedImage.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      if (pngBytes != null) {
        // Create a bitmap descriptor from the resized image
        BitmapDescriptor customMarker = BitmapDescriptor.fromBytes(
          pngBytes,
          size: Size(markerWidth, markerHeight),
        );

        setState(() {
          markers.add(
            Marker(
              markerId: MarkerId(position.toString()),
              position: position,
              icon: customMarker,
              infoWindow: InfoWindow(
                title: 'Uploaded Image',
                snippet: 'Click to view image',
              ),
            ),
          );
        });
      }
    }
  }

  Future<Uint8List> _getImageDataFromUrl(String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Failed to load image: ${response.statusCode}');
        return Uint8List(0);
      }
    } catch (e) {
      print('Error loading image: $e');
      return Uint8List(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[100],
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        shadowColor: Colors.green,
        title: Text(
          'Google Map Image Location',
          style: TextStyle(color: Colors.deepPurple, fontSize: 18),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectImage(ImageSource.gallery),
              child: Text('Select Image from Gallery'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectImage(ImageSource.camera),
              child: Text('Capture Image from Camera'),
            ),
            SizedBox(height: 20),
            if (_uploading)
              CircularProgressIndicator(),
            if (isListVisible)
              Expanded(
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: uploadedImageURLs.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 200,
                        width: 200,
                        child: Card(
                          child: Image.network(uploadedImageURLs[index],height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mapVisible = !mapVisible;
                });
              },
              child: Text('Show Image Location'),
            ),
            SizedBox(height: 20),
            Visibility(
              visible: mapVisible,
              child: Container(
                height: 440,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation ?? LatLng(0, 0),
                    zoom: 14,
                  ),
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(markers),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }
}
