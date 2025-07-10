import 'package:flutter/material.dart';

class BilgilendirmeSayfasi extends StatelessWidget {
  const BilgilendirmeSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Bilgilendirme"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "🌟 İlham Veren Hikaye: Yanlış Etiketlenenler\n",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Emre, ilkokulun ilk yıllarında sınıfta zorlanan bir öğrenciydi. Harfleri tanımakta, cümleleri takip etmekte ve yazım kurallarını kavramakta arkadaşlarından geri kalıyordu. "
                  "Öğretmenleri onu tembel ya da dikkat eksikliği olan biri sanıyordu. Ailesi ise onun evde zeki sorular soran, olaylara farklı bakan bir çocuk olduğunu biliyordu.\n\n"
                  "Yıllar sonra bir özel eğitim uzmanı, Emre’nin disleksi olduğunu söyledi. Bu bir engel değildi; sadece Emre’nin beyninin dili farklı işlediğinin bir işaretiydi. "
                  "Emre, özel desteklerle sesli okuma, harita ve görsel kartlar gibi yöntemlerle ilerleme kaydetti. Kısa sürede öğrenme tarzını tanımayı başardı.\n\n"
                  "Bugün Emre, başarılı bir grafik tasarımcı. Görsel hafızası ve farklı düşünme biçimi sayesinde dikkat çeken işler yapıyor. "
                  "Bir zamanlar “yavaş öğrenen” olarak görülen Emre, şimdi başkalarına ilham veren biri haline geldi.\n",
              style: TextStyle(
                fontSize: 18,
                height: 1.5,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "🧠 Disleksi ile Yaşamış Ünlüler:\n",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "• Albert Einstein – Çocukken konuşma güçlüğü yaşadı. Disleksi belirtileri olduğu düşünülüyor.\n"
                  "• Agatha Christie – Yazım hataları yapıyordu ama tarihin en çok satan yazarlarından biri oldu.\n"
                  "• Whoopi Goldberg – Okulda zorlandı ama Oscar ödüllü oyuncu oldu.\n"
                  "• Steve Jobs – Farklı düşünen biriydi, Apple'ı kurdu.\n",
              style: TextStyle(fontSize: 18, height: 1.5, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              "💬 Mesaj:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Disleksi bir engel değil, farklı bir potansiyeldir. Önemli olan çocuğun nasıl öğrendiğini keşfetmek ve ona uygun destek vermektir.",
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                height: 1.5,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
