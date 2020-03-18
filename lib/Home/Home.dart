import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymforce/Calendar/MyCalendar.dart';
import 'package:gymforce/DataModel/UserInfoModel.dart';
import 'package:gymforce/DataService/FireStoreService.dart';
import 'package:gymforce/DataService/SharedPref.dart';
import 'package:gymforce/LocationTrackerState/LocationTrackerState.dart';
import 'package:provider/provider.dart';

import '../ConfigScreen.dart';


const String appId = 'ca-app-pub-5047013222439490~1644727075';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String bannerUnitId = 'ca-app-pub-5047013222439490/8018563730';

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['gym','fitness','healthy food'],
    nonPersonalizedAds: true,
  );

  BannerAd _bannerAd;
  int _coins = 0;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerUnitId,
      size: AdSize.largeBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  int _currentTab = 0;
  String gotLocAsAddress;

  SharedPref sharedPref = SharedPref();

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: appId);
    _bannerAd = createBannerAd()..load();
    _bannerAd ??= createBannerAd();
    _bannerAd
      ..load()
      ..show(
        anchorOffset: 60.0,
        horizontalCenterOffset: 0.0,
      );

    if (gotLocAsAddress == null) {
      sharedPref
          .getLocationAsAddress("address")
          .then((String s) => setState(() {
        gotLocAsAddress = s;
      }));
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final user = Provider.of<UserModel>(context);

    return StreamBuilder<UserInfoModel>(
        stream: FireStoreService(uid: user.uid).userInfo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserInfoModel userInfoModel = snapshot.data;
            return SafeArea(
              child: Scaffold(
                backgroundColor: Color.fromARGB(255, 240, 240, 240),
                body: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          margin:
                          EdgeInsets.only(left: 10, top: 30, right: 10),
                          padding: EdgeInsets.only(right: 10, top: 20),
                          alignment: Alignment.topRight,
                          height: 100.0,
                          width: 400.0,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 238, 238, 238),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(10, 10),
                                color: Color.fromARGB(80, 0, 0, 0),
                                blurRadius: 10,
                              ),
                              BoxShadow(
                                  offset: Offset(-10, -10),
                                  color: Color.fromARGB(150, 255, 255, 255),
                                  blurRadius: 10)
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 32.0,
                            backgroundImage:
                            NetworkImage(userInfoModel.imageUrl),
                          ),
                        ),
                        Positioned(
                            bottom: 43,
                            left: 50,
                            child: Text(
                              userInfoModel.name,
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w600),
                            )),
                        Positioned(
                            bottom: 12,
                            left: 65,
                            child: Container(
                              width: 140,
                              child: gotLocAsAddress != null
                                  ? Text(
                                gotLocAsAddress,
                                overflow: TextOverflow.ellipsis,
                              )
                                  : Text("Update Location"),
                            )),
                        Positioned(
                            bottom: 12,
                            left: 40,
                            child: Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    Container(
                        height: SizeConfig.blockSizeVertical * 50,
                        width: SizeConfig.blockSizeHorizontal * 90,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color.fromARGB(255, 238, 238, 238),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(10, 10),
                              color: Color.fromARGB(80, 0, 0, 0),
                              blurRadius: 10,
                            ),
                            BoxShadow(
                                offset: Offset(-10, -10),
                                color: Color.fromARGB(150, 255, 255, 255),
                                blurRadius: 10)
                          ],
                        ),
                        child: ChangeNotifierProvider<LocationTrackerState>(
                          create: (context) => LocationTrackerState(),
                          child: Container(
                              color: Color.fromARGB(150, 255, 255, 255),
                              margin: EdgeInsets.all(22.0),
                              child: MyCalander()),
                        )),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical *1,
                    ),

                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
