import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'room.dart';

class FirestoreRooms {
  static const String path = 'rooms';

  final Firestore firestore;

  const FirestoreRooms(this.firestore);

  Future<void> createNewRoom(Room room) async {
    // ToDo: refactor to avoid double update
    final DocumentReference docRef = await firestore
        .collection(path)
        .add(<String, String>{'room': jsonEncode(room)});
    room.id = docRef.documentID;
    return await firestore
        .collection(path)
        .document(docRef.documentID)
        .setData(<String, dynamic>{'room': jsonEncode(room)}, merge: true);
  }

  Future<void> deleteRoom(String id) async {
    return firestore.collection(path).document(id).delete();
  }

  Stream<List<Room>> rooms() {
    return firestore.collection(path).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.documents.map<Room>((DocumentSnapshot json) {
        final dynamic roomMap = jsonDecode(json.data['room']);
        return Room.fromJson(roomMap);
      }).toList();
    });
  }

  Future<void> updateRoom(Room room) {
    return firestore
        .collection(path)
        .document(room.id)
        .updateData(<String, String>{'room': jsonEncode(room)});
  }
}
