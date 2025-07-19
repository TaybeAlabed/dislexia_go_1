import 'package:dislexia_go/BolumlerSayfasi.dart';
import 'package:dislexia_go/HarfDansiSayfasi.dart';
import 'package:dislexia_go/SesPerdeEslesmesiSayfasi.dart';
import 'package:dislexia_go/main.dart';
import 'package:flutter/material.dart';

class RitmikYaziOkumaSayfasi extends StatefulWidget {
  const RitmikYaziOkumaSayfasi({super.key});

  @override
  State<RitmikYaziOkumaSayfasi> createState() => _RitmikYaziOkumaSayfasiState();
}

class _RitmikYaziOkumaSayfasiState extends State<RitmikYaziOkumaSayfasi> {
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SesYonetici.durdur();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "resimler/OkumaMetniSayfasiArkaPlan.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 10,
            top: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.black,),
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BolumlerSayfasi()));
              },
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(" Ritmik Yazı ve Okuma  ",style: TextStyle(fontSize: 25,color: Colors.white),),
                  Icon(Icons.queue_music,size: 40 ,color: Colors.white,),
                ],
              ),

              const SizedBox(height: 10),
              const Text(
                "Aşağıdaki etkinliklerden birini seçerek ritim eşliğinde yazma ve okuma becerilerini geliştirebilirsin!",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 2/1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10,
                  children: [
                    _buildMiniGameCard(
                      context,
                      title: "Sesi Sırala",
                      icon: Icons.music_note,
                      color: Colors.orangeAccent,
                      onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (_) => SesPerdeGelistirilmisSayfa()));
                      },
                    ),

                    _buildMiniGameCard(
                      context,
                      title: "Ritmi Tekrarla",
                      icon: Icons.animation,
                      color: Colors.pinkAccent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => Harfdansisayfasi()));
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "🧠 Bilgi: Ritim ve tempo temelli çalışmalar, beynin dil ve dikkat merkezlerini destekler. Bu bölümde eğlenirken öğrenmeyi deneyimle!",
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildMiniGameCard(BuildContext context,
      {required String title,
        required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
