import 'dart:math';
import 'package:dislexia_go/main.dart';
import 'package:flutter/material.dart';

class Kayitsayfasi extends StatefulWidget {
  const Kayitsayfasi({super.key});

  @override
  State<Kayitsayfasi> createState() => _KayitsayfasiState();
}

class _KayitsayfasiState extends State<Kayitsayfasi> {
  @override
  Widget build(BuildContext context) {
    var yukseklik=MediaQuery.of(context).size.height;
    var genislik=MediaQuery.of(context).size.width;

    return Scaffold(
backgroundColor: Colors.deepPurpleAccent,
      body: Stack(
        children: [
          Positioned(
            left: 20,
            top: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.black45,),
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HarfliLoginEkrani()));
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [




              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                      width: genislik/2,
                      height: 75,
                      child: Image.asset("resimler/logo1.png")),
                ],
              ),


              Padding(

                padding: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: TMaskot(),
                    ),

                    Column(
                      children: [
                        SizedBox(
                          width: 350,
                          height: 50,
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIconColor: Colors.white,
                              prefixIcon: Icon(Icons.supervised_user_circle,color: Colors.white,),
                              hintText: "Kullanıcı adınız",
                              hintStyle: TextStyle(fontSize: 20,color: Colors.white70),
                              filled: true,
                              fillColor: Colors.black45,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                          ),
                        ),


                        SizedBox(height: yukseklik/100,),
                        SizedBox(
                          width: 350,
                          height: 50,
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.mail,color: Colors.white,),
                              hintText: "e-mail adresiniz",
                              hintStyle: TextStyle(fontSize: 20,color: Colors.white70),
                              filled: true,
                              fillColor: Colors.black45,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),

                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: yukseklik/100,),
                        SizedBox(
                          width: 350,
                          height: 50,
                          child: TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.password,color: Colors.white,),
                              hintText: "Parolanız",
                              hintStyle: TextStyle(fontSize: 20,color: Colors.white70),
                              filled: true,
                              fillColor: Colors.black45,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),

                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black26,
                              ),
                              child: Text("Kayıt Ol",style: TextStyle(color: Colors.white),),
                              onPressed: (){

                              },
                            ),
                            TextButton(
                              child: Text("Yardım",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                              onPressed: (){

                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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

    _blinkAnimation = Tween<double>(begin: 50, end: 5).animate(_controller);


    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 1 + Random().nextInt(1)));
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
    double gozCapi = 50;
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset("resimler/kayitT.png", width: 175),

      ],
    );
  }
}