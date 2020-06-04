import 'package:http/http.dart' as http;

String mapBoxBaseUrl = "https://api.mapbox.com/geocoding/v5/mapbox.places/";
String apiUrl = "http://127.0.0.1:8000/api/";

class Api {
  static Future getMapPlaces(String search) {
    String url =
        '$mapBoxBaseUrl$search.json?access_token=pk.eyJ1IjoiZGlhZ2EiLCJh'
        'IjoiY2them44ZTlyMGJoaDJ5bG9nbDcwODJnNSJ9.E2iA97q3aNDQUa4EOT7TpA';
    return http.get(url);
  }

  static Future getPredictions(var longitude, var latitude) {
    String url = '${apiUrl}prediction/?longitude=$longitude&latitude=$latitude';
    return http.get(url);
  }
}
