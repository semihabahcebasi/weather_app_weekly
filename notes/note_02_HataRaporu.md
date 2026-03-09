# Flutter Weather App – API JSON Parse Hatası Raporu

* *Problem Tanımı*

Flutter uygulamasında hava durumu verilerini çekmek için Dio kullanılarak bir API isteği yapıldı. Gelen veriler WeatherModel sınıfına dönüştürülerek ListView içinde gösterilmek isteniyordu.

Ancak uygulama çalıştırıldığında aşağıdaki hatalar alındı:

```
type 'List<dynamic>' is not a subtype of type 'Map<String, dynamic>'
```

ve daha sonra:

```
type 'String' is not a subtype of type 'int' of 'index'
```

Bu hatalar uygulamanın API'den gelen JSON verisini yanlış veri tipi varsayımıyla parse etmeye çalışmasından kaynaklanıyordu.

* *Hatanın Kaynağı*

Başlangıçta API'nin şu formatta veri döndürdüğü varsayıldı:
```
{
  "success": true,
  "result": [
    {...},
    {...}
  ]
}
```

Bu nedenle kodda şu şekilde bir erişim yapıldı:
```
final data = response.data;
final List<dynamic> resultList = data["result"];
```
Ancak debug sırasında response.data çıktısı incelendiğinde API'nin aslında şu formatta veri döndürdüğü görüldü:
```
[
  {
    "date": "3/9/2026",
    "day": "Pazartesi",
    "icon": "...",
    "degree": 6.71
  },
  {
    "date": "3/10/2026",
    "day": "Salı"
  }
]
```
* **Yani API Map değil doğrudan List döndürüyordu.*

Bu nedenle "*result*" anahtarına erişmeye çalışmak tip uyuşmazlığı hatasına sebep oldu.

**Debug Süreci**

Sorunun kaynağını anlamak için API cevabı terminale yazdırıldı.
```
print(response.data);
print(response.data.runtimeType);
```

Terminal çıktısı:
```
List<dynamic>
```
Bu çıktı API'den gelen verinin *Map* değil *List* olduğunu açıkça gösterdi.

 ### **Çözüm**

*response.data* doğrudan bir liste olduğu için "result" anahtarına erişmek yerine veri *direkt* kullanılmalıdır.

*Hatalı Kod*
```
final data = response.data;
final List<dynamic> resultList = data["result"];
Doğru Kod
final List<dynamic> resultList = response.data;
```
Daha sonra *liste* *WeatherModel* nesnelerine *dönüştürülür*:

```
final List<WeatherModel> weatherList = resultList
    .map((e) => WeatherModel.fromJson(e))
    .toList();
Final Çalışan Kod
final dio = Dio();

final response = await dio.get(url, options: Options(headers: headers));

if (response.statusCode != 200) {
  throw Exception("Bir sorun oluştu");
}

final List<dynamic> resultList = response.data;

final List<WeatherModel> weatherList = resultList
    .map((e) => WeatherModel.fromJson(e))
    .toList();

return weatherList;
```
##### Önemli Dersler

Bu süreçte şu önemli çıkarımlar elde edildi:

**1️⃣ API JSON formatı her zaman kontrol edilmelidir**

JSON parse işlemi yapılmadan önce şu kod mutlaka çalıştırılmalıdır:
```
print(response.data);
print(response.data.runtimeType);
```
**2️⃣ JSON yapısı yanlış varsayılmamalıdır**

API bazen:
```
Map<String,dynamic>
```
bazen de:
```
List<dynamic>
```
döndürebilir.

**3️⃣ Hata mesajları dikkatle okunmalıdır**

Bu hatalar veri tipinin yanlış kullanıldığını açıkça belirtir:
```
List<dynamic> is not a subtype of Map<String,dynamic>
```
**Sonuç**

*Sorunun nedeni API'den gelen JSON verisinin Map yerine List olması ve kodda "result" anahtarına erişilmeye çalışılmasıydı.*

*response.data doğrudan liste olarak kullanıldığında problem tamamen çözülmüştür.*