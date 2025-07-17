import 'package:dislexia_go/BolumlerSayfasi.dart';
import 'package:dislexia_go/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';


class HikayeTiyatroSayfasi extends StatefulWidget {
  const HikayeTiyatroSayfasi({super.key});
  @override
  State<HikayeTiyatroSayfasi> createState() => _HikayeTiyatroSayfasiState();
}
bool baslatDurdur=false;
class _HikayeTiyatroSayfasiState extends State<HikayeTiyatroSayfasi> {
  @override
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    SesYonetici.durdur();
  }
  Widget build(BuildContext context) {
    var yukseklik=MediaQuery.of(context).size.height;
    var genislik=MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              Image.asset(
                "resimler/Harfler.png",
                fit: BoxFit.cover,
                width: genislik,
                height: yukseklik,
              ),


              Positioned(
                left: 16,
                top: 16,
                child: baslatDurdur
                    ? TextButton.icon(
                  label: Text(
                    "Durdur",
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                  icon: Icon(Icons.pause, color: Colors.black, size: 40),
                  onPressed: () {
                    setState(() {
                      baslatDurdur = false;
                    });
                  },
                )
                    : TextButton.icon(
                  label: Text(
                    "Başlat",
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                  icon: Icon(Icons.play_arrow, color: Colors.red, size: 40),
                  onPressed: () {
                    setState(() {
                      baslatDurdur = true;
                    });
                  },
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_outlined),
                  onPressed: (){

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BolumlerSayfasi()));
                  },
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Peki sen olsan ne yapardın?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              textStyle: TextStyle(fontSize: 13),
                            ),
                            child: Text("Hiçbirşey söylemeden oradan uzaklaşırdım.",style: TextStyle(color: Colors.white),),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.mic, size: 16,color: Colors.white,),
                            label: Text("Şarkı söylerdim !",style: TextStyle(color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              textStyle: TextStyle(fontSize: 13),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              textStyle: TextStyle(fontSize: 13),
                            ),
                            child: Text("Bugün mutluluğumu kimse bozamaz derdim.",style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),





        ),
      ),

    );

  }
}

