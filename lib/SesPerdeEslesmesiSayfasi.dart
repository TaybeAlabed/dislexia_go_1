import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';

class SesPerdeGelistirilmisSayfa extends StatefulWidget {
  const SesPerdeGelistirilmisSayfa({super.key});

  @override
  State<SesPerdeGelistirilmisSayfa> createState() => _SesPerdeGelistirilmisSayfaState();
}

class _SesPerdeGelistirilmisSayfaState extends State<SesPerdeGelistirilmisSayfa> {
  final player = AudioPlayer();
  final List<String> sesDosyalari = [
    "frekans/tiz.mp3",
    "frekans/orta.mp3",
    "frekans/pes.mp3",
  ];

  final List<String> secenekEtiketleri = ["Yüksek", "Orta", "Alçak"];
  final List<String> tanitimMesajlari = ["🔊 Bu ses: Yüksek (Tiz)", "🔊 Bu ses: Orta", "🔊 Bu ses: Alçak (Pes)"];

  int seviye = 1;
  int? aktifSesIndex;
  bool cevaplandi = false;
  bool dogruMu = false;
  int dogruSayac = 0;
  int yanlisSayac = 0;
  bool tanitimModu = true;
  String? tanitimMesaji;
  int? kullaniciSecimi;
  List<int> dogruCokluSecim = [];
  List<int>? kullaniciCokluSecim;
  List<int> karisikSesSirasi = [];
  List<List<int>> seceneklerSirali = [];

  Future<void> sesTanitimOynat() async {
    setState(() {
      tanitimMesaji = null;
    });
    for (int i = 0; i < sesDosyalari.length; i++) {
      setState(() {
        tanitimMesaji = tanitimMesajlari[i];
      });
      await player.play(AssetSource(sesDosyalari[i]));
      await Future.delayed(Duration(seconds: 2));
    }
    setState(() {
      tanitimModu = false;
      tanitimMesaji = null;
    });
  }

  Future<void> tekliSesCal() async {
    final random = Random();
    int index = random.nextInt(3);
    aktifSesIndex = index;
    await player.play(AssetSource(sesDosyalari[index]));
    setState(() {
      cevaplandi = false;
      kullaniciSecimi = null;
    });
  }

