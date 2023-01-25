import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class SerraPage extends StatefulWidget {
  const SerraPage({Key? key}) : super(key: key);

  @override
  State<SerraPage> createState() => _SerraPageState();
}
class _SerraPageState extends State<SerraPage> {
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
  Future putDati(String type, int value) async{
    var data = await http.get(Uri.parse("https://progettomiotto.altervista.org/dati_sensori/put.php?type=$type&value=$value"));
    return data;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Serra Alpha"),

        ),
        body: Container(
          child: StreamBuilder<Dati>(
            stream: Stream.periodic(Duration(seconds: 1)).asyncMap((event) => getDati()),
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
  getGraficaSerra(dati) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              getGraficaValori(dati),
              getGraficaSetting(dati),
            ],
          )),
    );
  }
  getGraficaValori(dati){
    return Column(
      children: [
        Row(
            children: [
              Expanded(
                flex: 1,
                child: Card(
                    elevation: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Stack(
                        children: [
                          Image.asset("assets/image/temperature.png"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text("Temperatura", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(dati.temperature.toString(), style: TextStyle(fontSize: 35,),),
                                        Text("°C", style: TextStyle(fontSize: 15,)),
                                      ],
                                    ),
                                  ),
                                ],
                            ),
                          ),
                          ]
                        ),
                    ),
                    )
                ),
              Expanded(
                  flex: 1,
                  child: Card(
                    elevation: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Stack(
                          children: [
                            Image.asset("assets/image/humidity.png"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Umidità", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(dati.humidity.toString(), style: TextStyle(fontSize: 35,),),
                                        Text("%", style: TextStyle(fontSize: 20,))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ]
                      ),
                    ),
                  )
              ),
            ]
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Card(
                  elevation: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Stack(
                        children: [
                          Image.asset("assets/image/humidity_ter.png"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(

                                  children: [
                                    Row(children:[ Text("Umidità", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)]),
                                    Row(mainAxisAlignment: MainAxisAlignment.end,children:[ Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      child: Text("terreno", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    )]),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(dati.humidity_ter.toString(), style: TextStyle(fontSize: 35,),),
                                      Text("%", style: TextStyle(fontSize: 20,))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ]
                    ),
                  ),
                )
            ),
            Expanded(
                flex: 1,
                child: Card(
                  elevation: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Stack(
                        children: [
                          Image.asset("assets/image/luminosity.png"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(

                                  children: [
                                    Row(children:[ Text("Luminosità", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)]),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(dati.luminosity.toString(), style: TextStyle(fontSize: 35,),),
                                      Text("%", style: TextStyle(fontSize: 20,))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ]
                    ),
                  ),
                )
            ),
          ]
        ),
      ],
    );
  }

  /*getGraficaValori(dati) {
    return Column(
      children: [
        Text("Dati sensori", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 3, 0, 5),
          child: Container(
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.thermostat, size: 30),
                          Text(
                            " Temperatura",
                            style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                      Row(children: [
                        Text(
                          dati.temperature.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "°C",
                          style: TextStyle(fontSize: 20),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.storm, size: 30),
                      Text(
                        " Umidità aria",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(children: [
                    Text(
                      dati.humidity.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "%",
                      style: TextStyle(fontSize: 20),
                    ),
                  ]),
                ],
              ),
            ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.terrain, size: 30),
                      Text(
                        " Umidità terra",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(children: [
                    Text(
                      dati.humidity_ter.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "%",
                      style: TextStyle(fontSize: 20),
                    ),
                  ]),
                ],
              ),
            ),

        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.brightness_low, size: 30),
                      Text(
                        " Luminosità",
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(children: [
                    Text(
                      "50.0",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "%",
                      style: TextStyle(fontSize: 20),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        Text("ultimo aggiornamento: ${dati.time}",style: TextStyle(fontSize: 11)),
      ],
    );
  }*/

  getGraficaSetting(dati) {
    int value2=3;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Card(
        color: Colors.grey[300],
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Impostazioni serra", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 4, 5),
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        onTap: dati.modality ? (){
                          Fluttertoast.showToast(
                            msg: "Serra automatica attiva",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                          );
                        } : (){
                          if(dati.led=="1"){
                            putDati("led", 0);
                            setState(() {dati.led = "0";});
                          }else if(dati.led=="0"){
                            putDati("led", 1);
                            setState(() {dati.led = "1";});
                          }
                        },
                        child: Container(
                          decoration: setDecoration(dati.modality),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              children: [
                                Icon(iconLampada(dati.led), size: 50),
                                const Text(
                                  "Lampada",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
                        child: Container(
                          decoration: setDecoration(dati.modality),
                          child: InkWell(
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            onTap: dati.modality ? () { Fluttertoast.showToast(
                              msg: "Serra automatica attiva",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                            );
                            }: (){
                              if(dati.rele=="1"){
                                putDati("rele", 0);
                                setState(() {dati.rele = "0";});
                              }else if(dati.rele=="0"){
                                putDati("rele", 1);
                                setState(() {dati.rele = "1";});
                              }
                            },
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: SizedBox(
                              width: 200,
                              child: Column(
                                children: [
                                  Icon(iconRele(dati.rele), size: 50),
                                  const Text(
                                    "Rele pompa",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(150, 183, 183, 183),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Serra automatica",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Switch(
                            value: dati.modality,
                            activeColor: Colors.blue,
                            onChanged: (value){
                              setState(() {
                                if(value==true){
                                  putDati("modality", 1);
                                  setState(() {dati.modality = true;});
                                }else if(value==false){
                                  putDati("modality", 0);
                                  setState(() {dati.modality = false;});
                                }
                              });
                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  iconLampada(led) {
    if (led == "1") {
      return (Icons.flashlight_on);
    } else if (led == "0") {
      return (Icons.flashlight_off);
    }
  }
  iconRele(String rele) {
    if (rele == "1") {
      return (Icons.water);
    } else if (rele == "0") {
      return (Icons.format_color_reset);
    }
  }
  modalita(dato){
    if(dato==0){
      return Text("manuale",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),);
    }else if(dato==1){
      return Text("automatico",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
        ),);
    }else{
      return Text("no");
    }
  }
  setDecoration(data){
    if(data==false){
      return const BoxDecoration(
          color: Color.fromARGB(150, 183, 183, 183),
          borderRadius: BorderRadius.all(Radius.circular(20)));
    }else if(data==true){
      return null;
    }
  }
}

class Dati {
  final String time;
  final int humidity;
  final double temperature;
  final int humidity_ter;
  final int luminosity;
   String led;
   String rele;
   bool modality;

  Dati(this.time, this.humidity, this.temperature, this.humidity_ter, this.luminosity, this.led,
      this.rele, this.modality);
}


