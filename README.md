
```markdown
# Öğrenci Yönetim Sistemi - Mobil App (Flutter)

Bu proje, Öğrenci Yönetim Sistemi'nin mobil arayüzüdür (Frontend). Django ile yazılmış olan REST API'ye bağlanarak veritabanındaki öğrencileri listeler, yeni öğrenci ekler, günceller ve siler (Tam CRUD işlemleri).

## Özellikler
* **Asenkron API İstekleri:** `http` paketi kullanılarak backend ile JSON tabanlı güvenli iletişim.
* **Modern ve Güvenli State Yönetimi:** Asenkron işlemler (`await`) sırasında uygulamanın çökmesini önleyen `mounted` kontrolleri ve güncel `BuildContext` kullanımı.
* **Kullanıcı Dostu UI:** Anlık geri bildirimler (SnackBar), onay pencereleri (Dialog) ve Material 3 tasarım diline uygun arayüz.

## Kurulum ve Çalıştırma

### 1. Gereksinimler
* Flutter SDK (Güncel sürüm önerilir)
* Android Studio / Xcode (Emülatör/Simülatör için) veya fiziksel bir cihaz

### 2. Backend Bağlantı Ayarları (ÇOK ÖNEMLİ)
Uygulamanın çalışabilmesi için Django sunucusunun arka planda çalışıyor olması gerekir. 
`lib/api_service.dart` dosyasındaki `baseUrl` değişkenini test ortamınıza göre ayarlamalısınız:

* **Android Emülatör kullanıyorsanız:** `http://10.0.2.2:8000/api/ogrenciler/`
* **iOS Simülatör veya Web kullanıyorsanız:** `http://127.0.0.1:8000/api/ogrenciler/`
* **Gerçek Cihaz kullanıyorsanız:** Bilgisayarınızın yerel IP adresini yazmalısınız (Örn: `http://192.168.1.45:8000/api/ogrenciler/`)

### 3. Projeyi Başlatma
Bağımlılıkları indirmek ve projeyi çalıştırmak için terminalde şu komutları kullanın:

```bash
# Paketleri indirin
flutter pub get

# Uygulamayı çalıştırın
flutter run
```

## Ekran Görüntüleri ve Kullanım
* Sağ alt köşedeki **(+)** butonuna basarak yeni öğrenci ekleyebilirsiniz.
* Listedeki bir öğrencinin yanındaki **Kalem** ikonuna basarak bilgilerini güncelleyebilir, **Çöp Kutusu** ikonuna basarak silebilirsiniz.
* Sağ üstteki **Yenile** ikonuna basarak sunucudaki güncel verileri anında çekebilirsiniz.
* <img width="1275" height="855" alt="Ekran Görüntüsü 2026-03-26 10-14-26" src="https://github.com/user-attachments/assets/86140657-c086-4097-992f-ccadbb5bfa7f" />
```
