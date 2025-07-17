import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dislexia_go/main.dart';


class AyarlarSayfasi extends StatefulWidget {
  const AyarlarSayfasi({super.key});

  @override
  State<AyarlarSayfasi> createState() => _AyarlarSayfasiState();
}

class _AyarlarSayfasiState extends State<AyarlarSayfasi> {
  bool muzikAcik = true;

  @override
  void initState() {
    super.initState();
    _ayarYukle();
  }

  Future<void> _ayarYukle() async {
    final sp = await SharedPreferences.getInstance();
    final durum = sp.getBool("muzik") ?? true;
    setState(() {
      muzikAcik = durum;
    });
    await SesYonetici.sesAyarla(durum ? 1.0 : 0.0);
  }


  Future<void> _muzikDegistir(bool deger) async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      muzikAcik = deger;
    });
    await sp.setBool("muzik", deger);

    if (deger) {
      // Ses tamamen açık
      await SesYonetici.sesAyarla(1.0);
    } else {
      // Ses kısık (mute)
      await SesYonetici.sesAyarla(0.0);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: const Text("Ayarlar"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text("Arkaplan Müziği"),
            trailing: Switch(
              value: muzikAcik,
              onChanged: _muzikDegistir,
              activeColor: Colors.deepPurpleAccent,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Tema (Yapılacak)"),
            subtitle: const Text("Şu anda sadece koyu tema kullanılmakta."),
          ),
        ],
      ),
    );
  }
}
