import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfirabase/models/kullanici.dart';

class FireStoreServisi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateTime zaman = DateTime.now();

  Future<void> kullaniciOlustur(String id, Kullanici kullanici) async {
    await _firestore.collection("kullanicilar").doc(id).set(kullanici.toJson());
  }

  Future<Kullanici> kullaniciGetir(id) async {
    DocumentSnapshot doc =
        await _firestore.collection("kullanicilar").doc(id).get();
    if (doc.exists) {
      Kullanici kullanici = Kullanici.fromJson(doc.data());
      return kullanici;
    }
    return null;
  }

  void kullaniciGuncelle(Kullanici kullanici) {
    _firestore
        .collection("kullanicilar")
        .doc(kullanici.id)
        .update(kullanici.toJson());
  }

  void kullaniciSil(String kullaniciID) {
    _firestore.collection("kullanicilar").doc(kullaniciID).delete();
  }
}
