import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_weekly/models/weather_model.dart';

class WeatherService {
  Future<String> _getLocation() async {
    // Kullanıcının konumu açık mı kontrol ettik
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Konum servisiniz kapalı");
    }

    // Kullanıcı konum izni vermiş mi kontrol ettik
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Konum izni vermemişse tekrar izin istedik
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Yine vermemişse hata döndürdük
        Future.error("Konum izni vermelisiniz");
      }
    }

    // Kullanıcının pozisyonunu aldık
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Kullanıcı pozisyonundan yerleşim noktasını bulduk
    final List<Placemark> placemark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Şehrimizi yerleşim noktasından kaydettik
    String? city = placemark[0].locality ?? placemark[0].administrativeArea;

    // EĞER ŞEHİR HALA BOŞSA (Emülatör hatası), VARSAYILAN BİR ŞEHİR ATAYALIM
    if (city == null || city.isEmpty) {
      city = "Ankara"; // Buraya test için istediğin şehri yazabilirsin
    }

    print("İstek atılacak şehir: $city");
    return city;
  }

  Future<List<WeatherModel>> getWeatherData() async {
    final String city = await _getLocation();

    final String url =
        "https://api.collectapi.com/weather/getWeather?lang=tr&city=${Uri.encodeComponent(city)}";

    const Map<String, dynamic> headers = {
      "authorization": "apikey 4I8DBYg8ETDeJrEZwwa0Pl:3Ht4IwjahVH2H75O2ecEDa",
      "content-type": "application/json",
    };

    final dio = Dio();

    final response = await dio.get(url, options: Options(headers: headers));
    // 👇 DEBUG için buraya ekle
    print(response.data);
    print(response.data.runtimeType);

    if (response.statusCode != 200) {
      throw Exception("Bir sorun oluştu");
    }

    final data = response.data;

    final List<dynamic> resultList = response.data;

    final List<WeatherModel> weatherList = resultList
        .map((e) => WeatherModel.fromJson(e))
        .toList();

    return weatherList;
  }
}
