import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class Harfdansisayfasi extends StatefulWidget {
  const Harfdansisayfasi({super.key});

  @override
  State<Harfdansisayfasi> createState() => _HarfdansisayfasiState();
}

class _HarfdansisayfasiState extends State<Harfdansisayfasi> with TickerProviderStateMixin {
  final List<String> tumHarfler = ['A', 'M', 'S', 'L', 'B', 'C', 'D', 'E', 'K', 'N'];
  final AudioPlayer _player = AudioPlayer();

  List<String> gosterilenHarfler = [];
  List<String> hedefSira = [];
  List<String> kullaniciSecim = [];
  bool tanitimBitmedi = true;
  bool oyunBitti = false;
  int seviye = 1;

  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      tumHarfler.length,
          (index) => AnimationController(vsync: this, duration: const Duration(milliseconds: 500)),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 10.0)
          .chain(CurveTween(curve: Curves.elasticInOut))
          .animate(controller)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            controller.reverse();
          }
        });
    }).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) => _siraliSesTanitim());
  }

  Future<void> _siraliSesTanitim() async {
    final random = tumHarfler.toList()..shuffle();
    final harfSayisi = seviye == 1 ? 4 : 6;
    gosterilenHarfler = random.take(harfSayisi).toList();
    hedefSira = List.from(gosterilenHarfler)..shuffle();

    setState(() {
      tanitimBitmedi = true;
      kullaniciSecim.clear();
      oyunBitti = false;
    });

    for (int i = 0; i < hedefSira.length; i++) {
      final harf = hedefSira[i];
      final index = tumHarfler.indexOf(harf);
      _controllers[index].forward(from: 0);
      await _player.play(AssetSource('harf_sesleri/${harf}.mp3'));
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    setState(() {
      tanitimBitmedi = false;
    });
  }

  void _harfeTiklandi(String harf) async {
    if (tanitimBitmedi || oyunBitti) return;

    setState(() {
      kullaniciSecim.add(harf);
    });

    int index = tumHarfler.indexOf(harf);
    _controllers[index].forward(from: 0);
   await _player.play(AssetSource('harf_sesleri/${harf}.mp3'));

    if (kullaniciSecim.length == hedefSira.length) {
      if (_listelerEsitMi(hedefSira, kullaniciSecim)) {
        setState(() {
          oyunBitti = true;
        });
        if (seviye == 1) {
          _seviyeGecisMesaji();
        } else {
          _basariliMesaj();
        }
      } else {
        setState(() => kullaniciSecim.clear());
      }
    }
  }

  bool _listelerEsitMi(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  void _seviyeGecisMesaji() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(

          title: const Text("🎉 Seviye Atlama!"),
          content: const Text("Tebrikler, şimdi 2. seviyeye geçiyorsun!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  seviye = 2;
                });
                _siraliSesTanitim();
              },
              child: const Text("Devam Et"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Bitir"),
            ),

          ],

        );
      },
    );
    Future.delayed(const Duration(milliseconds: 500), () async {
      await _player.play(AssetSource('harf_sesleri/tebrikler.mp3'));
    });
  }
  void _basariliMesaj() {
    showDialog(
      context: context,
      builder: (context) {
        Future.microtask(() async {
          await _player.play(AssetSource('harf_sesleri/tebrikler.mp3'));
        });
        return AlertDialog(
          title: const Text("🎉 Harika!"),
          content: const Text("Sıralamayı doğru yaptın!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _siraliSesTanitim();
              },
              child: const Text("Tekrar Oyna"),
            ),
            if (seviye >= 2)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                },
                child: const Text("Bitir"),
              ),
          ],
        );
      },
    );
  }

  Widget _harfKutusu(String harf) {
    int index = tumHarfler.indexOf(harf);
    bool yanlis = kullaniciSecim.length > hedefSira.length
        ? true
        : kullaniciSecim.length > 0 &&
        kullaniciSecim.length <= hedefSira.length &&
        kullaniciSecim[kullaniciSecim.length - 1] != hedefSira[kullaniciSecim.length - 1];

    return GestureDetector(
      onTap: () => _harfeTiklandi(harf),
      child: AnimatedBuilder(
        animation: _animations[index],
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_animations[index].value),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: kullaniciSecim.contains(harf)
                      ? (yanlis ? Colors.red : Colors.green)
                      : Colors.deepPurple,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Text(harf, style: const TextStyle(fontSize: 24, color: Colors.deepPurple)),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Harf Dansı"), backgroundColor: Colors.deepPurple),
      backgroundColor: const Color(0xFFF3E5F5),
      body: Stack(
        children: [
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: gosterilenHarfler.map(_harfKutusu).toList(),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: TextButton(
              onPressed: () {
                _siraliSesTanitim();
              },
              child: const Text("🔁 Değiştir"),
            ),
          ),
        ],
      ),

    );
  }
}

