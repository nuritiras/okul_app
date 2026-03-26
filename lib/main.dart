import 'package:flutter/material.dart';
import 'api_service.dart';
import 'ogrenci_model.dart';

void main() {
  runApp(const OkulApp());
}

class OkulApp extends StatelessWidget {
  const OkulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Okul Yönetim Sistemi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const OgrenciListeEkrani(),
    );
  }
}

class OgrenciListeEkrani extends StatefulWidget {
  const OgrenciListeEkrani({super.key});

  @override
  State<OgrenciListeEkrani> createState() => _OgrenciListeEkraniState();
}

class _OgrenciListeEkraniState extends State<OgrenciListeEkrani> {
  final ApiService apiService = ApiService();
  late Future<List<Ogrenci>> ogrenciListesi;

  @override
  void initState() {
    super.initState();
    _listeyiYenile();
  }

  void _listeyiYenile() {
    setState(() {
      ogrenciListesi = apiService.fetchOgrenciler();
    });
  }

  void _ogrenciFormDialog({Ogrenci? ogrenci}) {
    final isUpdate = ogrenci != null;
    final adController = TextEditingController(text: isUpdate ? ogrenci.ad : '');
    final soyadController = TextEditingController(text: isUpdate ? ogrenci.soyad : '');
    final numaraController = TextEditingController(text: isUpdate ? ogrenci.numara.toString() : '');

    showDialog(
      context: context,
      // Ana context ile karışmaması için buraya 'dialogContext' adını veriyoruz.
      builder: (dialogContext) => AlertDialog(
        title: Text(isUpdate ? "Öğrenci Güncelle" : "Yeni Öğrenci Ekle"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: adController, decoration: const InputDecoration(labelText: "Ad")),
            TextField(controller: soyadController, decoration: const InputDecoration(labelText: "Soyad")),
            TextField(
              controller: numaraController, 
              decoration: const InputDecoration(labelText: "Okul No"), 
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), 
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (adController.text.isNotEmpty && numaraController.text.isNotEmpty) {
                final yeniVeri = Ogrenci(
                  id: isUpdate ? ogrenci.id : null,
                  ad: adController.text,
                  soyad: soyadController.text,
                  numara: int.parse(numaraController.text),
                );
                
                // Asenkron istek atılıyor...
                bool basarili = isUpdate 
                    ? await apiService.ogrenciGuncelle(ogrenci.id!, yeniVeri)
                    : await apiService.ogrenciEkle(yeniVeri);

                // Asenkron işlem bittikten sonra dialog hala ekranda mı? (Güvenlik kontrolü)
                if (!dialogContext.mounted) return;
                
                // Önce dialog penceresini güvenle kapatıyoruz
                Navigator.pop(dialogContext);
                
                // Ana ekran (State) hala hayatta mı? (Güvenlik kontrolü)
                if (!mounted) return;

                if (basarili) {
                  _listeyiYenile();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isUpdate ? "Güncellendi!" : "Eklendi!"))
                  );
                }
              }
            },
            child: Text(isUpdate ? "Güncelle" : "Kaydet"),
          ),
        ],
      ),
    );
  }

  void _ogrenciSil(int id) async {
    bool basarili = await apiService.ogrenciSil(id);
    
    // İşlem bittikten sonra ekran kapandıysa metottan çık
    if (!mounted) return; 

    if (basarili) {
      _listeyiYenile();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silindi!"), backgroundColor: Colors.red)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Öğrenci Yönetimi"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _listeyiYenile)
        ],
      ),
      body: FutureBuilder<List<Ogrenci>>(
        future: ogrenciListesi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Kayıtlı öğrenci yok."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final ogrenci = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(child: Text(ogrenci.ad[0].toUpperCase())),
                  title: Text("${ogrenci.ad} ${ogrenci.soyad}"),
                  subtitle: Text("Numara: ${ogrenci.numara}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue), 
                        onPressed: () => _ogrenciFormDialog(ogrenci: ogrenci)
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            // Burada da dialog context'ini ayırıyoruz
                            builder: (dialogContext) => AlertDialog(
                              title: const Text("Emin misiniz?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext), 
                                  child: const Text("İptal")
                                ),
                                TextButton(
                                  onPressed: () { 
                                    Navigator.pop(dialogContext); 
                                    _ogrenciSil(ogrenci.id!); 
                                  }, 
                                  child: const Text("Sil", style: TextStyle(color: Colors.red))
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
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ogrenciFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}