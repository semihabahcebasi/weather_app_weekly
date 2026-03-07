# 🌤️ Flutter Hava Durumu Uygulaması: Geliştirme Günlüğü

Bu rapor, uygulamanın veri kaynağının belirlenmesinden, teknik kurulum aşamalarına ve konum tabanlı şehir bulma mantığına kadar olan tüm süreci kapsamaktadır.

## 1. Veri Kaynağı ve API Yapılandırması
* Uygulamanın veri ihtiyacını karşılamak için **CollectAPI** platformu seçilmiştir

* **Abonelik:** "Free" paket ile aylık 2500 istek hakkı tanımlanmış ve kişisel bir **API Token** oluşturulmuştur
* **Haberleşme Protokolü (Headers):** Sunucuya atılacak her istekte kimlik doğrulaması için `authorization: apikey <token>` formatı hazırlandı
* **Veri Formatı:** Veri alışverişinin standart formatı olan `application/json` olarak belirlendi
* **Ön Test (Postman):** Kod yazımına geçmeden önce `GET` metodu ile verinin sağlıklı gelip gelmediği (200 OK yanıtı) Postman üzerinden doğrulandı
---

## 2. Paket (Library) Yönetimi ve pub.dev
Bilgisayar mühendisliğinde her şeyi sıfırdan yazmak yerine, başkalarının test ettiği "kod kütüphaneleri" (paketler) kullanılırBu paketlerin merkezi **pub.dev** deposudur[cite: 12, 13].

### 🛠️ Kullanılan Temel Paketler ve Görevleri
* **dio / http:** İnternet üzerindeki bir adrese (CollectAPI gibi) gidip veriyi getirmek için kullanılır
* **geolocator:** Cihazın GPS sensörüne bağlanarak enlem ve boylam verilerini alır
* **geocoding:** Alınan karmaşık koordinat sayılarını "Erzincan" gibi okunabilir şehir isimlerine dönüştürür

**Not:** `flutter pub add paket_ismi` komutu, bu paketleri projenin `pubspec.yaml` (alışveriş listesi) dosyasına otomatik olarak kaydeder

---

## 3. Teknik Sorun Çözümü: Windows Geliştirici Modu
`geolocator` paketi eklenirken terminalde "Building with plugins requires symlink support" hatasıyla karşılaşıldı

* **Analiz:** Windows işletim sisteminin, güvenlik protokolleri gereği "sembolik bağlantı" (symlink) oluşturulmasına standart kullanıcı modunda izin vermemesi nedeniyle bu hata alınmıştır
* **Çözüm:** `start ms-settings:developers` komutu ile Windows Geliştirici Ayarları açıldı ve **"Geliştirici Modu"** aktif edilerek gerekli izinler sağlandı. Bu sayede 24 adet bağımlılık sorunsuz şekilde projeye dahil edildi
---

## 4. Konfigürasyon Dosyaları: Projenin Kimlik Belgeleri
* **pubspec.yaml:** Projenin kütüphane listesidir. Eklenen paketlerin tanınması için `pub get` çalıştırılması şarttır
* **AndroidManifest.xml:** Projenin "İşletim Sistemi İzin Belgesidir". Android'e uygulamanın konuma erişmek istediği burada beyan edilir

---

## 5. Konum Tabanlı Şehir Bulma Mantığı
Yazılan `WeatherService` sınıfı, kullanıcının GPS verilerini alıp şehir ismine dönüştürme sürecini yönetir

### 📋 İşleyiş Süreci
1.  **Güvenlik ve İzin Kontrolleri:** GPS servisinin açık olup olmadığı ve uygulamanın konum iznine sahip olup olmadığı kontrol edilir. İzin yoksa kullanıcıdan talep edilir
2.  **Koordinat Alımı:** İzinler tamamsa `LocationAccuracy.high` parametresiyle en hassas koordinatlar (Position) alınır
3.  **Reverse Geocoding:** `placemarkFromCoordinates` fonksiyonu ile enlem/boylam bilgileri adres listesine dönüştürülür ve içinden `locality` (şehir) değeri çekilir

### 💻 Teknik Kavramlar
* **Future<String>:** Konum alma işlemi zaman aldığı için kodun "gelecekte bir değer döndüreceği" sözünü ifade eder
* **Async/Await:** "Bekle ve sonra devam et" mantığıyla çalışarak uygulamanın veri gelmeden işlem yapıp hata almasını önler
* **Null Safety:** `String? city` ifadesindeki soru işareti değerin boş olabileceğini, `city!` ise programcının değerden emin olduğunu belirtir
---
*Bu rapor, Flutter öğrenim yolculuğundaki teknik aşamaları belgelemek amacıyla hazırlanmıştır.*