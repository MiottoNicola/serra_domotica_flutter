/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class SerraPageStorico extends StatefulWidget {
  const SerraPageStorico({Key? key}) : super(key: key);

  @override
  State<SerraPageStorico> createState() => _SerraPageStoricoState();
}
class _SerraPageStoricoState extends State<SerraPageStorico> {
  Future<Dati> getDati() async {
    var data = await http.get(Uri.parse(
        "https://progettomiotto.altervista.org/dati_sensori/get.php?type=app"));
    var jsonData = json.decode(data.body);

    String time = jsonData["sensore"]["time"];
    int humidity = int.parse(jsonData["sensore"]["humidity"]);
    double temperature = double.parse(jsonData["sensore"]["temperature"]);
    int humidityTer = int.parse(jsonData["sensore"]["humidity_ter"]);
    int luminosity = int.parse(jsonData["sensore"]["luminosity"]);
    String led = jsonData["setting"]["led"];
    String rele = jsonData["setting"]["rele"];
    bool modality = false;
    if(jsonData["setting"]["modality"]=="1"){
      modality = true;
    }else if(jsonData["setting"]["modality"]=="0"){
      modality = false;
    }

    return Dati(time, humidity, temperature, humidityTer, luminosity, led, rele, modality);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Storico Valori"),

      ),
      body: Container(
        child: StreamBuilder<Dati>(
          stream: Stream.periodic(Duration(seconds: 2)).asyncMap((event) => getDati()),
          builder: (BuildContext context, AsyncSnapshot<Dati> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("Caricamento dati...")
                  ],
                ),
              );
            } else {
              Dati dati = snapshot.data!;
              return getGraficaSerra(dati);
            }
          },
        ),
      ),);
  }

}

class Dati {
  final String time;
  final int humidity;
  final double temperature;
  final int humidity_ter;
  final int luminosity;
  final String led;
  final String rele;
  final bool modality;

  Dati(this.time, this.humidity, this.temperature, this.humidity_ter, this.luminosity, this.led,
      this.rele, this.modality);
}*/