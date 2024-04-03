import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission_handler package

import 'Components/ImageFromGalleryContainer.dart';
import 'Components/ImageLocation.dart';
import 'HomeScreen.dart';
import 'UploadImage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await requestLocationPermission();
  runApp(MyGoogleMap());
}

class MyGoogleMap extends StatelessWidget {
  const MyGoogleMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ImageLocation(),
      ),
    );
  }
}

// Function to request location permission
Future<void> requestLocationPermission() async {

  PermissionStatus status = await Permission.location.request();

  if (status.isDenied) {

  }
}
