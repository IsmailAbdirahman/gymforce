import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'DataModel/UserInfoModel.dart';
import 'FriendsInformation/YourFriendsListWithSearchBar.dart';
import 'Home/Home.dart';
import 'LocationTrackerState/LocationTrackerState.dart';
import 'Profile/ProfileInfo.dart';

class DisplayData extends StatefulWidget {
  DisplayData({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return homeState();
  }
}

class homeState extends State<DisplayData> {
  UserInfoModel userInfoModel = UserInfoModel();
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    Home(),
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationTrackerState>(create: (_) => LocationTrackerState()),
      ],
      child: YourFriendsListWithSearchBar(),
    ),
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationTrackerState>(create: (_) => LocationTrackerState()),
      ],
      child: ProfilePage(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        elevation: 0,
        unselectedItemColor: Colors.black54,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: SizedBox.shrink(),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: SizedBox.shrink(),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
