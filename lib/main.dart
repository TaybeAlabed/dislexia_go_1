import 'package:dislexia_go/Anasayfa.dart';
import 'package:dislexia_go/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

var tfkullaniciAdi=TextEditingController();
var tfSifre=TextEditingController();

Future<void> veriSil()async{

  tfkullaniciAdi.text="";
  tfSifre.text="";

}

class HarfliLoginEkrani extends StatefulWidget {
  const HarfliLoginEkrani({super.key});

  @override
  State<HarfliLoginEkrani> createState() => _HarfliLoginEkraniState();
}

class _HarfliLoginEkraniState extends State<HarfliLoginEkrani>
    with TickerProviderStateMixin {
  final List<String> harfler = ["A1", "R", "S", "K", "U", "G","S", "K", "A1", "R", "G", "U"];
  final List<AnimationController> _controllerList = [];
  final List<Animation<double>> _animationList = [];
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    veriSil();
    for (int i = 0; i < harfler.length; i++) {
      final controller = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      )..repeat(reverse: true);

      final animation = Tween<double>(begin: -0.4, end: 0.4).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );

      _controllerList.add(controller);
      _animationList.add(animation);
    }
  }
  bool muzikAcik = true;

  Future<void> girisKontrol(BuildContext context)async{
var sp=await SharedPreferences.getInstance();
    var ka=tfkullaniciAdi.text;var s=tfSifre.text;

if(ka==""&&s==""){
      sp.setString("ka", ka);
      sp.setString("s", s);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Anasayfa()));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Giriş Hatalı")));
    }

  }



  @override
  void dispose() {
    for (var controller in _controllerList) {
      controller.dispose();
    }
    super.dispose();
  }
  bool kontrol=true;
  bool durum=true;
  bool ses1=true;
  @override
  Widget build(BuildContext context) {
    var yukseklik = MediaQuery.of(context).size.height;
    var genislik = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: SingleChildScrollView(
        child: Column(
          children: [
        

        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(harfler.length, (index) {
                final renkler = [
                  Colors.orange,
                  Colors.green,
                  Colors.red,
                  Colors.amber,
                  Colors.blueAccent,
                  Colors.yellow,
                  Colors.orange,
                  Colors.green,
                  Colors.red,
                  Colors.amber,
                  Colors.blueAccent,
                  Colors.yellow
                ];
        
                final List<double> ipUzunluklari = [40, 70, 60, 90, 50, 110,40, 70, 60, 100, 50, 75];
        
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: SizedBox(
                    height: 180,
                    width: 45,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [

                        Positioned(
                          top: 0,
                          child: Container(
                            width: 0,
                            color: renkler[index],
                          ),
                        ),
        

                        AnimatedBuilder(
                          animation: _animationList[index],
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _animationList[index].value,
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [

                                  Container(
                                    width: 4,
                                    height: ipUzunluklari[index],
                                    color: renkler[index],
                                  ),

                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: renkler[index],
                                      shape: BoxShape.circle,
                                    ),
                                  ),

                                  Image.asset(
                                    "resimler/${harfler[index]}.png",
                                    width: 30,
                                  ),
        
        
                                ],
                              ),
        
                            );
                          },
                        ),
        
                      ],
        
                    ),
        
                  ),
        
                );
        
              }),
        
            ),
        
        
        
        
             SizedBox(height: 1),
        

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: EdgeInsets.only(left: genislik/10),
                  child: const TMaskot(),
                ),
                const SizedBox(width: 10),
                Column(
                  children: [
                    SizedBox(
                      width: genislik / 2.5,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: TextField(
                          controller: tfkullaniciAdi,
                          decoration: InputDecoration(
                            hintText: "Kullanıcı Adı :",
                            hintStyle:
                            const TextStyle(fontSize: 20, color: Colors.white),
                            filled: true,
                            fillColor: Colors.black45,
                            prefixIcon: const Icon(Icons.person, color: Colors.white),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: genislik / 2.5,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextField(
                          obscureText: _obscurePassword,
                          controller: tfSifre,
                          decoration: InputDecoration(
                            hintText: "Parola :",
                            hintStyle: const TextStyle(fontSize: 20, color: Colors.white),
                            filled: true,
                            fillColor: Colors.black45,
                            prefixIcon: const Icon(Icons.lock, color: Colors.white),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                  ],
                ),


                SizedBox(width: genislik/8,),




              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(left: genislik/7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  kontrol ?
                  TextButton(

                    style: TextButton.styleFrom(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                      backgroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 39),
                    ),
                    child: const Text(
                      "Giriş",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    onPressed: () {
                      girisKontrol(context);
                      setState(() {
                        kontrol=false;
                      });
                    },
                  )
                      :
                  TextButton(


                    style: TextButton.styleFrom(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 39),
                    ),
                    child: const Text(
                      "Giriş",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        kontrol=true;
                      });
                    },
                  ),


                  const SizedBox(width: 15),




                  durum ?
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                    ),
                    child: const Text(
                      "Kayıt Ol",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        durum=false;
                      });
                    },
                  )
                      :
                  TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                    ),
                    child: const Text(
                      "Kayıt Ol",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        durum=true;
                      });
                    },
                  ),

                  ses1 ?
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: IconButton(
                      icon: Icon(Icons.music_note_sharp,color: Colors.white,),
                      onPressed: (){
                        setState(() {

                          ses1=false;
                        });
                      },
                    ),
                  )
                      :
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: IconButton(
                      icon: Icon(Icons.music_off,color: Colors.white,),
                      onPressed: (){

                        setState(() {
                          ses1=true;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
      duration: const Duration(milliseconds: 200),
    );

    _blinkAnimation = Tween<double>(begin: 0, end: 8).animate(_controller);


    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 3 + Random().nextInt(3)));
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
        Image.asset("resimler/T.png", width: 100),


        Positioned(
          top: 6,
          left: 38,
          child: AnimatedBuilder(
            animation: _blinkAnimation,
            builder: (context, child) {
              return Container(
                width: 10,
                height: _blinkAnimation.value,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 6,
          right: 45,
          child: AnimatedBuilder(
            animation: _blinkAnimation,
            builder: (context, child) {
              return Container(
                width: 10,
                height: _blinkAnimation.value,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


class SesYonetici {
  static final AudioPlayer _player = AudioPlayer();
  static String _aktifDosya = 'melodi.mp3';

  static Future<void> baslat([String? yeniDosya]) async {
    if (yeniDosya != null) {
      _aktifDosya = yeniDosya;
    }

    await _player.stop();
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource('melodi/$_aktifDosya'));
  }

  static Future<void> durdur() async {
    await _player.stop();
  }

  static Future<void> kapat() async {
    await _player.dispose();
  }

  static String get aktifDosya => _aktifDosya;
}


