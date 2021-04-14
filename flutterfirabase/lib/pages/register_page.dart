import 'package:flutter/material.dart';
import 'package:flutterfirabase/models/kullanici.dart';
import 'package:flutterfirabase/pages/login_page.dart';
import 'package:flutterfirabase/servicies/authorization_service.dart';
import 'package:flutterfirabase/servicies/firestore_sevice.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _ad, _soyad, _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Register Page"),
      ),
      body: _buildBody,
    );
  }

  get _buildBody {
    return Form(
      key: _formkey,
      child: ListView(
        padding: EdgeInsets.only(left: 25, right: 25),
        children: [
          SizedBox(
            height: 30,
          ),
          Center(
              child: Text(
            "Welcome To Register Page",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          )),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return "Boş birakılamaz";
              }
              _ad = value;
              return null;
            },
            style: TextStyle(
                color: (Color((0xff2196F3))), fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                hintText: "Ad",
                icon: Icon(
                  Icons.person,
                  color: Color(0xff2196F3),
                )),
          ),
          SizedBox(height: 25),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return "Boş birakılamaz";
              }
              _soyad = value;
              return null;
            },
            style: TextStyle(
                color: (Color((0xff2196F3))), fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                hintText: "Soyad",
                icon: Icon(
                  Icons.person_add_alt_1_sharp,
                  color: Color(0xff2196F3),
                )),
          ),
          SizedBox(height: 25),
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return "Boş birakılamaz";
              }
              _email = value;
              return null;
            },
            style: TextStyle(
                color: (Color((0xff2196F3))), fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                hintText: "e mail",
                icon: Icon(
                  Icons.contact_mail_outlined,
                  color: Color(0xff2196F3),
                )),
          ),
          SizedBox(height: 25),
          TextFormField(
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) {
                return "Boş birakılamaz";
              }
              _password = value;
              return null;
            },
            style: TextStyle(
                color: ((Color(0xff2196F3))), fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                hintText: "password",
                icon: Icon(
                  Icons.remove_red_eye_outlined,
                  color: Color(0xff2196F3),
                )),
          ),
          SizedBox(height: 25),
          ElevatedButton(
            child: Text("Register"),
            onPressed: _registerMetod,
          ),
          ElevatedButton(
            child: Text("Zaten hesabim var"),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => LoginPage())),
          )
        ],
      ),
    );
  }

  void _registerMetod() {
    if (_formkey.currentState.validate()) {
      print("başarili");
      print(_ad + " ::: " + _soyad + " ::: " + _email + " ::: " + _password);
      _kullaniciOlustur();
      //? giriş işlemlerini başlat
    }
  }

  void _kullaniciOlustur() async {
    final _yetkilendirmeServisi =
        Provider.of<AuthorizationService>(context, listen: false);

    try {
      Kullanici kullanici =
          await _yetkilendirmeServisi.mailIleKayit(_email, _password);

      if (kullanici != null) {
        Kullanici kl = Kullanici(
            id: kullanici.id,
            ad: _ad,
            soyad: _soyad,
            email: _email,
            fotoUrl: "");
        FireStoreServisi().kullaniciOlustur(kullanici.id, kl);
        print("kullanici oluşturuld");
        Navigator.of(context).pop();
      }
    } catch (hata) {
      uyariGoster(hataKodu: hata.code);
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;

    if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "email-already-in-use") {
      hataMesaji = "Girdiğiniz mail kayıtlıdır";
    } else if (hataKodu == "weak-password") {
      hataMesaji = "Daha zor bir şifre tercih edin";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