  void kontrolEtTekli(int secim) {
    if (aktifSesIndex == null) return;
    setState(() {
      cevaplandi = true;
      dogruMu = (secim == aktifSesIndex);
      kullaniciSecimi = secim;
      if (dogruMu) {
        dogruSayac++;
      } else {
        yanlisSayac++;
      }
      if (dogruSayac >= 4 && seviye == 1) {
        seviye = 2;
        dogruSayac = 0;
        yanlisSayac = 0;
        tanitimModu = false;
      } else if (dogruSayac >= 4 && seviye == 2) {
        seviye = 3;
        dogruSayac = 0;
        yanlisSayac = 0;
      } else if (dogruSayac >= 4 && seviye == 3) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.blue,
              title: Text("🎉 Mükemmel iş çıkardın!", style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      seviye = 1;
                      dogruSayac = 0;
                      yanlisSayac = 0;
                      tanitimModu = true;
                    });
                  },
                  child: Text("Baştan Başla", style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/ritimSayfasi');
                  },
                  child: Text("Bitir", style: TextStyle(color: Colors.white)),
                )
              ],
            );
          },
        );
      }
    });
  }

  Future<void> cokluSesCal() async {
    final random = Random();
    karisikSesSirasi = List.generate(3, (i) => i)..shuffle(random);
    for (int i = 0; i < 3; i++) {
      await player.play(AssetSource(sesDosyalari[karisikSesSirasi[i]]));
      await Future.delayed(Duration(milliseconds: 1000));
    }

    dogruCokluSecim = List.from(karisikSesSirasi);

    List<List<int>> alternatifler = [];
    while (alternatifler.length < 2) {
      List<int> aday = List.generate(3, (i) => i)..shuffle();
      if (!listEquals(aday, dogruCokluSecim) && !alternatifler.any((e) => listEquals(e, aday))) {
        alternatifler.add(aday);
      }
    }

    seceneklerSirali = [dogruCokluSecim, ...alternatifler]..shuffle();
    setState(() {
      cevaplandi = false;
      kullaniciCokluSecim = null;
    });
  }

  Future<void> seviye3SesCal() async {
    final random = Random();
    karisikSesSirasi = [];


    int oncekiSes = random.nextInt(3);
    karisikSesSirasi.add(oncekiSes);
    await player.play(AssetSource(sesDosyalari[oncekiSes]));
    await Future.delayed(Duration(milliseconds: 1000));


    for (int i = 1; i < 5; i++) {
      int yeniSes;
      do {
        yeniSes = random.nextInt(3);
      } while (yeniSes == oncekiSes);
      oncekiSes = yeniSes;
      karisikSesSirasi.add(yeniSes);
      await player.play(AssetSource(sesDosyalari[yeniSes]));
      await Future.delayed(Duration(milliseconds: 1000));
    }

    dogruCokluSecim = List.from(karisikSesSirasi);


    List<List<int>> alternatifler = [];
    while (alternatifler.length < 2) {
      List<int> aday = List.from(dogruCokluSecim)..shuffle();
      bool uygun = !listEquals(aday, dogruCokluSecim) &&
          !alternatifler.any((e) => listEquals(e, aday)) &&
          aday.where((e) => e == 2).length == dogruCokluSecim.where((e) => e == 2).length;
      if (uygun) alternatifler.add(aday);
    }

    seceneklerSirali = [dogruCokluSecim, ...alternatifler]..shuffle();
    setState(() {
      cevaplandi = false;
      kullaniciCokluSecim = null;
    });
  }


  void kontrolEtCoklu(List<int> secilen) {
    setState(() {
      cevaplandi = true;
      dogruMu = listEquals(secilen, dogruCokluSecim);
      kullaniciCokluSecim = secilen;
      if (dogruMu) {
        dogruSayac++;
        if (dogruSayac >= 4 && seviye == 2) {
          seviye = 3;
          dogruSayac = 0;
          yanlisSayac = 0;
        }
      } else {
        yanlisSayac++;
      }
    });
  }

  String get ilerlemeMesaji {
    int kalan = 4 - dogruSayac;
    if (kalan > 0 && seviye <= 2) {
      return "$kalan tane bilirsen Seviye $seviye’yi başarıyla geçeceksin";
    } else if (kalan <= 0 && seviye == 2) {
      return "Tebrikler! Seviye 3'e geçildi.";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Ses Perde - Seviye $seviye",
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    if (ilerlemeMesaji.isNotEmpty)
                      Text(ilerlemeMesaji, style: TextStyle(color: Colors.white, fontSize: 14)),
                    if (tanitimMesaji != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          tanitimMesaji!,
                          style: TextStyle(color: Colors.amberAccent, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 20),
                    if (tanitimModu && seviye == 1)
                      ElevatedButton(
                        onPressed: sesTanitimOynat,
                        child: Text("🎧 Tanıtım Seslerini Dinle"),
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          if (seviye == 1) tekliSesCal();
                          else if (seviye == 2) cokluSesCal();
                          else if (seviye == 3) seviye3SesCal();
                        },
                        child: Text(seviye == 1 ? "Sesi Çal" : "Sesleri Oynat"),
                      ),
                    const SizedBox(height: 20),
                    if (!tanitimModu)
                      (seviye == 1)
                          ? Column(
                        children: List.generate(3, (i) {
                          Color renk = Colors.black45;
                          if (cevaplandi) {
                            if (i == aktifSesIndex && !dogruMu) {
                              renk = Colors.green;
                            } else if (i == kullaniciSecimi && !dogruMu) {
                              renk = Colors.red;
                            } else if (i == aktifSesIndex && dogruMu) {
                              renk = Colors.green;
                            }
                          }
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: renk),
                            onPressed: cevaplandi ? null : () => kontrolEtTekli(i),
                            child: Text(secenekEtiketleri[i]),
                          );
                        }),
                      )
                          : Column(
                        children: seceneklerSirali.map((liste) {
                          bool dogruCevap = listEquals(liste, dogruCokluSecim);
                          bool secilenMi = listEquals(liste, kullaniciCokluSecim);
                          Color renk = Colors.black45;
                          if (cevaplandi) {
                            if (dogruCevap) renk = Colors.green;
                            else if (secilenMi && !dogruCevap) renk = Colors.red;
                          }
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: renk),
                            onPressed: cevaplandi ? null : () => kontrolEtCoklu(liste),
                            child: Text(liste.map((e) => secenekEtiketleri[e]).join(" → ")),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 20),
                    if (cevaplandi)
                      Column(
                        children: [
                          Text(
                            dogruMu ? "✅ Doğru!" : "❌ Yanlış!",
                            style: TextStyle(
                                color: dogruMu ? Colors.greenAccent : Colors.redAccent,
                                fontSize: 20),
                          ),
                          if (yanlisSayac >= 5)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "🌟 Harika çabalıyorsun! Denemeye devam et, başarı yakın!",
                                style: TextStyle(color: Colors.amberAccent, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            )
                        ],
                      ),
                  ],
                ),
              ),
            ),
            if (seviye == 1 && !tanitimModu)
              Positioned(
                top: 25,
                right: 15,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                  onPressed: () {
                    setState(() {
                      tanitimModu = true;
                    });
                    sesTanitimOynat();
                  },
                  child: Text("Tanıtımı Tekrar Dinle"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
