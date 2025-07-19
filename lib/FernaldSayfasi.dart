import 'dart:async';
import 'dart:math';
import 'package:dislexia_go/BolumlerSayfasi.dart';
import 'package:dislexia_go/main.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class FernaldSayfasi extends StatefulWidget {
  const FernaldSayfasi({super.key});

  @override
  State<FernaldSayfasi> createState() => _FernaldSayfasiState();
}

class _FernaldSayfasiState extends State<FernaldSayfasi> with TickerProviderStateMixin {
  final List<String> kelimeListesi = ["elma", "kitap", "okulda", "kumanda", "yazilimci"];
  int seviye = 0;

  late String kelime;
  late List<String> harfler;
  List<String?> yerlestirilen = [];
  List<Color> kutuRenkleri = [];
  String geriBildirim = "";

  late AnimationController _yanlisAnimController;
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _anlatimPlayer = AudioPlayer();
  static Timer? _tempoTimer;
  DateTime? _sonTempoZamani;

  int yildizSayisi = 5;

  @override
  void initState() {
    super.initState();
    _hazirlaSeviye();
    _yanlisAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _oyunTanitimSesiniCal();
    SesYonetici.durdur();
  }

  void _hazirlaSeviye() {
    kelime = kelimeListesi[seviye];
    harfler = kelime.split("")..shuffle();
    yerlestirilen = List<String?>.filled(kelime.length, null);
    kutuRenkleri = List<Color>.filled(kelime.length, Colors.white);
    yildizSayisi = 5;
  }

  void _oyunTanitimSesiniCal() async {
    await _anlatimPlayer.play(AssetSource("sesler/tempo_tanitim.mp3"));
    await Future.delayed(const Duration(seconds: 9));
    _baslatTempo();
  }

   void _baslatTempo({int sureMs = 1500}) {
    _tempoTimer?.cancel();
    _tempoTimer = Timer.periodic(Duration(milliseconds: sureMs), (timer) async {
      await _player.play(AssetSource("sesler/tok.mp3"));
      _sonTempoZamani = DateTime.now();
    });
  }

  void _sonrakiSeviye() {
    if (seviye < kelimeListesi.length - 1) {
      setState(() {
        seviye++;
        _hazirlaSeviye();
        _baslatTempo(sureMs: 1000);
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Tüm seviyeler tamamlandı!"),
          actions: [
            TextButton(
              onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BolumlerSayfasi()));
      _tempoTimer?.cancel();
      _player.stop();
      _anlatimPlayer.stop();
      Navigator.pop(context);
      },
              child: const Text("Tamam"),
            )
          ],
        ),
      );
    }
  }

  String _kahramanAd() {
    switch (yildizSayisi) {
      case 1:
        return "Ben 10";
      case 2:
        return "Batman";
      case 3:
        return "Kaptan Amerika";
      case 4:
        return "ironman";
      case 5:
      default:
        return "Spider-Man";
    }
  }

  String _kahramanResmi() {
    switch (yildizSayisi) {
      case 1:
        return "assets/kahramanlar/ben10.jpeg";
      case 2:
        return "assets/kahramanlar/batman.jpeg";
      case 3:
        return "assets/kahramanlar/captan.jpeg";
      case 4:
        return "assets/kahramanlar/ironman.jpeg";
      case 5:
      default:
        return "assets/kahramanlar/spiderman.jpeg";
    }
  }

  void _kontrolEt() {
    if (yerlestirilen.join() == kelime) {
      _tempoTimer?.cancel();
      showDialog(
        context: context,
        builder: (_) => SingleChildScrollView(
          child: AlertDialog(
            title: const Text("Tebrikler!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Tebrikler tıpkı bir ${_kahramanAd()} gibiydiniz!", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Image.asset(_kahramanResmi(), height: 120),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => Icon(
                    index < yildizSayisi ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  )),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _sonrakiSeviye();
                },
                child: const Text("Sonraki Seviye"),
              )
            ],
          ),
        ),
      );
    }
  }

  void _gosterGeriBildirim(String mesaj) {
    setState(() => geriBildirim = mesaj);
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => geriBildirim = "");
    });
  }

  Widget _buildHarfKutu(String harf) {
    return Container(
      width: 60,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Text(
        harf,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "resimler/OkumaMetniSayfasiArkaPlan.png",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Seviye ${seviye + 1} - Harfleri Kutulara Sürükle"),
              const SizedBox(height: 20),
              Text(
                geriBildirim,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(kelime.length, (index) {
                  return DragTarget<String>(
                    onAccept: (veri) {
                      setState(() {
                        if (kelime[index] == veri) {
                          yerlestirilen[index] = veri;
                          harfler.remove(veri);
                          kutuRenkleri[index] = Colors.green.shade100;

                          final tempoZamani = _sonTempoZamani;
                          if (tempoZamani != null) {
                            final fark = DateTime.now().difference(tempoZamani).inMilliseconds;
                            if (fark.abs() <= 500) {
                              _gosterGeriBildirim("🎯 Mükemmel zamanlama!");
                            } else {
                              yildizSayisi = max(1, yildizSayisi - 1);
                              _gosterGeriBildirim("⏳ Daha iyisi olabilir");
                            }
                          }
                          _kontrolEt();
                        } else {
                          kutuRenkleri[index] = Colors.red.shade200;
                          yildizSayisi = max(1, yildizSayisi - 1);
                          _yanlisAnimController.forward(from: 0);
                        }
                      });
                    },
                    builder: (context, adaylar, red) {
                      return AnimatedBuilder(
                        animation: _yanlisAnimController,
                        builder: (context, child) {
                          final offset = 10.0 * _yanlisAnimController.value;
                          return Transform.translate(
                            offset: Offset(sin(offset * 3.14 * 10), 0),
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              width: 60,
                              height: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(8),
                                color: kutuRenkleri[index],
                              ),
                              child: Text(
                                yerlestirilen[index] ?? "",
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: harfler.map((harf) {
                  return Draggable<String>(
                    data: harf,
                    feedback: Material(
                      color: Colors.transparent,
                      child: _buildHarfKutu(harf),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: _buildHarfKutu(harf),
                    ),
                    child: _buildHarfKutu(harf),
                  );
                }).toList(),
              )
            ],
          ),
          Positioned(
            left: 10,
            top: 10,
            child: IconButton( icon: Icon(Icons.arrow_back),
            onPressed: (){
              _tempoTimer?.cancel();
              _player.stop();
              _anlatimPlayer.stop();

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BolumlerSayfasi()));
            },
            ),
          ),
        ],
      ),
    );
  }
}
