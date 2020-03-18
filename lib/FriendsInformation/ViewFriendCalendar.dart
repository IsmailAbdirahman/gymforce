import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:gymforce/DataModel/DateTimeMDModel.dart';
import 'package:gymforce/DataModel/EventCalnderModel.dart';
import 'package:gymforce/DataService/FireStoreService.dart';


class ViewFriendCalender extends StatefulWidget {
  String usersProfileModelUid;
  String userModelImage;
  String usersProfileModelName;


  ViewFriendCalender(
      {this.usersProfileModelUid,
        this.userModelImage,
        this.usersProfileModelName});

  @override
  _ViewFriendCalenderState createState() => _ViewFriendCalenderState();
}


class _ViewFriendCalenderState extends State<ViewFriendCalender> {
  CalendarCarousel _calendarCarousel;
  EventList<EventCalnderModel> _markedDateMap = EventList<EventCalnderModel>();
  static DateTime _now = new DateTime.now();
  DateTime currentDate = DateTime(_now.year, _now.month, _now.day);
  DateTime currentDate2 = DateTime(_now.year, _now.month, _now.day);
  FireStoreService fireStoreService = FireStoreService();

  static Widget _friendGymIcon = new Container(
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




  @override
  Widget build(BuildContext context) {
    _calendarCarousel = CalendarCarousel<EventCalnderModel>(
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 400.0,
      width: 500.0,
      selectedDateTime: currentDate2,
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
      minSelectedDate: currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: currentDate.add(Duration(days: 360)),
      markedDateMoreShowTotal: null,
    );

    return SafeArea(
        child: StreamBuilder<List<DateTimeMDModel>>(
            stream:
            FireStoreService(uid: widget.usersProfileModelUid).dateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<DateTimeMDModel> dateTimeMDModel = snapshot.data;
                for (int i = 0; i < dateTimeMDModel.length; i++) {
                  int y = dateTimeMDModel[i].year;
                  int m = dateTimeMDModel[i].month;
                  int d = dateTimeMDModel[i].day;
                  _markedDateMap.add(new DateTime(y, m, d),
                      new EventCalnderModel(icon: _friendGymIcon));
                }

                return new Scaffold(
                    backgroundColor: Color.fromARGB(255, 240, 240, 240),
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 50),
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
                                        color:
                                        Color.fromARGB(150, 255, 255, 255),
                                        blurRadius: 10)
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 32.0,
                                  backgroundImage:
                                  NetworkImage(widget.userModelImage),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 50),
                                  child: Text(
                                    widget.usersProfileModelName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 19),
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 50),
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
                                        color:
                                        Color.fromARGB(150, 255, 255, 255),
                                        blurRadius: 10)
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    fireStoreService.deleteFavPerson(
                                        widget.usersProfileModelUid,
                                        widget.userModelImage);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 376,
                            width: 386,
                            margin: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 30),
                            padding: EdgeInsets.all(20),
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
                            child: _calendarCarousel,
                          ),
                        ],
                      ),
                    ));
              } else {
                return Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }
            }));
  }
}
