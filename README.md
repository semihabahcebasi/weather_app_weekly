# 🌦️ Haftalık Hava Durumu Uygulaması (Weather App)

Bu proje, Flutter kullanılarak geliştirilen bir haftalık hava durumu uygulamasıdır. Kullanıcılar uygulama üzerinden istedikleri şehirlerin günlük ve haftalık hava durumu tahminlerini görüntüleyebilirler.

Uygulama, CollectAPI Weather API üzerinden veri çekmekte ve şehir bazlı hava durumu bilgilerini JSON formatında almaktadır. Bu sayede kullanıcılar, sıcaklık, minimum ve maksimum değerler, hava durumu açıklamaları ve ikonlar gibi detayları görebilirler.

Veri çekme sürecinde Dio ve http paketleri kullanılmış, API çağrıları Postman ile test edilmiştir. Kullanıcı konumuna göre otomatik hava durumu bilgisi almak için ise Geolocator ve Geocoding paketleri ile cihazın konum verisi alınmakta ve ilgili şehrin hava durumu gösterilmektedir.

Uygulama arayüzü, ListView ve kart tabanlı tasarım kullanılarak, her bir günün hava durumu bilgilerini görsel olarak sunmaktadır. Böylece kullanıcılar hızlıca haftalık hava tahminini takip edebilirler.

*son sürüm 10.03.2026*
