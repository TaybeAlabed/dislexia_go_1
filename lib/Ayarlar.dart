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
    setState(() {
      muzikAcik = sp.getBool("muzik") ?? true;
    });
  }

  Future<void> _muzikDegistir(bool deger) async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      muzikAcik = deger;
    });
    sp.setBool("muzik", deger);

    
    if (deger) {
      await SesYonetici.baslat();
    } else {
      await SesYonetici.durdur();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text("Arkaplan Müziği"),
            trailing: Switch(
              value: muzikAcik,
              onChanged: _muzikDegistir,
              activeColor: Colors.green,
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
