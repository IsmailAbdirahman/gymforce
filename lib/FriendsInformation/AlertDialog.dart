import 'package:flutter/material.dart';
import 'package:gymforce/DataService/FireStoreService.dart';


class AlertDailogCom extends StatefulWidget {
  String id;
  String image;
  String name;
  AlertDailogCom({this.id,this.image,this.name});



  @override
  _AlertDailogComState createState() => _AlertDailogComState();
}

class _AlertDailogComState extends State<AlertDailogCom> {
  FireStoreService fireStoreService = FireStoreService();

  @override
  Widget build(BuildContext context) {
    print("The name you selected is ${widget.name}");
    return Scaffold(
      body: Container(
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
        child: AlertDialog(
          title: Text(''),
          content:CircleAvatar(
            radius: 100.0,
            backgroundImage: NetworkImage(
                widget.image),
          ),
          actions: <Widget>[
            FlatButton(
              child: Icon(Icons.cancel,color: Colors.redAccent[100]),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Icon(Icons.favorite,color: Colors.redAccent[400]),
              onPressed: () {
                fireStoreService.favPeople(widget.id,widget.image,widget.name);
                Navigator.of(context).pop();

              },
            ),
          ],
        ),


      ),
    );
  }
}
