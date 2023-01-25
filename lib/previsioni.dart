import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prova123/repository/forecast.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class Previsioni {
  final String tipo;
  final int cloud;
  final double temp;
  final int hum;
  final double wind_speed;

  Previsioni(this.tipo, this.cloud, this.temp, this.hum, this.wind_speed);
}

class WeatherWidget extends StatelessWidget {
  Forecast forecast;
  WeatherWidget({required this.forecast});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: selectColor(),
      child:
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Meteo" , style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                        Row(
                          children: const [
                            Icon(Icons.place, size: 15),
                            Text("Chioggia", style: TextStyle(fontSize: 10))
                          ],
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              Image.network(
                ForecastRepository().getIconURL(forecast),
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    forecast.forecastDescription.capitalize(),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.thermostat, size: 15),
                  Text(
                    "${forecast.temperature}°C",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                  const Icon(Icons.storm, size: 15),
                  Text(
                    "${forecast.humidity}%",
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                  const Icon(Icons.air, size: 15),
                  Text(
                    "${forecast.windSpeed}km/h",
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }

  selectColor(){
    DateTime adesso = DateTime.now();
    final DateFormat formatter = DateFormat('H');
    String formatted = formatter.format(adesso);
    if(int.parse(formatted) > 20){
      return Colors.blue[400];
    }else{
      return Colors.blue[100];
    }
  }
}
