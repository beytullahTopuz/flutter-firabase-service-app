import 'package:flutter/material.dart';
import 'package:flutterfirabase/servicies/authorization_service.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String email;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Reset Password Page"),
      ),
      body: _buildBody,
    );
  }

  get _buildBody {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 35,
              ),
              Center(
                  child: Text(
                "Welcome Reset Password",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              )),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return "Boş birakılamaz";
                  }
                  email = value;
                  return null;
                },
                style: TextStyle(
                    color: (Color((0xff2196F3))), fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    hintText: "e mail adresini giriniz",
                    icon: Icon(
                      Icons.contact_mail_outlined,
                      color: Color(0xff2196F3),
                    )),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  child: Text("Şifremi Yenile"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _resetPAssword();
                    }
                  }),
            ],
          )),
    );
  }

  void _resetPAssword() async {
    final _yetkilendirmeServisi =
        Provider.of<AuthorizationService>(context, listen: false);
    try {
      await _yetkilendirmeServisi.sifremiSifirla(email);

      Navigator.of(context).pop();
    } catch (hata) {
      uyariGoster(hataKodu: hata.code);
    }
  }

  uyariGoster({hataKodu}) {
    String hataMesaji;

    if (hataKodu == "ERROR_INVALID_EMAIL") {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir";
    } else if (hataKodu == "ERROR_USER_NOT_FOUND") {
      hataMesaji = "Bu mailde bir kullanıcı bulunmuyor";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
