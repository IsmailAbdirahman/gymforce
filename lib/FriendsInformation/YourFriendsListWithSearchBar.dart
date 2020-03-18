
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gymforce/DataModel/UserInfoModel.dart';
import 'package:gymforce/DataModel/UsersProfile.dart';
import 'package:gymforce/DataService/FireStoreService.dart';
import 'package:provider/provider.dart';
import 'AlertDialog.dart';
import 'SearchService.dart';
import 'ViewFriendCalendar.dart';

class YourFriendsListWithSearchBar extends StatefulWidget {
  @override
  _YourFriendsListWithSearchBarState createState() => new _YourFriendsListWithSearchBarState();
}

class _YourFriendsListWithSearchBarState extends State<YourFriendsListWithSearchBar> {
  var queryResultSet = [];
  var tempSearchStore = [];
  var userss = [];
  FireStoreService fireStoreService = FireStoreService();
  //Input the search name
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    var capitalizedValue =
    // first char must be upper case
    value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.length == 0 && value.length == 1) {
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        fetchUserSearch(docs);
        for (int i = 0; i < docs.documents.length; ++i) {
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
            userss.add(tempSearchStore);
          });
        }
      });
    }
  }

  List<UsersProfileModel> fetchUserSearch(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      print("snananana${doc.data['useruid']}");
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

// get the searched names as a ListView
    Widget searchResultMethod(data) {
      return ListTile(
        title: Text(data['name']),
        trailing: Icon(Icons.arrow_forward_ios),
        leading: CircleAvatar(
          radius: 32.0,
          backgroundImage: NetworkImage(data['location']),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlertDailogCom(
                id: data['useruid'],
                image: data['location'],name: data['name'],
              ),
            ),
          );
        },
      );
    }

    // Function to be called to View Friends Calender
    void _onTileClicked(
        String usersProfileModelUid, String usersProfileModelImage,String usersProfileModelName) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewFriendCalender(
              usersProfileModelUid: usersProfileModelUid,
              userModelImage: usersProfileModelImage,usersProfileModelName: usersProfileModelName),
        ),
      );
    }




    return StreamBuilder<List<UsersProfileModel>>(
        stream: FireStoreService(uid: user.uid).favPeopleProfileStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UsersProfileModel> usersProfileModel = snapshot.data;
            print("Length of snapshot is ${usersProfileModel.length}");
            return SafeArea(
              child: new Scaffold(
                  backgroundColor: Color.fromARGB(255, 240, 240, 240),
                  body: ListView(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Container(
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
                        child: TextField(
                          onChanged: (val) {
                            initiateSearch(val);
                          },
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              color: Color(0xff476cfb),
                              icon: Icon(Icons.arrow_back),
                              iconSize: 20.0,
                              onPressed: () {
                                FocusScope.of(context).requestFocus(new FocusNode());
                              },
                            ),
                            contentPadding: EdgeInsets.only(
                                left: 17.0, top: 17, bottom: 17),
                            hintText: 'Search',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(color: Color(0xff476cfb)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.all(10),
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
                      child: ListView.builder(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: tempSearchStore.length,
                        itemBuilder: (context, index) {
                          return searchResultMethod(tempSearchStore[index]);
                        },
                      ),
                    ),

                    Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('favourite friends ',style: TextStyle(fontWeight: FontWeight.w800),)),
                    SizedBox(height: 10.0),




                    // get the list of added friends  as a GridView
                    GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 35.0,
                      mainAxisSpacing: 1.0,
                      primary: false,
                      shrinkWrap: true,
                      children: new List<Widget>.generate(
                          usersProfileModel.length, (index) {
                        return new GridTile(
                          child: InkResponse(
                            onTap: () => _onTileClicked(
                                usersProfileModel[index].userUid,
                                usersProfileModel[index].image,usersProfileModel[index].name),
                            child: Container(
                              margin: EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
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
                              child: CircleAvatar(
                                radius: 10.0,
                                backgroundImage:
                                NetworkImage(usersProfileModel[index].image),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),


                  ])),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }


}
