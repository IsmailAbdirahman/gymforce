import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymforce/DataModel/DateTimeMDModel.dart';
import 'package:gymforce/DataModel/UserInfoModel.dart';
import 'package:gymforce/DataModel/UsersProfile.dart';


class FireStoreService {
  final CollectionReference gymLocation =
  Firestore.instance.collection('gymLocation');
  final CollectionReference dateOfGymCollection =
  Firestore.instance.collection('dateOfGymCollection');
  final CollectionReference userData = Firestore.instance.collection('userData');
  static DateTime _now = new DateTime.now();
  static DateTime orderIdNowDateTime = DateTime(_now.year, _now.month, _now.day);
  String randomuniqueId = orderIdNowDateTime.toString();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String uid;

  //Constructor
  FireStoreService({this.uid});

  //Store User Information
  Future userInformation(String name, String email, String imageUrl,String useruid,String searchKey) async {
    final FirebaseUser user = await _auth.currentUser();
    return await userData.document(user.uid).setData({
      'name': name,
      'phone': email,
      'location': imageUrl,
      'useruid': useruid,
      'searchKey': searchKey

    });

  }

  //Retrieve User Information
  UserInfoModel _userInfoFromsnapshot(DocumentSnapshot snapshot) {
    return UserInfoModel(
      name: snapshot.data['name'] ?? '',
      gmail: snapshot.data['phone'],
      imageUrl: snapshot.data['location'],
    );
  }

  //get the user information as stream
  Stream<UserInfoModel> get userInfo {
    return userData.document(uid).snapshots().map(_userInfoFromsnapshot);
  }


  Future saveGymDate(int year, int month, int day) async {
    final FirebaseUser user = await _auth.currentUser();
    return await userData
        .document(user.uid)
        .collection('MyDays')
        .document(randomuniqueId)
        .setData({'year': year, 'month': month, 'day': day});
  }

//  // Retrieve the user year month and day
  List<DateTimeMDModel> dateListFromFireStore(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return DateTimeMDModel(
          year: doc.data['year'],
          month: doc.data['month'],
          day: doc.data['day']);
    }).toList();
  }


  Stream<List<DateTimeMDModel>> get dateStream {
    return userData
        .document(uid)
        .collection("MyDays")
        .snapshots()
        .map(dateListFromFireStore);
  }

  //Update User Information
  Future updateUserImage(String imageUrl) async {
    final FirebaseUser user = await _auth.currentUser();
    return await userData.document(user.uid).updateData({
      'location': imageUrl,
    });
  }

  //Update User Information
  Future updateUserName(String name, String searchKeyy) async {
    final FirebaseUser user = await _auth.currentUser();
    //convert first char to upper case and sav it
    String upName= name.substring(0,1).toUpperCase() + name.substring(1);
    return await userData.document(user.uid).updateData({
      'name': upName,
      'searchKey': searchKeyy
    });
  }

  // get list of users around the world as snapshot
  List<UsersProfileModel> usersProfilePicture(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UsersProfileModel(
          image: doc.data['location'],
          userUid: doc.data['useruid']
      );
    }).toList();
  }

//  // Retrieve each users data like year month and day
  List<DateTimeMDModel> fetchSpecificDateListFromFireStore(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return DateTimeMDModel(
          year: doc.data['year'],
          month: doc.data['month'],
          day: doc.data['day']);
    }).toList();
  }

//Retrieve each users data like year month and day as Stream
  Stream<List<DateTimeMDModel>> get fetchSpecificDateStream {
    return userData
        .document(uid)
        .collection("MyDays")
        .snapshots()
        .map(fetchSpecificDateListFromFireStore);
  }





// follow fav person
  Future favPeople(String favUid,String favImage,String favName) async {
    final FirebaseUser user = await _auth.currentUser();
    return await userData
        .document(user.uid)
        .collection('FavPeople')
        .document(favUid)
        .setData({
      'favPerson': favUid,
      'favImage':favImage,
      'favName':favName

    });
  }
// get list of FavPeople you followed as snapshot
  List<UsersProfileModel> favPeopleProfileList(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UsersProfileModel(
          userUid: doc.data['favPerson'],
          image:  doc.data['favImage'],
          name: doc.data['favName']
      );
    }).toList();
  }

//Retrieve each FavPeople UID as Stream
  Stream<List<UsersProfileModel>> get favPeopleProfileStream {
    return userData
        .document(uid)
        .collection("FavPeople")
        .snapshots()
        .map(favPeopleProfileList);
  }



  // delete fav person
  Future deleteFavPerson(String favUid,String favImage) async {
    final FirebaseUser user = await _auth.currentUser();
    return await userData
        .document(user.uid)
        .collection('FavPeople')
        .document(favUid).delete();

  }

}
