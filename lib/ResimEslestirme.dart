import 'package:dislexia_go/BolumlerSayfasi.dart';
import 'package:dislexia_go/main.dart';
import 'package:flutter/material.dart';

class ResimEslestirme extends StatefulWidget {
  const ResimEslestirme({Key? key}) : super(key: key);

  @override
  State<ResimEslestirme> createState() => _ResimEslestirmeState();
}

class _ResimEslestirmeState extends State<ResimEslestirme> {
  final Map<String, bool> dogruEslestirme = {};

  final List<Map<String, String>> nesneler = [
    {"isim": "at", "resim": "resimler/Figurler/at.png", "golge": "resimler/Figurler/atGolge.png"},
    {"isim": "cilek", "resim": "resimler/Figurler/cilek.png", "golge": "resimler/Figurler/cilekGolge.png"},
    {"isim": "elma", "resim": "resimler/Figurler/elma.png", "golge": "resimler/Figurler/elmaGolge.png"},
    {"isim": "inek", "resim": "resimler/Figurler/inek.png", "golge": "resimler/Figurler/inekGolge.png"},
    {"isim": "kedi", "resim": "resimler/Figurler/kedi.png", "golge": "resimler/Figurler/kediGolge.png"},
    {"isim": "pc", "resim": "resimler/Figurler/Pc.png", "golge": "resimler/Figurler/pcGolge.png"},
    {"isim": "top", "resim": "resimler/Figurler/top.png", "golge": "resimler/Figurler/topGolge.png"},
    {"isim": "yilan", "resim": "resimler/Figurler/yilan.png", "golge": "resimler/Figurler/yilanGolge.png"},
  ];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    SesYonetici.durdur();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: Image.asset(
              'resimler/arkaplan6.png',
              fit: BoxFit.cover,
            ),
          ),


          Column(
            children: [
              const SizedBox(height: 35),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 1.6,
                  padding: const EdgeInsets.all(8),
                  children: nesneler.map((nesne) {
                    return DragTarget<String>(
                      onAccept: (veri) {
                        setState(() {
                          dogruEslestirme[veri] = veri == nesne["isim"];


                          if (dogruEslestirme.length == nesneler.length &&
                              dogruEslestirme.values.every((v) => v == true)) {
                            Future.delayed(const Duration(milliseconds: 500), () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset("animations/lottie.gif", height: 150),
                                        const SizedBox(height: 12),
                                        const Text(
                                          "Tebrikler! 🎉",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BolumlerSayfasi())),
                                          child: const Text("Kapat"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          }
                        });
                      },
                      builder: (context, adaylar, redler) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          width: 65,
                          height: 65,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.08),

                            borderRadius: BorderRadius.circular(8),

                          ),
                          child: Center(
                            child: dogruEslestirme[nesne["isim"]] == true
                                ? Image.asset(nesne["resim"]!, height: 55, width: 55, fit: BoxFit.contain)
                                : Image.asset(nesne["golge"]!, height: 55, width: 55, fit: BoxFit.contain),
                          ),
                        );

                      },
                    );
                  }).toList(),
                ),
              ),

              const Divider(height: 10, color: Colors.black),
              const Text("Şekilleri aşağıdan yukarıya sürükle!", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),


              SizedBox(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: nesneler.map((nesne) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Draggable<String>(
                        data: nesne["isim"]!,
                        feedback: Image.asset(nesne["resim"]!, height: 75, width: 75),
                        childWhenDragging: Opacity(
                          opacity: 0.4,
                          child: Image.asset(nesne["resim"]!, height: 75, width: 75),
                        ),
                        child: Image.asset(nesne["resim"]!, height: 75, width: 75),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
          Positioned(
            left: 10,
            top: 10,
            child: IconButton(
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BolumlerSayfasi())),
              icon:  Icon(Icons.arrow_back,color: Colors.black,),
            ),
          ),
        ],
      ),
    );
  }
}
