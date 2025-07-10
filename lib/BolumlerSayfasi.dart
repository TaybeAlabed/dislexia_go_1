import 'package:dislexia_go/OkumaMetniSayfasi.dart';
import 'package:dislexia_go/HarfTanimaSayfasi.dart';
import 'package:dislexia_go/HikayeTiyatroSayfasi.dart';
import 'package:dislexia_go/ResimEslestirme.dart';
import 'package:dislexia_go/OrtonHeceSayfasi.dart';
import 'package:dislexia_go/FernaldSayfasi.dart';
import 'package:dislexia_go/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BolumlerSayfasi extends StatelessWidget {
  const BolumlerSayfasi({super.key});

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
      "Kelime Eşleştir"
    ];
    final resimler = [
      "Arkaplan2.png",
      "arkaplan3.png",
      "Harfler.png",
      "Kitap.png",
      "5.png",
      "resimeslestir.png"
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
              onTap: () {
                // TODO: Hakkında sayfasına yönlendirme
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                Navigator.pushNamed(context, "/ayarlar");
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
                width: 220, // Yarı boyut
                height: 220,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(8),
                    elevation: 6,
                  ),
                  onPressed: () {
                    switch (index) {
                      case 0:
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OrtonHeceSayfasi()));
                        break;
                      case 1:
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  HarfTanimaSayfasi()));
                        break;
                      case 2:
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  HikayeTiyatroSayfasi()));
                        break;
                      case 3:
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  OkumaMetniSayfasi()));
                        break;
                      case 4:
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  FernaldSayfasi()));
                        break;
                      case 5:
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  ResimEslestirme()));
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


