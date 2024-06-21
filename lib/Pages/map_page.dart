import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp();
    // return const FlutterMap(
    //   options: MapOptions(
    //     initialCenter: LatLng(51.509364, -0.128928),
    //     initialZoom: 9.2,
    //   ),
    //   children: [
    //     TileLayer(
    //       urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    //       userAgentPackageName: 'com.example.app',
    //     ),
    //   RichAttributionWidget(
    //     attributions: [
    //       TextSourceAttribution(
    //         'OpenStreetMap contributors',
    //         onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
    //       ),
    //     ],
    //   ),
    // ],

    // );
  }
}