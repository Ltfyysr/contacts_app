import 'package:flutter/material.dart';
import 'package:kisiler_uygulamasi/entity/kisiler.dart';
import 'package:kisiler_uygulamasi/views/kisi_detay_sayfa.dart';
import 'package:kisiler_uygulamasi/views/kisi_kayit_sayfa.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool aramaYapiliyorMu = false;


  Future<List<Kisiler>> tumKisilerGoster() async{
    var kisilerListesi =<Kisiler> [];
    var k1 = Kisiler(kisi_id: 1, kisi_ad: "Ahmet", kisi_tel: "1111");
    var k2 = Kisiler(kisi_id: 2, kisi_ad: "Zeynep", kisi_tel: "2222");
    var k3 = Kisiler(kisi_id: 3, kisi_ad: "Beyza", kisi_tel: "3333");
    kisilerListesi.add(k1);
    kisilerListesi.add(k2);
    kisilerListesi.add(k3);
    return kisilerListesi;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu ?
            TextField(decoration: const InputDecoration(hintText: "Ara"),
              onChanged: (aramaSonucu){
              print("Kişi ara: $aramaSonucu");
            },)
            : const Text("Kişiler"),
        actions: [
          aramaYapiliyorMu ?
          IconButton(onPressed: () {
            setState(() {aramaYapiliyorMu= false;});
            }, icon: Icon(Icons.clear)) :
          IconButton(onPressed: () {
            setState(() {aramaYapiliyorMu= true;});
            }, icon: Icon(Icons.search))
        ],
      ),
      body: FutureBuilder<List<Kisiler>>(
        future: tumKisilerGoster(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var kisilerListesi = snapshot.data;
            return ListView.builder(
              //dinamik liste oldugundan .builder dedik
              itemCount: kisilerListesi!.length,//kac tane veri calistircam bunu yaziyoz 3
              itemBuilder: (context,indeks){//nereyi calistiracak 0,1,2
                var kisi= kisilerListesi[indeks];
                return GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KisiDetaySayfa(
                              kisi: kisi,
                            ))).then((value) {
                      print("Detay sayfasından anasayfaya dönüldü");
                    });
                  },
                  child: Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${kisi.kisi_ad} - ${kisi.kisi_tel}"),
                        ),
                        const Spacer(),
                        IconButton(onPressed: () {
                         ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(
                              content: Text("${kisi.kisi_ad} silinsin mi?"),
                             action: SnackBarAction(
                               label: "Evet",
                               onPressed: (){
                                 print("Kişi sil : ${kisi.kisi_id}");//silmeyi id ile yapariz
                               },
                             ),
                           ),
                         );
                        }, icon:const Icon(Icons.delete_outline_outlined,color: Colors.black54,))
                      ],
                    ),
                  ),
                );
              }
            );
          }else{
            return const Center();
          }
        }
      )  ,
      floatingActionButton: FloatingActionButton.extended(
        //extended edip yanina yazı ekledik
        icon: const Icon(Icons.add),
        label: const Text("Kayıt"),
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => KisiKayitSayfa()))
              .then((value) {
            print("Kayıt sayfasından anasayfaya dönüldü");
          });

        },
      ),
    );
  }
}
