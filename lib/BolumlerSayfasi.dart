import 'package:audioplayers/audioplayers.dart';
import 'package:dislexia_go/Ayarlar.dart';
import 'package:dislexia_go/OkumaMetniSayfasi.dart';
import 'package:dislexia_go/HarfTanimaSayfasi.dart';
import 'package:dislexia_go/HikayeTiyatroSayfasi.dart';
import 'package:dislexia_go/ResimEslestirme.dart';
import 'package:dislexia_go/OrtonHeceSayfasi.dart';
import 'package:dislexia_go/FernaldSayfasi.dart';
import 'package:dislexia_go/main.dart';
import 'package:dislexia_go/ritmik_yazi_ve_okuma_sayfasi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BolumlerSayfasi extends StatefulWidget {
  const BolumlerSayfasi({super.key});

  @override
  State<BolumlerSayfasi> createState() => _BolumlerSayfasiState();
}

class _BolumlerSayfasiState extends State<BolumlerSayfasi> {
  @override
  void initState() {
    super.initState();

    SesYonetici.baslat("anasayfavebolumler.mp3");

  }

  Future<void> cikisYap(BuildContext context) async {
    var sp = await SharedPreferences.getInstance();
    await sp.remove("ka");
    await sp.remove("s");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HarfliLoginEkrani()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bolumAdlari = [
      "Heceleme Oyunu",
      "Harf Tanıma",
      "Hikaye Tiyatrosu",
      "Okuma Metni Yardımcısı",
      "Kelimenin Doğrusunu bul",
      "Resim Eşleştir",
      "Ritmik Yaz ve Oku"
    ];
    final resimler = [
      "Arkaplan2.png",
      "arkaplan3.png",
      "Harfler.png",
      "Kitap.png",
      "sesilecalisalim.png",
      "resimeslestir.png",
      "frekansayir.png"
    ];

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurpleAccent),
              child: Text('Menü',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Hakkında'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>AyarlarSayfasi()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text(
          "Bölümler",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.deepPurpleAccent,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(bolumAdlari.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: 220,
                height: 220,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(8),
                    elevation: 7,
                  ),
                  onPressed: () {
                    switch (index) {
                      case 0:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => OrtonHeceSayfasi()));

                        break;
                      case 1:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => HarfTanimaSayfasi()));
                        break;
                      case 2:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => HikayeTiyatroSayfasi()));
                        break;
                      case 3:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => OkumaMetniSayfasi()));
                        break;
                      case 4:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => FernaldSayfasi()));

                        break;
                      case 5:
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => ResimEslestirme()));
                        break;
                      case 6:

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => RitmikYaziOkumaSayfasi()));
                        break;
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          "resimler/${resimler[index]}",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bolumAdlari[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}



