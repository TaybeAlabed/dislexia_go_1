import 'package:dislexia_go/BolumlerSayfasi.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'main.dart';

class OrtonHeceSayfasi extends StatefulWidget {
  const OrtonHeceSayfasi({super.key});

  @override
  State<OrtonHeceSayfasi> createState() => _OrtonHeceSayfasiState();
}

class _OrtonHeceSayfasiState extends State<OrtonHeceSayfasi> with TickerProviderStateMixin {

  final List<List<String>> tumKelimeHeceleri = [
      ["an", "ne"],
    ["yol", "cu", "luk"],
    ["me", "ka", "ni", "z", "ma"],
    ["or", "man", "cı"],
    ["da", "ya", "nış", "ma"],
    ["o", "to", "büs"],
    ["ka", "lem", "lik"],
    ["sa", "lı"],
    ["per", "şem", "be"],
    ["cu", "mar", "te", "si"],
    ["haf", "ta"],
    ["me", "nek", "şe"],
    ["ak", "var", "yum"],
    ["has", "ta", "lık"],
    ["ba", "ba"],
    ["tey", "ze"],
    ["bi", "sik", "let"],
    ["pa", "zar", "te", "si"],
    ["çar", "şam", "ba"],
    ["cu", "ma"],
    ["pa", "zar"],
    ["he", "li", "kop", "ter"],
    ["hav", "lu"],
    ["ar", "ka", "daş"],
    ["te", "miz", "lik"],
    ["de", "ne", "me"],
    ["ke", "li", "me"],
    ["a", "ra", "ba"],
  ];


  late List<List<String>> aktifKelimeHeceleri;
  int kelimeIndex = 0;

  List<String> dogruHeceler = [];
  List<String> heceler = [];
  List<GlobalKey> _heceKeyler = [];
  List<bool> tetikler = [];
  List<bool> temasEdildi = [];
  Offset cekicKonum = const Offset(300, 100);

  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  late double genislik;
  late double yukseklik;

  @override
  void initState() {
    super.initState();


     SesYonetici.durdur();


     SesYonetici.baslat("orton.mp3");



    tumKelimeHeceleri.shuffle();
    aktifKelimeHeceleri = tumKelimeHeceleri.take(5).toList();
    _setupForKelime();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final boyut = MediaQuery.of(context).size;
      setState(() {
        cekicKonum = Offset(boyut.width * 0.75, boyut.height * 0.2);
      });
    });
  }



  void _setupForKelime() {
    dogruHeceler = aktifKelimeHeceleri[kelimeIndex];

    heceler = List<String>.from(dogruHeceler);
    while (heceler.join() == dogruHeceler.join()) {
      heceler.shuffle();
    }

    tetikler = List.generate(heceler.length, (_) => false);
    temasEdildi = List.generate(heceler.length, (_) => false);
    _heceKeyler = List.generate(heceler.length, (_) => GlobalKey());
    cekicKonum = const Offset(700, 150);
  }

  void _rotateHammer() {
    _rotationController.forward(from: 0);
  }

  void _cekicDokunduMu() {
    for (int i = 0; i < heceler.length; i++) {
      RenderBox? box = _heceKeyler[i].currentContext?.findRenderObject() as RenderBox?;
      if (box == null) continue;
      Offset pos = box.localToGlobal(Offset.zero);
      double mesafe = (cekicKonum - pos).distance;

      if (mesafe < 80 && !temasEdildi[i]) {
        setState(() {
          temasEdildi[i] = true;
          tetikler = List.generate(heceler.length, (j) => j == i);

          if (i == 0) {

            final ilk = heceler.removeAt(0);
            heceler.add(ilk);
          } else {

            final tmp = heceler[i - 1];
            heceler[i - 1] = heceler[i];
            heceler[i] = tmp;
          }

          if (heceler.join() == dogruHeceler.join()) {
            _showCelebration();
          }
        });
      }


      if (mesafe > 80) temasEdildi[i] = false;
    }
  }

  void _showCelebration() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white.withOpacity(0.95),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("animations/kutlama.gif", height: 120),
            const SizedBox(height: 16),
            const Text("Tebrikler!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _ileriGec();
              },
              child: const Text("Sonraki"),
            ),
          ],
        ),
      ),
    );
  }

  void _ileriGec() {
    setState(() {
      if (kelimeIndex < aktifKelimeHeceleri.length - 1) {
        kelimeIndex++;
        _setupForKelime();
      } else {
        _hepsiTamamlandi();
      }
    });
  }

  void _hepsiTamamlandi() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tümünü tamamladınız!"),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                kelimeIndex = 0;
                tumKelimeHeceleri.shuffle();
                aktifKelimeHeceleri = tumKelimeHeceleri.take(5).toList();
                _setupForKelime();
              });
            },
            child: const Text("Baştan Başla"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BolumlerSayfasi()));
              });
            },
            child: const Text("Bitir"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     genislik=MediaQuery.of(context).size.width;
     yukseklik=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "resimler/OkumaMetniSayfasiArkaPlan.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              left: 168,
              top: 50,
              child: Opacity(
                opacity: 0.5,
                child: Container(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Text("Heceleri doğru yere yerleştirmek için çekici heceye sürükle ve bırak."
                        " Temas ettiğin hece sola yani kendinden önceki hece ile yer değiştirir.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
                            width: 250,
                            height: 120,
                            decoration: BoxDecoration(
                color: Colors.black45,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
              )
          ),


          Positioned(
            top: 200,
            left: 100,
            child: Row(
              children: List.generate(heceler.length, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: HecBox(
                    text: heceler[i],
                    key: _heceKeyler[i],
                    tetikleyici: tetikler[i],
                  ),
                );
              }),
            ),
          ),

Positioned(
  left: 10,
  top: 10,
  child: IconButton( icon: Icon(Icons.arrow_back,color: Colors.black,),
  onPressed: (){
    SesYonetici.durdur();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BolumlerSayfasi()));
  },
),),
          Positioned(
            left: cekicKonum.dx,
            top: cekicKonum.dy,
            child: RotationTransition(
              turns: _rotationAnimation,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    double dx = (cekicKonum.dx + details.delta.dx)
                        .clamp(0.0, MediaQuery.of(context).size.width - 80);
                    double dy = (cekicKonum.dy + details.delta.dy)
                        .clamp(0.0, MediaQuery.of(context).size.height - 80);
                    cekicKonum = Offset(dx, dy);
                  });

                  _cekicDokunduMu();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      tetikler = List.generate(heceler.length, (_) => false);
                    });
                  });
                  _rotateHammer();
                },
                child: Image.asset("resimler/cekic.png", width: 80),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class HecBox extends StatefulWidget {
  final String text;
  final bool tetikleyici;

  const HecBox({required this.text, required this.tetikleyici, Key? key}) : super(key: key);

  @override
  State<HecBox> createState() => _HecBoxState();
}

class _HecBoxState extends State<HecBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnim = Tween<double>(begin: 1.0, end: 1.2).chain(CurveTween(curve: Curves.elasticInOut)).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant HecBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tetikleyici != oldWidget.tetikleyici && widget.tetikleyici) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}



