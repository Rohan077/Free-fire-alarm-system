import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'card.dart';
import 'homepage.dart';
import 'package:flutter_config/flutter_config.dart';

var lat,long;

Future<List<Images>> fetchPhotos(http.Client client) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  if(myController.text.isEmpty){
  Position position = await Geolocator .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  lat=position.latitude;
  long = position.longitude;
  print(position.latitude);
  print(position.longitude);
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  update= placemarks[0].street!;
  print(placemarks[0].street);}

  else{
    List<Location> locations = await locationFromAddress("${myController.text},India");
    print(locations[0]);
    lat =locations[0].latitude;
    long=locations[0].longitude;
  }


  final response = await client.get(Uri.parse(
      FlutterConfig.get('API_URL')+
      "&ll=@$lat,$long,15.1z&type=search&"
      "api_key="+FlutterConfig.get('API_KEY')));
  // print(response.body);

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Images> parsePhotos(String responseBody) {
  List<Images> list;
  var data = json.decode(responseBody);
  var rest = data["local_results"] as List;
  // print(rest);
  list = rest.map<Images>((json) => Images.fromJson(json)).toList();

  print("List Size: ${list.length}");
  return list;
}

class Images {
  final String title;
  final String phone;
  final String? thumbnail;

  Images({
    required this.title,
    required this.thumbnail,
    required this.phone,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      thumbnail: json['thumbnail']?? "https://www.ssf.net/home/showpublishedimage/3118/636396008145370000",
      title: json['title']?? "Fire Station",
      phone: json['phone']?? '100',
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<Images> photos;

  PhotosList({Key? key, required this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          // scrollDirection: Axis.horizontal,
          // shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: photos.length,
          itemBuilder: (context, index) {
            return Container(
              child: ListCard(
                title: photos[index].title.isEmpty
                    ? "Fire Station"
                    : photos[index].title,
                url: photos[index].thumbnail!,
                phone: photos[index].phone,
                whatsapp: photos[index].phone,
              ),
            );
          }),
    );
  }
}
