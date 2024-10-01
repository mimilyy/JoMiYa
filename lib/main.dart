import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
//mapping package for Flutter, personnalisable
import 'package:latlong2/latlong.dart';
//library for common latitude and longitude calculation

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Projet 2A - Jovenet, Militon, Yao'),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const [
            BottomNavigationBarItem(
              label: 'Carte',
              icon: Icon(
                Icons.home,
                color: Colors.lightBlue,),
            ),
            BottomNavigationBarItem(
              label: 'Favoris',
              icon: Icon(
                Icons.favorite,
                color: Colors.pink,
              ),
            )
          ],
      ),
      body: content(),
    );
  }

  Widget content() {
    return FlutterMap(
      options: const MapOptions(initialCenter: LatLng(48.864716, 2.349014), //Latitude et longitude de Paris
      initialZoom: 11,
      interactionOptions: 
          InteractionOptions(flags: ~InteractiveFlag.doubleTapDragZoom),
          ),
      children: [
        openStreetMapTileLayer,
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);