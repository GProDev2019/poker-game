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
    final DocumentReference docRef =
        await firestore.collection(path).add(jsonDecode(jsonEncode(room)));
    room.id = docRef.documentID;
    return await firestore
        .collection(path)
        .document(docRef.documentID)
        .setData(jsonDecode(jsonEncode(room)), merge: true);
  }

  Future<void> deleteRoom(String roomId) async {
    return firestore.collection(path).document(roomId).delete();
  }

  Stream<List<Room>> rooms() {
    return firestore.collection(path).snapshots().map((QuerySnapshot snapshot) {
      return snapshot.documents.map<Room>((DocumentSnapshot json) {
        return Room.fromJson(jsonDecode(jsonEncode(json.data)));
      }).toList();
    });
  }

  Future<void> updateRoom(Room room) {
    return firestore
        .collection(path)
        .document(room.id)
        .updateData(jsonDecode(jsonEncode(room)));
  }
}
