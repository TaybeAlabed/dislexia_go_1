import 'package:flutter/material.dart';
import 'dart:math';

class FernaldSayfasi extends StatefulWidget {
  const FernaldSayfasi({super.key});

  @override
  State<FernaldSayfasi> createState() => _FernaldSayfasiState();
}

class _FernaldSayfasiState extends State<FernaldSayfasi> with TickerProviderStateMixin {
  final List<String> kelimeler = [
    "kitap",
    "kalem",
    "okul",
    "elma",
    "çanta",
    "masa",
    "yazılım",
    "kumanda",
    "telefon",
    "bulut",
  ];

  int kelimeIndex = 0;
  late String dogruKelime;
  late List<String> harfler;
  List<String?> yerlestirilen = [];
  List<Color> kutuRenkleri = [];

  int yildizSayisi = 5;
  int ipucuHakki = 0;
  late AnimationController _yanlisAnimController;

  @override
  void initState() {
    super.initState();
    _hazirla();

    _yanlisAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
  }

  @override
  void dispose() {
    _yanlisAnimController.dispose();
    super.dispose();
  }

  void _hazirla() {
    dogruKelime = kelimeler[kelimeIndex];
    harfler = dogruKelime.split("");
    harfler.shuffle();
    yerlestirilen = List<String?>.filled(dogruKelime.length, null);
    kutuRenkleri = List<Color>.filled(dogruKelime.length, Colors.white);
    ipucuHakki = 0;
  }

  void _kontrolEt() {
    if (yerlestirilen.join() == dogruKelime) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Tebrikler!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Doğru kelimeyi oluşturdunuz."),
              const SizedBox(height: 16),
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
                _siradakiKelime();
              },
              child: const Text("Sonraki"),
            )
          ],
        ),
      );
    }
  }

  void _siradakiKelime() {
    setState(() {
      if (kelimeIndex < kelimeler.length - 1) {
        kelimeIndex++;
        yildizSayisi = 5;
        _hazirla();
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Tüm kelimeler tamamlandı!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    kelimeIndex = 0;
                    yildizSayisi = 5;
                    _hazirla();
                  });
                },
                child: const Text("Baştan Başla"),
              )
            ],
          ),
        );
      }
    });
  }

  void _gosterIpucu() {
    if (ipucuHakki >= 4) return;
    setState(() {
      ipucuHakki++;
      if (ipucuHakki < 4) {
        for (int i = 0; i < dogruKelime.length; i++) {
          if (yerlestirilen[i] == null) {
            yerlestirilen[i] = dogruKelime[i];
            harfler.remove(dogruKelime[i]);
            kutuRenkleri[i] = Colors.blue.shade100;
            break;
          }
        }
        if (ipucuHakki % 2 == 0 && yildizSayisi > 0) yildizSayisi--;
      } else {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("İpucu: Tüm Kelime"),
            content: Text("Kelime: $dogruKelime"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Kapat"),
              ),
            ],
          ),
        );
      }
    });
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
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.lightbulb_outline, color: Colors.yellow, size: 32),
              onPressed: _gosterIpucu,
              tooltip: "İpucu ($ipucuHakki/4)",
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Doğru Kelimeyi Oluşturun",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => Icon(
                  index < yildizSayisi ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                )),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(dogruKelime.length, (index) {
                  return DragTarget<String>(
                    onAccept: (veri) {
                      setState(() {
                        if (dogruKelime[index] == veri) {
                          yerlestirilen[index] = veri;
                          harfler.remove(veri);
                          kutuRenkleri[index] = Colors.green.shade100;
                          _kontrolEt();
                        } else {
                          kutuRenkleri[index] = Colors.red.shade200;
                          _yanlisAnimController.forward(from: 0);
                          yildizSayisi = max(0, yildizSayisi - 1);
                        }
                      });
                    },
                    builder: (context, adaylar, red) {
                      return AnimatedBuilder(
                        animation: _yanlisAnimController,
                        builder: (context, child) {
                          final offset = 10.0 * _yanlisAnimController.value;
                          return Transform.translate(
                            offset: Offset(sin(offset * pi * 10), 0),
                            child: Container(
                              margin: const EdgeInsets.all(6),
                              width: 60,
                              height: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 2),
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
              const SizedBox(height: 40),
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
        ],
      ),
    );
  }

  Widget _buildHarfKutu(String harf) {
    return Container(
      width: 60,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
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
}
