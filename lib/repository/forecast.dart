
import 'dart:convert';
import 'package:http/http.dart' as http;

class Forecast{
  final String forecastTitle;
  final int forecastID;
  final String forecastDescription;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String icon;

  Forecast({required this.forecastTitle, required this.forecastID, required this.forecastDescription, required this.icon, required this.temperature, required this.humidity, required this.windSpeed});

}

class ForecastRepository{

  String apiKey = "YOUR-TOKEN";

  Future<Forecast> getForecastForZipCode(int zipCode) async{
    var data = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?zip=$zipCode,it&appid=$apiKey&units=metric&lang=it"));
    var jsonData = json.decode(data.body);
     String forecastTitle = jsonData["weather"][0]["main"];
     int forecastID = jsonData["weather"][0]["id"];
     String forecastDescription = jsonData["weather"][0]["description"];
     double temperature = jsonData["main"]["temp"].toDouble();
     int humidity = jsonData["main"]["humidity"];
     double windSpeed = jsonData["wind"]["speed"].toDouble();
     String icon = jsonData["weather"][0]["icon"];
    return Forecast(forecastTitle: forecastTitle, forecastID: forecastID, forecastDescription: forecastDescription, icon: icon, temperature: temperature, humidity: humidity, windSpeed: windSpeed);
  }

  String getIconURL(Forecast forecast){
    return "http://openweathermap.org/img/wn/${forecast.icon}@2x.png";

  }

}


