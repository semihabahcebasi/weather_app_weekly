import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherService {
  Future<String> getLocation() async {
    // Konum servisinin açık olup olmadığını kontrol et
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Konum servisiniz kapalı');
    }

    //kullanıcı konum izni vermiş mi kotrol  ettik

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //izin verilmemişse izin istemek için requestPermission fonksiyonunu çağırdık - tekrar izin istedik
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        //yine vermemişse hata döndürdük
        return Future.error('Konum izni vermelisiniz');
      }
    }

    //kullanıcının konumunu almak için getCurrentPosition fonksiyonunu çağırdık
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ); //kesin konumu için high , yaklaşık konumu için low

    //kullancıı poszisyonunu aldıktan sonra bu konum bilgilerini şehir bilgisine çevirmek için placemarkFromCoordinates fonksiyonunu kullandık
    final List<Placemark> placemark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    //şehrimizi yerleim noktasindan kaydettik
    final String? city = placemark[0].locality;

    if (city == null) Future.error('Şehir bilgisi alınamadı');
    return city!;
  }
}
