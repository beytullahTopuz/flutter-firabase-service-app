import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirabase/models/kullanici.dart';
import 'package:flutterfirabase/servicies/authorization_service.dart';
import 'package:flutterfirabase/servicies/firestore_sevice.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UserProfilePage extends StatefulWidget {
  String userProfilID;

  UserProfilePage({Key key, this.userProfilID}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    widget.userProfilID =
        Provider.of<AuthorizationService>(context, listen: false)
            .aktifKullaniciId;

    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _textEditingControllerAd = TextEditingController();
  final _textEditingControllerSoyad = TextEditingController();
  final _textEditingControllerMail = TextEditingController();
  final _textEditingControllerSifre = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  String _ad;
  String _soyad;

  String _tempUserProfileImgUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: _buildBody,
    );
  }

  get _buildBody {
    return FutureBuilder(
      future: FireStoreServisi().kullaniciGetir(widget.userProfilID),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          Kullanici kl = snap.data;
          return _buildProfile(kl);
        } else if (snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: Text("ERROR"),
          );
        }
      },
    );
  }

  Widget _buildProfile(Kullanici kl) {
    var defaultImgUrl =
        "https://www.1seouzmani.com/wp-content/uploads/2017/11/avatar_user_7_1511729320.png";

    if (kl.fotoUrl == "") {
      _tempUserProfileImgUrl = defaultImgUrl;
    } else {
      _tempUserProfileImgUrl = kl.fotoUrl;
    }
    return Column(
      children: [
        Expanded(
          flex: 50,
          child: Center(
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(defaultImgUrl),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: ElevatedButton(
            child: Text("Profil Resmi Yukle"),
            onPressed: _fotoYukle,
          ),
        ),
        Spacer(
          flex: 2,
        ),
        Expanded(
          flex: 7,
          child: ElevatedButton(
            child: Text("E mail doğrula"),
            onPressed: _emailDogrula,
          ),
        ),
        Spacer(
          flex: 2,
        ),
        Expanded(
          flex: 7,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.grey)),
              child: Row(
                children: [
                  Expanded(child: Icon(Icons.logout)),
                  Expanded(child: Text("Çıkış Yap")),
                ],
              ),
              onPressed: () {
                _cikisYap();
              },
            ),
          ),
        ),
        Spacer(
          flex: 10,
        ),
        Expanded(
            flex: 70,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: _buildForm(kl),
            )),
      ],
    );
  }

  void _emailDogrula() async {
    var user = FirebaseAuth.instance.currentUser;
    if (!(await AuthorizationService().emailDogrulandimi(user))) {
      AuthorizationService().emailDogrula(user);

      _epostaDogrulamaMesaji("mail adresine doğrulama mesajı gönderildi");
      setState(() {});
    } else {
      _epostaDogrulamaMesaji("email zaten doğrulanmış");
    }
  }

  void _epostaDogrulamaMesaji(String msg) {
    var snackBar = SnackBar(content: Text(msg));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _fotoYukle() {
    var snackBar = SnackBar(content: Text("Bu özellik henüz aktif değil"));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget _buildForm(Kullanici k) {
    _textEditingControllerAd.text = k.ad;
    _textEditingControllerSoyad.text = k.soyad;
    _textEditingControllerMail.text = k.email;
    _textEditingControllerSifre.text = "******";
    return Form(
        key: _formkey,
        child: ListView(
          children: [
            Center(
                child: Text(
              "Hoşgeldin ${k.ad}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            )),
            TextFormField(
              // enabled: false,
              controller: _textEditingControllerAd,
              validator: (value) {
                if (value.isEmpty) {
                  return "Boş birakılamaz";
                }
                _ad = value;
                return null;
              },
              style: TextStyle(
                  color: ((Colors.grey)), fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  hintText: "Ad",
                  icon: Icon(
                    Icons.person,
                    color: Color(0xff2196F3),
                  )),
            ),
            TextFormField(
              // enabled: false,
              controller: _textEditingControllerSoyad,
              validator: (value) {
                if (value.isEmpty) {
                  return "Boş birakılamaz";
                }
                _soyad = value;
                return null;
              },
              style: TextStyle(
                  color: ((Colors.grey)), fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  hintText: "Soyad",
                  icon: Icon(
                    Icons.person_add_alt_1_sharp,
                    color: Color(0xff2196F3),
                  )),
            ),
            TextFormField(
              enabled: false,
              controller: _textEditingControllerMail,
              validator: (value) {
                if (value.isEmpty) {
                  return "Boş birakılamaz";
                }

                return null;
              },
              style: TextStyle(
                  color: ((Colors.grey)), fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  hintText: "E Mail",
                  icon: Icon(
                    Icons.mail,
                    color: Color(0xff2196F3),
                  )),
            ),
            TextFormField(
              enabled: false,
              controller: _textEditingControllerSifre,
              validator: (value) {
                if (value.isEmpty) {
                  return "Boş birakılamaz";
                }

                return null;
              },
              style: TextStyle(
                  color: ((Colors.grey)), fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  hintText: "Password",
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: Color(0xff2196F3),
                  )),
            ),
            ElevatedButton(
              child: Text("Güncelle"),
              onPressed: () {
                if (_formkey.currentState.validate()) {
                  _guncelle(k);
                }
              },
            ),
            ElevatedButton(
              child: Text("Üyeliğimi Sil"),
              onPressed: _deleteUser,
            ),
          ],
        ));
  }

  void _deleteUser() {
    final _yetkilendirmeServisi =
        Provider.of<AuthorizationService>(context, listen: false);

    try {
      // kullanici bilgileri silme işlemi
      FireStoreServisi().kullaniciSil(widget.userProfilID);

      //kullanici mail silme işlemi
      AuthorizationService().kullaniciSil(FirebaseAuth.instance.currentUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    } catch (error) {
      print("hata");
    }
  }

  void _guncelle(Kullanici oldKullanici) async {
    String aktifKullaniciId =
        Provider.of<AuthorizationService>(context, listen: false)
            .aktifKullaniciId;

    Kullanici newKullanici = Kullanici(
        id: aktifKullaniciId,
        ad: _ad,
        soyad: _soyad,
        email: oldKullanici.email,
        fotoUrl: "");

    FireStoreServisi().kullaniciGuncelle(newKullanici);

    setState(() {});
  }

  void _cikisYap() {
    Provider.of<AuthorizationService>(context, listen: false).cikisYap();
  }
}
