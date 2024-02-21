import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethos_app/DataTypes/RegistroControllo.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../DataTypes/Controllo.dart';

CollectionReference<Controllo> collectionControlli({String hour = "00:00:00"}) {
  return FirebaseFirestore.instance
      .collection('controlli')
      .withConverter<Controllo>(
        fromFirestore: (snapshot, _) =>
            Controllo.fromSnapshot(data: snapshot.data()!, hour: hour),
        toFirestore: (controllo, _) => controllo.toJson(),
      );
}

CollectionReference<RegistroControllo> collectionRegistri(
    {String hour = "00:00:00"}) {
  return FirebaseFirestore.instance
      .collection('registro_controlli')
      .withConverter<RegistroControllo>(
        fromFirestore: (snapshot, _) =>
            RegistroControllo.fromSnapshot(data: snapshot.data()!, hour: hour),
        toFirestore: (controllo, _) => controllo.toJson(),
      );
}

Future<void> addControlloDB(Controllo controllo) async {
  return await collectionControlli()
      .doc(controllo.cod)
      .set(controllo)
      .then((value) => print("### Added"))
      .catchError((error) => print("### Failed to add: $error"));
}

Future<List<Controllo>> getControlliPerData(
  DateTime data, {
  String hour = "00:00:00",
}) async {
  List<QueryDocumentSnapshot<Controllo>> values = await collectionControlli(
          hour: hour)
      .where('dataProssimo', isEqualTo: data.toIso8601String().substring(0, 10))
      .get()
      .then((value) => value.docs);
  return values.map((e) => e.data()).toList();
}

Future<void> editControlDB(Controllo controllo) async {
  return await collectionControlli()
      .doc(controllo.cod)
      .update(controllo.toJson())
      .then((value) => print("### Added"))
      .catchError((error) => print("### Failed to add: $error"));
}

Future<void> registroControllo(RegistroControllo controllo) async {
  return await collectionRegistri()
      .doc(controllo.codice + controllo.dataControllo.toUtc().toIso8601String())
      .set(controllo)
      .then((value) => print("### Added"))
      .catchError((error) => print("### Failed to add: $error"));
}

Future<bool> isControlloPresente(String codice) async {
  try {
    DocumentSnapshot<Controllo> snapshot =
        await collectionControlli().doc(codice).get();
    return snapshot.exists;
  } catch (e) {
    return false;
  }
}

Future<Controllo> getControllo(String codice) async {
  return await collectionControlli().doc(codice).get().then((e) => e.data()!);
}

Future<void> deleteControllo(String c) async {
  //TODO: unused
  return await collectionControlli().doc(c).delete().then((_) async {
    await FirebaseStorage.instance.ref().child('schede/$c').delete();
  });
}

Future<List<RegistroControllo>> getRevisioniPerData(
  DateTime start,
  DateTime end,
) async {
  List<QueryDocumentSnapshot<RegistroControllo>> values =
      await collectionRegistri().get().then((value) => value.docs);

  return values
      .map((e) => e.data())
      .where((e) =>
          (e.dataControllo.isBefore(end) && e.dataControllo.isAfter(start)) ||
          e.dataControllo == end ||
          e.dataControllo == start)
      .toList();
}

Future<List<Controllo>> getAllControls() async {
  List<QueryDocumentSnapshot<Controllo>> values =
      await collectionControlli().get().then((value) => value.docs);
  return values.map((e) => e.data()).toList();
}
