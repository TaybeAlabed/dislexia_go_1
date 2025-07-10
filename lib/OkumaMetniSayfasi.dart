import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OkumaMetniSayfasi(),
  ));
}

class OkumaMetniSayfasi extends StatefulWidget {
  @override
  State<OkumaMetniSayfasi> createState() => _OkumaMetniSayfasiState();
}

class _OkumaMetniSayfasiState extends State<OkumaMetniSayfasi> {
  final List<String> metinler = [
    """
    Bir varmış bir yokmuş, Evvel zaman içinde, cinler cirit oynarken eski hamam içinde. Yellerin estiği, sellerin coştuğu bir ülke varmış. Ama ülke de ülke imiş ki; bir yanda devler tef çalar, öbür yanda çengiler oyun oynarmış. Ala gözlüler karakaşa sürme çeker, fidan boyular göz edermiş. Dertliler derman, dertsizler de dert bulurmuş, Düzensizliklerle esenlikler bu ülkede kol gezermiş. Buna ese de şaşar, bizim kambur köse de. Derken efendim hindi asmaya biner, evim dermiş. Eşekler ahırda bir uzun türkü tuttururmuş. Derken işe tavuklar, ördekler de karışır tam bir bayram havası esermiş.

İşte bu ülkede bir de çiftlik varmış. Bu çiftlikte de boyu kısa, kendisi topalacık, gözü alçacık horoz; boyu uzun, gururu yüksek hindi; bir de beş parmaklı, alçak ayaklı badi, yani ördek varmış. İmdi oturalım masal taşına, görelim neler gelmiş bu üç haylazın başına.

Çiftliktir, yaşanılacak yerdir demeyin. Bülbülü altın kafese koymuşlar da ah vatan demiş. Bizim üç ahbap çavuşlar da öyle. Aşağı gitmişler, yukarı gitmişler. Geceyi gün, günü gece etmişler. Ama olmamış. Canları çok sıkılmış. Bir gün oturmuşlar, kafa kafaya verip düşünmeye koyulmuşlar. Kırda hayat var, bakın açmış bin bir çiçek, Lâlenin alı çiğdemin sarısı, ana can katar menekşenin kokusu demişler de çiftlikten çıkmaya karar vermişler. Tarlada dolaşalım, yüce yüce dağlar aşalım, gelin kaçalım demişler. Vermişler pek çabuk karar.
    """,

    """
    Yola koyulmuşlar. Az gitmişler uz gitmişler, dere tepe düz, yedi yılla bir güz gitmişler. Altıda bir üstüde bir bu yerin, bari sağ oldukça yaşamak gerek diye söylenmişler. Sağa sola bakmadan kaçmış üç ahbap çavuşlar.

Hava güneşli, açıkmış. Kırlar geniş, cana can katarmış. Gezmek, tozmak, yaşamak denmiş de yaşamalarına bakmışlar. Sürülen sefa kârımızdır diye hayıflanmışlar. Ama böyle yerler pek gezmeye gelmez, tehlikeler çoktur. Tehlikelerin olduğu yerde hayat yoktur. Akıllarına getirmemişler bu durumları hiç üç ahbap çavuşlar. Başıboş dolaşmışlar.

Dolaşmak güzel şeydir işi yolunda olana, üç haylaz düşünmemiş hiç bunu. Zaman akıp gitmiş. Ne su veren olmuş ne de ekmek. Geri dönmek de pek güç gelmiş. Yaptıklarına pişman olmuşlar, ama çiftliğe dönmeyi de onurlarına yedirememişler. Birbirleri ile bakmışlar bakışmışlar, kişi ne çekerse kafasından çeker demişler. Ağrısız başımız, pişmiş aşımız vardı. Yolumuz açık, karnımız toktu. Ne düşüncesiz aklımız varmış, kaçmışız demişler. Ama iş işten geçmiş.
    """,

    """ 
    Akşam olmak üzere imiş. Alaca karanlığın çöküşü ile gecenin korkusu başlamış. Derken dağın izli bir yerinden bir dev çıkagelmiş. Neye uğradıklarını şaşırmışlar. Karşı gelsek, güç yok. Gelmesek hayat yok demişler de kaçalım, belki kurtuluruz diye düşünmüşler. Koyulmuşlar yola, varmışlar Hindistan’a

Hindistan bir âlem. Ortalık düğün bayram. Kazanmanın yolunu aramışlar. Hokkabazlık yapıp iyi para kazanmışlar. Aldık yükümüzü, tamamladık gayri geçimimizi, gelin gidip kuralım evimizi demişler.

Nasiptendir her şey bu dünyada. Aç gözlü olmayacaksın, fazla da uzamayacaksın. Ama bizim üç ahbap çavuş uzamış, dönüp dolaşıp gelmişler bir mağaraya. Meğer orası devin hazinesi ile doluymuş, görenlerin gözlerini alırmış. Bizim üç ahbap çavuşların da gözlerini almış. Derken başlamışlar aşırmaya, ama tamamen kurtulduk demeye vakit kalmamış, umulmadık bir yerden çıkan tilki üç haylazı avlamış.

Ne diyelim, akılsız başın cezasını kişinin kendisi çekermiş. Onlar da çekmişler cezalarını, darısı bizim akılsızların başına.
    """,
  ];

  int currentPage = 0;
  late PageController _controller;
  bool _showHint = true;

  @override
  void initState() {
    super.initState();
    _controller = PageController();


    Timer.periodic(Duration(seconds: 3), (timer) {
      if (currentPage == 0) {
        setState(() {
          _showHint = !_showHint;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
bool mic=true;
  @override
  Widget build(BuildContext context) {
    var yukseklk=MediaQuery.of(context).size.height;
    var genislik=MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [

          PageView.builder(
            controller: _controller,
            itemCount: metinler.length,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Image.asset(
                    "resimler/OkumaMetniSayfasiArkaPlan.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 40, vertical: 100),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          metinler[index],
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            left: 10,
            top: 10,
            child: IconButton(icon: Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,),onPressed: (){

              Navigator.pop(context);

            },
            ),
          ),


          Positioned(
            left: 200,
            top: 10,
            child: SizedBox(
              width: 75,
              height: 75,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Yapay Zekadan Yardım almak için ona tıkla")),
                  );
                },
                child: Opacity(
                  opacity: 0.6,
                  child: Image.asset("resimler/YapayZeka.png"),
                ),
              ),
            ),
          ),
          mic ?
          Positioned(
            left: 300,
            top: 10,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  mic = !mic;
                });
              },
              child: Opacity(
                opacity: 0.6,
                child: Icon(
                  Icons.mic,
                  size: 80,
                  color: mic ? Colors.red : Colors.red,
                ),
              ),
            ),
          )
          :
          Positioned(
            left: 300,
            top: 10,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  mic = !mic;
                });
              },
              child: Opacity(
                opacity: 0.6,
                child: Icon(
                  Icons.mic,
                  size: 80,
                  color: mic ? Colors.red : Colors.green,
                ),
              ),
            ),
          ),


          Positioned(
            right: 15,
            top: 15,
            child: AnimatedOpacity(
              opacity: (_showHint && currentPage == 0) ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Row(
                children: [
                  Text(
                    "Kaydır",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.fast_forward,size: 20,color: Colors.red,),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




