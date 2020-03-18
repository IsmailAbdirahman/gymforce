import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gymforce/DataModel/DateTimeMDModel.dart';
import 'package:gymforce/DataModel/EventCalnderModel.dart';
import 'package:gymforce/DataService/FireStoreService.dart';
import 'package:gymforce/DataService/SharedPref.dart';
import 'package:location/location.dart';

import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LocationTrackerState extends ChangeNotifier {
  //database pref
  SharedPref _sharedPref = SharedPref();
  FireStoreService fireStoreService = FireStoreService();

  //map lines
  final Set<Marker> _markers = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Polyline> get polyLines => _polylines;
  Set<Marker> get markers => _markers;
  DateTime get now => _now;
  get gymIconnn => _gymIcon;
  get currentDate => _currentDate;
  get currentDate2 => _currentDate2;
  get location => _location;
  get currentLocationn => _currentLocationn;
  get distanceInMeters => _distanceInMeters;
  get result => _result;
  get sharedPref => _sharedPref;
  get placemarkCoords => _placemarkCoords;

  EventList<EventCalnderModel> get markedDateMappp => _markedDateMap;

  DateTime _currentDate = DateTime(_now.year, _now.month, _now.day);
  DateTime _currentDate2 = DateTime(_now.year, _now.month, _now.day);

  static DateTime _now = new DateTime.now();
  static int year = _now.year;
  static int month = _now.month;
  static int day = _now.day;
  static Widget _gymIcon = new Container(
    decoration: new BoxDecoration(
        color: Color.fromARGB(255, 238, 238, 238),
        borderRadius: BorderRadius.all(Radius.circular(1000)),
        border: Border.all(color: Color(0xff476cfb), width: 2.0)),
    child: new Icon(
      Icons.fitness_center,
      color: Color(0xff476cfb),
      size: 20,
    ),
  );
  final EventList<EventCalnderModel> _markedDateMap =
  EventList<EventCalnderModel>();

  Location _location = Location();
  LocationData _currentLocationn;
  double _distanceInMeters;
  String _result;
  List<DateTimeMDModel> datee;
  StreamSubscription<LocationData> streamSubscription;
  final Geolocator _geolocator = Geolocator();
  TextEditingController addressTextController = TextEditingController();
  List<String> _placemarkCoords = [];


  //Constructor
  LocationTrackerState() {
    updateTheCurrentLocationLive();
  }

  updateTheCurrentLocationLive() async {
    List<String> address = await _sharedPref.getLocation("locations");
    var lati = double.parse(address[0]);
    var longi = double.parse(address[1]);
    LatLng gymLocationn = LatLng(lati, longi);
    streamSubscription =
        location.onLocationChanged().listen((LocationData value) {
          _currentLocationn = value;
          print("The currentLocationn is: $_currentLocationn");
          distanceBetweenTwo(
              _currentLocationn.latitude,
              _currentLocationn.longitude,
              gymLocationn.latitude,
              gymLocationn.longitude);
        });
  }



  Future<void> onLookupCoordinatesPressed(BuildContext context) async {
    await _sharedPref.saveLocationAsAddress(addressTextController.text);
    final List<Placemark> placemarks = await Future(
            () => _geolocator.placemarkFromAddress(addressTextController.text))
        .catchError((onError) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please Enter valid address'),
      ));
      return Future.value(List<Placemark>());
    });

    if (placemarks != null && placemarks.isNotEmpty) {
      final Placemark pos = placemarks[0];
      final List<String> coords = placemarks
          .map((placemark) =>
      pos.position?.latitude.toString() +
          ', ' +
          pos.position?.longitude.toString())
          .toList();
      _placemarkCoords = coords;

      //save gymLocation in shared Prefs
      String lt = pos.position?.latitude.toString();
      String ln = pos.position?.longitude.toString();
      String aLocation = lt + "," + ln;
      await _sharedPref.saveLocation(aLocation);
    }
    notifyListeners();
  }


  // increase The Date
  increaseTheDateTime() async {
    await fireStoreService.saveGymDate(now.year, now.month, now.day);
    notifyListeners();
  }

// calculate the distance between two locations and store the current date if the user reached the gym location
  distanceBetweenTwo(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) async {
    _distanceInMeters = await new Geolocator().distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
    if (distanceInMeters <= 15.800000000000) {
      streamSubscription.pause();
      increaseTheDateTime();
      streamSubscription.resume();
    }
    notifyListeners();
  }

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=================-----------------===============---------------============--------------//




}
