import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:gymforce/DataModel/DateTimeMDModel.dart';
import 'package:gymforce/DataModel/EventCalnderModel.dart';
import 'package:gymforce/DataModel/UserInfoModel.dart';
import 'package:gymforce/DataService/FireStoreService.dart';
import 'package:gymforce/LocationTrackerState/LocationTrackerState.dart';
import 'package:provider/provider.dart';

import '../ConfigScreen.dart';


class MyCalander extends StatefulWidget {
  @override
  _MyCalanderState createState() => _MyCalanderState();
}

class _MyCalanderState extends State<MyCalander> {
  CalendarCarousel _calendarCarousel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final appState = Provider.of<LocationTrackerState>(context);
    final user = Provider.of<UserModel>(context);
    int countsDays = 0;

    /// Example with custom icon
    _calendarCarousel = CalendarCarousel<EventCalnderModel>(
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: appState.markedDateMappp,
      height: 400.0,
      width: 500.0,
      selectedDateTime: appState.currentDate2,
      showHeader: true,
      headerTextStyle: TextStyle(
          color: Color(0xff476cfb), fontSize: 19, fontWeight: FontWeight.w600),
      daysHaveCircularBorder: null,
      showIconBehindDayText: false,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      todayButtonColor: Colors.yellow,
      markedDateIconMaxShown: 1,
      selectedDayTextStyle: TextStyle(
        color: Colors.black87,
      ),
      todayTextStyle: TextStyle(
        color: Colors.black87,
      ),
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      minSelectedDate: appState.currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: appState.currentDate.add(Duration(days: 360)),
      markedDateMoreShowTotal: null,
    );
    return StreamBuilder<List<DateTimeMDModel>>(
        stream: FireStoreService(uid: user.uid).dateStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DateTimeMDModel> dateTimeMDModel = snapshot.data;
            countsDays = dateTimeMDModel.length;

            for (int i = 0; i < dateTimeMDModel.length; i++) {
              int y = dateTimeMDModel[i].year;
              int m = dateTimeMDModel[i].month;
              int d = dateTimeMDModel[i].day;
              appState.markedDateMappp.add(new DateTime(y, m, d),
                  new EventCalnderModel(icon: appState.gymIconnn));
            }

            return new Scaffold(
                backgroundColor: Color.fromARGB(255, 240, 240, 240),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //custom icon

                      Container(
                        height: SizeConfig.blockSizeVertical * 45,
                        width: SizeConfig.blockSizeHorizontal * 80,
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 30),
                        color: Color.fromARGB(255, 240, 240, 240),
                        child: _calendarCarousel,
                      ),
                    ],
                  ),
                ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
