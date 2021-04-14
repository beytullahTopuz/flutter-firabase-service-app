import 'package:firebase_auth/firebase_auth.dart';

class Kullanici {
  String id;
  String ad;
  String soyad;
  String email;
  String fotoUrl;

  Kullanici({this.id, this.ad, this.soyad, this.email, this.fotoUrl});

  factory Kullanici.firebasedenUret(User kullanici) {
    return Kullanici(
      id: kullanici.uid,
      ad: kullanici.displayName,
      email: kullanici.email,
    );
  }

  Kullanici.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ad = json['ad'];
    soyad = json['soyad'];
    email = json['email'];
    fotoUrl = json['fotoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ad'] = this.ad;
    data['soyad'] = this.soyad;
    data['email'] = this.email;
    data['fotoUrl'] = this.fotoUrl;
    return data;
  }
}
