import 'dart:math';

import 'package:dislexia_go/BolumlerSayfasi.dart';
import 'package:dislexia_go/main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HarfTanimaSayfasi(),
  ));
}

class HarfTanimaSayfasi extends StatefulWidget {
  @override
  State<HarfTanimaSayfasi> createState() => _HarfTanimaSayfasiState();
}

class _HarfTanimaSayfasiState extends State<HarfTanimaSayfasi> {

  double _hammerTop = 350;
  double _hammerLeft = 330;

  @override
  Widget build(BuildContext context) {
    double ekranGenisligi = MediaQuery.of(context).size.width;
    double ekranYuksekligi = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [

          Image.asset(
            "resimler/OkumaMetniSayfasiArkaPlan.png",
            width: ekranGenisligi,
            height: ekranYuksekligi,
            fit: BoxFit.cover,
          ),
          Positioned(
            left: 15,
            top: 15,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: (){
                
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BolumlerSayfasi()));
              },
            ),
          ),
          Positioned(
            left: ekranGenisligi/2-125,
            bottom: ekranYuksekligi/2.1,
            child: AnimatedTkol(),
          ),

          Positioned(
            left: ekranGenisligi/2-250,
            top: 100,
            child: SizedBox(
                width: 250,
                child: TMaskot()),
          ),


          Positioned(
            left: ekranGenisligi/2,
            top: ekranYuksekligi/3,
            child: Column(
              children: [
                ElevatedButton(

                  child: Text("Kelime Türetmece Oynayalım",style: TextStyle(color: Colors.black),),
                  onPressed: (){
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text("Tabu Oynayalım",style: TextStyle(color: Colors.black),),
                  onPressed: (){
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton(
                  child: Text("Hikaye Dinlemek İstiyorum",style: TextStyle(color: Colors.black),),
                  onPressed: (){
                  },style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                ),
              ],
            ),
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

class _TMaskotState extends State<TMaskot> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blinkAnimation;
  late AnimationController _smileController;
  late Animation<double> _smileAnimation;

  @override
  void initState() {
    super.initState();
    _smileController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _smileAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _smileController, curve: Curves.easeInOut)
    );
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
    _smileController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double ekranGenisligi = MediaQuery.of(context).size.width;
    double ekranYuksekligi = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            width: 250,height: 250,
            child: Image.asset("resimler/Tanimation.png", width: 300)),

        Positioned(
          bottom: 164,
          left: 105,
          child: AnimatedBuilder(
            animation: _smileController,
            builder: (context, child) {
              return SmileMouth(progress: _smileAnimation.value);
            },
          ),
        ),



        Positioned(
          top: 14.5,
          left: 110,
          child: SizedBox(
            width: 17,
            height: 20,
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
        ),

        Positioned(
          top: 14.5,
          right: 107,
          child: SizedBox(
            width: 17,
            height: 20,
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
        ),
      ],
    );
  }
}



class SmileMouth extends StatelessWidget {
  final double progress;

  const SmileMouth({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(40, 20),
      painter: _SmilePainter(progress),
    );
  }
}

class _SmilePainter extends CustomPainter {
  final double progress;

  _SmilePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();


    final start = Offset(0, size.height / 2);
    final end = Offset(size.width, size.height / 2);


    final control = Offset(size.width / 2, size.height*2.25 / 2 + 10 * progress);



    path.moveTo(start.dx, start.dy);
    path.quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SmilePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}





class AnimatedTkol extends StatefulWidget {
  const AnimatedTkol({Key? key}) : super(key: key);

  @override
  _AnimatedTkolState createState() => _AnimatedTkolState();
}

class _AnimatedTkolState extends State<AnimatedTkol> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _rotationAnim = Tween<double>(begin: 0.0, end: 0.4).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );
    SesYonetici.durdur();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnim,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
        Transform.rotate(
        angle: _rotationAnim.value,
          alignment: Alignment(-0.8, 1.1),
          child: child,
        ),


          ],
        );
      },
      child: Image.asset('resimler/Tkol.png', width: 80),
    );
  }

}


