import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(27.68459215436211, 85.31703932985955),
    zoom: 19.151926040649414,
  );

  String? maptheme;
  Future<void> setStyle() async {
    final style = await rootBundle.loadString('raw/mapdesign.json');
    if (mounted) {
      setState(() {
        maptheme = style;
      });
    }
  }

  bool showmaps = false;
  bool showbottomcard = true;
  void delayfunction() {
    Future.delayed(const Duration(seconds: 3)).whenComplete(() {
      if (mounted) {
        setState(() {
          showmaps = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    delayfunction();
    setStyle();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          showmaps == false
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  mapType: MapType.normal,
                  style: maptheme,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controller.isCompleted) {
                      _controller.complete(controller);
                    }
                  },
                  markers: {
                    Marker(
                      infoWindow: const InfoWindow(
                        title: "PCPS",
                        snippet: "This is us",
                      ),
                      markerId: const MarkerId("1"),
                      onTap: () {
                        setState(() {
                          showbottomcard = !showbottomcard;
                        });
                      },
                      position: const LatLng(27.68449167191457, 85.31691690915865),
                    ),
                  },
                ),
          Positioned(
            bottom: 70,
            child: showbottomcard
                ? Row(
                    children: [
                      Container(
                        color: Colors.grey,
                        margin: const EdgeInsets.all(30),
                        height: size.height / 4,
                        width: size.width / 1.2,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the pcps!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
