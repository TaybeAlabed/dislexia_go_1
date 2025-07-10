import 'package:dislexia_go/Ayarlar.dart';
import 'package:dislexia_go/BilgilendirmeSayfasi.dart';
import 'package:dislexia_go/BolumlerSayfasi.dart';
import 'package:dislexia_go/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
class Anasayfa extends StatelessWidget {
  const Anasayfa({super.key});
Future<void> cikisYap()async{

  var sp =await SharedPreferences.getInstance();
  await sp.remove("ka");
  await sp.remove("s");


}
  @override
  Widget build(BuildContext context) {
  var yukseklik=MediaQuery.of(context).size.height;
  var genislik=MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text('Menü', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text('Hakkında'),
            ),
            ListTile(

              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {
                Navigator.pop(context); //
                Navigator.push(
                  context,
                   MaterialPageRoute(builder: (context) => const AyarlarSayfasi()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Anasayfa', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {

              cikisYap();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HarfliLoginEkrani()),
                    (route) => false,
              );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
            label: const Text("Çıkış", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      backgroundColor: Colors.deepPurpleAccent,
      body: SingleChildScrollView(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: yukseklik/1.25),
              SizedBox(
                  width: 200,
                  child: TMaskot()),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(context, "Bölümler", Icons.menu_book),
                  const SizedBox(height: 20),
                  _buildButton(context, "Bilgilendirme Sayfası", Icons.info_outline),
                  const SizedBox(height: 20),
                  _buildButton(context, "Ayarlar", Icons.settings),
                ],
              ),
        
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, IconData icon) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: () {
        if (title == "Bölümler") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BolumlerSayfasi()));
        } else if (title == "Bilgilendirme Sayfası") {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  BilgilendirmeSayfasi()));
        } else if (title == "Ayarlar") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AyarlarSayfasi()));
        }
      },
      icon: Icon(icon),
      label: Text(title),
    );
  }

}

class TMaskot extends StatefulWidget {
  const TMaskot({super.key});

  @override
  State<TMaskot> createState() => _TMaskotState();
}

class _TMaskotState extends State<TMaskot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _blinkAnimation = Tween<double>(begin: 0, end: 8).animate(_controller);


    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1 + Random().nextInt(3)));
      if (mounted) {
        await _controller.forward();
        await _controller.reverse();
      }
      return mounted;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset("resimler/DusunT.png", width: 300),

        // Gözler
        // Soldaki göz
        Positioned(
          top: 13,
          left: 81,
          child: AnimatedBuilder(
            animation: _blinkAnimation,
            builder: (context, child) {
              return _blinkAnimation.value > 4
                  ? Container(
                width: 15.5,
                height: 14,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              )
                  : const SizedBox.shrink(); // Göz kapanınca görünmez
            },
          ),
        ),
        //Sağdaki Göz
        Positioned(
          top: 13,
          right: 89,
          child: AnimatedBuilder(
            animation: _blinkAnimation,
            builder: (context, child) {
              return _blinkAnimation.value > 4
                  ? Container(
                width: 15.5,
                height: 14,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              )
                  : const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}



