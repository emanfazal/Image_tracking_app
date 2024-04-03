import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar:AppBar(
        title: Text('Google maps'),
        backgroundColor: Colors.orange[300],
      ) ,
      body: Padding(
        padding: const EdgeInsets.only(top: 40,left: 40,right: 40),
        child: Container(
          height: 500,
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), // Set border radius here
            border: Border.all(
              color: Colors.black, // Set border color here
              width: 1.0, // Set border width here
            ),
          ),
          child: GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (GoogleMapController controller){
              _controller=controller;
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(33.6844, 73.0479),
              zoom: 14,
            ),
            mapType: MapType.normal,
            markers: <Marker>{
              const Marker(
                markerId: MarkerId('marker 1'),
                position: LatLng(33.6844, 73.0479),
                infoWindow: InfoWindow(title: 'marker 2'),),
            },
          ),
        ),
      ),
    );

  }
}