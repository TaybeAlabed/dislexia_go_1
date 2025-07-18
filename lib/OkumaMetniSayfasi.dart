import 'package:dislexia_go/BolumlerSayfasi.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dislexia_go/ses_kayit_yonetici.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';


class OkumaMetniSayfasi extends StatefulWidget {
  @override
  State<OkumaMetniSayfasi> createState() => _OkumaMetniSayfasiState();
}

class _OkumaMetniSayfasiState extends State<OkumaMetniSayfasi> {
  final List<String> metinler = [];
  List<TextSpan>? renkliMetinSpans;

  int currentPage = 0;
  late PageController _controller;
  bool _showHint = true;
  bool mic = true;

  late SesKayitYonetici sesKayitYonetici;
  late FlutterTts flutterTts;

  bool konusuyorMu = false; // sınıf içinde tanımlanmalı


  @override
  void initState() {
    super.initState();
    _controller = PageController();
    sesKayitYonetici = SesKayitYonetici();
    sesKayitYonetici.hazirla();
    fetchDataFromSupabase();
    flutterTts = FlutterTts();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
    await sesKayitYonetici.hazirla(); // <-- await ekledik
    await fetchDataFromSupabase();   // <-- await ekledik
  });
  }

  Future<void> fetchDataFromSupabase() async {
    final response = await Supabase.instance.client
        .from('okuma_metinleri')
        .select('content')
        .order('created_at', ascending: true);

    debugPrint("Supabase verisi: $response");

    setState(() {
      metinler.clear();
      metinler.addAll(response.map<String>((row) => row['content'].toString()));
    });
  }

  Future<void> sesiFlaskAPIyeGonder(String dosyaYolu, String metin) async {
    var uri = Uri.parse("http://127.0.0.1:5000/recognize");
    var request = http.MultipartRequest('POST', uri)
      ..fields['text'] = metin
      ..files.add(await http.MultipartFile.fromPath('audio', dosyaYolu));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      print("✅ Yanıt: $responseBody");

      final decoded = jsonDecode(responseBody);
      final kelimeSonuclar = decoded['words'] as List<dynamic>;

      List<TextSpan> spans = [];

      for (var kelime in kelimeSonuclar) {
        spans.add(
          TextSpan(
            text: "${kelime['word']} ",
            style: TextStyle(
              color: kelime['correct'] ? Colors.green : Colors.red,
              fontSize: 18,
            ),
          ),
        );
      }

      setState(() {
        renkliMetinSpans = spans;
      });
    } else {
      print("❌ Hata: ${response.statusCode}");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var yukseklik = MediaQuery.of(context).size.height;
    var genislik = MediaQuery.of(context).size.width;

    return Scaffold(
      body: metinler.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: metinler.length,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                      renkliMetinSpans = null; // Sayfa değişince eski sonucu temizle
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
                              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 100),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: renkliMetinSpans != null
                                  ? RichText(
                                      text: TextSpan(
                                        children: renkliMetinSpans!,
                                        style: DefaultTextStyle.of(context).style,
                                      ),
                                    )
                                  : Text(
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
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BolumlerSayfasi()));
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
                      onTap: () async {
                        if (konusuyorMu) {
                          await flutterTts.stop();
                          setState(() {
                            konusuyorMu = false;
                          });
                        } else {
                          await flutterTts.setLanguage("tr-TR");
                          await flutterTts.setSpeechRate(0.4);
                          await flutterTts.setPitch(1.0);
                          await flutterTts.speak(metinler[currentPage]);
                          setState(() {
                            konusuyorMu = true;
                          });
                        }
                      },
                      child: Opacity(
                        opacity: 0.6,
                        child: Image.asset("resimler/YapayZeka.png"),
                        ),
                      ),
                    ),
                  ),

                Positioned(
                  left: 300,
                  top: 10,
                  child: GestureDetector(
                    onTap: () async {
                      
                      if (!mic) {
                        await sesKayitYonetici.baslat();
                      } else {
                        final dosyaYolu = await sesKayitYonetici.durdur();
                        if (dosyaYolu != null) {
                          await sesiFlaskAPIyeGonder(dosyaYolu, metinler[currentPage]);
                        }
                      }
                      setState(() => mic = !mic);
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
                        Icon(Icons.fast_forward, size: 20, color: Colors.red),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}