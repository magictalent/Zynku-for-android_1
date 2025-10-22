import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final TextEditingController _searchController = TextEditingController();
  late GoogleMapController _mapController;
  LatLng _initialPosition = const LatLng(
    28.6139,
    77.2090,
  ); // Default: New Delhi
  Set<Marker> _markers = {};

  // Dummy search function for builder
  void _searchBuilder() {
    FocusScope.of(context).unfocus();
    String keyword = _searchController.text.trim();

    // Example: Place a random marker for illustration
    if (keyword.isNotEmpty) {
      setState(() {
        _markers.clear();
        // This would normally use a real builder search result with coordinates
        _markers.add(
          Marker(
            markerId: MarkerId('builder_1'),
            position: LatLng(
              _initialPosition.latitude + 0.01,
              _initialPosition.longitude + 0.01,
            ),
            infoWindow: InfoWindow(title: "Builder: $keyword"),
          ),
        );
      });
      _mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            _initialPosition.latitude + 0.01,
            _initialPosition.longitude + 0.01,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Builder on Map'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Builder',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (_) => _searchBuilder(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _searchBuilder,
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 12,
              ),
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: true,
              markers: _markers,
            ),
          ),
        ],
      ),
    );
  }
}
