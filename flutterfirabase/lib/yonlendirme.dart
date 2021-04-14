import 'package:flutter/material.dart';
import 'package:flutterfirabase/pages/login_page.dart';
import 'package:flutterfirabase/pages/user_profil_page.dart';
import 'package:flutterfirabase/servicies/authorization_service.dart';
import 'package:provider/provider.dart';

import 'models/kullanici.dart';

class Yonlendirme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _yetkilendirmeServisi =Provider.of<AuthorizationService>(context, listen: false);

    return StreamBuilder(
        stream: _yetkilendirmeServisi.durumTakipcisi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (snapshot.hasData) {
            Kullanici aktifKullanici = snapshot.data;
            _yetkilendirmeServisi.aktifKullaniciId = aktifKullanici.id;
            return UserProfilePage();
          } else {
            return LoginPage();
          }
        });
  }
}
