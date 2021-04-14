import 'package:flutter/material.dart';
import 'package:flutterfirabase/pages/register_page.dart';
import 'package:flutterfirabase/pages/reset_password_page.dart';
import 'package:flutterfirabase/servicies/authorization_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email;
  String _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Login Page"),
        centerTitle: true,
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
            "Welcome To Login Page",
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
          SizedBox(
            height: 30,
          ),
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
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
            child: Text("Login"),
            onPressed: _loginMetod,
          ),
          ElevatedButton(
            child: Text("Hesabim Yok"),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => RegisterPage())),
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
              child: Text("Şifremi Unuttum"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ResetPasswordPage()));
              }),
        ],
      ),
    );
  }

  void _loginMetod() {
    if (_formkey.currentState.validate()) {
      print("başarili");
      print(_email + _password);

      _giris();
    }
  }

  void _giris() async {
    final _yetkilendirmeServisi =
        Provider.of<AuthorizationService>(context, listen: false);

    try {
      await _yetkilendirmeServisi.mailIleGiris(_email, _password);
    } catch (hata) {
      print("ERROR");

      uyariGoster(hataKodu: hata.code);
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;

    if (hataKodu == "user-not-found") {
      hataMesaji = "Böyle bir kullanıcı bulunmuyor";
    } else if (hataKodu == "invalid-email") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "wrong-password") {
      hataMesaji = "Girilen şifre hatalı";
    } else if (hataKodu == "user-disabled") {
      hataMesaji = "Kullanıcı engellenmiş";
    } else {
      hataMesaji = "Tanımlanamayan bir hata oluştu $hataKodu";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
