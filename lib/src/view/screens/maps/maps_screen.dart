// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:location/location.dart';

// import '../../components/custom_arrow_back.dart';
// import '../../components/custom_progress_indicator.dart';
// import '../../components/shared/screens_size.dart';
// import '../shipping/address_screen.dart';

// class MapsScreen extends StatefulWidget {
//   const MapsScreen({Key? key}) : super(key: key);

//   @override
//   _MapsScreenState createState() => _MapsScreenState();
// }

// class _MapsScreenState extends State<MapsScreen> {
//   List<Marker> _markers = [];
//   late LatLng currentLatLng;
//   late CameraPosition initialCameraPosition;
//   Location location = Location();
//   late LocationData _location;
//   late LocationData _locationResult;
//   String currentAddress = "";

//   Future<LocationData> _getLocation() async {
//     _locationResult = await location.getLocation();
//     setState(() {
//       _location = _locationResult;
//     });
//     return _location;
//   }

//   _handleTap(LatLng position) {
//     setState(() {
//       _markers = [];
//       getAddressFromLatLng(context, position.latitude, position.longitude);
//       _markers.add(
//         Marker(
//           markerId: MarkerId(currentLatLng.toString()),
//           draggable: true,
//           position: position,
//           onDragEnd: (value) {
//             setState(() {
//               currentLatLng = LatLng(
//                 _location.latitude!,
//                 _location.longitude!,
//               );
//             });
//           },
//         ),
//       );
//     });
//   }

//   var mapApiKey = "AIzaSyCip2iu9I3ByUgsR80a6EmNapc97dtY4B0";
//   Future<String> getAddressFromLatLng(context, double? lat, double? lng) async {
//     String _host = 'https://maps.google.com/maps/api/geocode/json';
//     final url = '$_host?key=$mapApiKey&language=ar&latlng=$lat,$lng';
//     if (lat != null && lng != null) {
//       var response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         Map data = jsonDecode(response.body);
//         currentAddress = data["results"][0]["formatted_address"];
//       }
//     }
//     return currentAddress;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getLocation().then((value) {
//       getAddressFromLatLng(context, value.latitude, value.longitude);
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScreenSize().init(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Delivery location"),
//         leading: CustomArrowBack(ctx: context),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: FutureBuilder<LocationData>(
//               future: _getLocation(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData && snapshot.data != null) {
//                   initialCameraPosition = CameraPosition(
//                     target: LatLng(
//                       snapshot.data!.latitude!,
//                       snapshot.data!.longitude!,
//                     ),
//                     zoom: 15.0,
//                   );
//                   currentLatLng = LatLng(
//                     snapshot.data!.latitude!,
//                     snapshot.data!.longitude!,
//                   );
//                   if (_markers.isEmpty) {
//                     _markers.add(
//                       Marker(
//                         markerId: MarkerId(currentLatLng.toString()),
//                         draggable: true,
//                         position: currentLatLng,
//                         onDragEnd: (value) {
//                           setState(() {
//                             currentLatLng = LatLng(
//                               _location.latitude!,
//                               _location.longitude!,
//                             );
//                           });
//                         },
//                       ),
//                     );
//                   }
//                   return GoogleMap(
//                     myLocationEnabled: true,
//                     myLocationButtonEnabled: true,
//                     mapType: MapType.normal,
//                     markers: Set.from(_markers),
//                     initialCameraPosition: initialCameraPosition,
//                     onTap: _handleTap,
//                   );
//                 }
//                 return const CustomProgressIndicator();
//               },
//             ),
//           ),

//           // Delivery here button
//           Container(
//             alignment: Alignment.center,
//             height: 110.0,
//             decoration: const BoxDecoration(
//               color: Colors.white,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Text(
//                   currentAddress,
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   // alignment: Alignment.center,
//                   width: ScreenSize.screenWidth! * 0.90,
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddressScreen(
//                             hasButton: true,
//                             mapAddress: currentAddress,
//                           ),
//                         ),
//                       );
//                     },
//                     child: const Text('Delivery here'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
