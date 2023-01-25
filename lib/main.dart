import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prova123/previsioni.dart';
import 'package:prova123/profile.dart';
import 'package:prova123/repository/forecast.dart';
import 'package:prova123/serra.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenHouse 2.0',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: StreamBuilder<Forecast>(
            stream: Stream.periodic(const Duration(seconds: 1)).asyncMap((event) => ForecastRepository().getForecastForZipCode(30015)),
            builder: (BuildContext context, AsyncSnapshot<Forecast> snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      Text("Caricamento dati...")
                    ],
                  ),
                );
              } else {
                return dammiHome(snapshot.data, context);
              }
            }),
      ),
    ));
  }

  dammiHome(data, context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: time(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
                child: const Icon(
                  Icons.account_circle,
                  size: 50,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        WeatherWidget(forecast: data),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Text(
            "Informazioni serre",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(72, 183, 183, 183),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SerraPage()),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.yard, size: 40),
                      ),
                      Text("Serra Alpha"),
                    ]),
                    const Icon(Icons.chevron_right, size: 30),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  time() {
    DateTime adesso = DateTime.now();
    String giorno = DateFormat('EEEE').format(DateTime.now());
    switch (giorno) {
      case "Monday":
        giorno = "Lunedì";
        break;
      case "Tuesday":
        giorno = "Martedì";
        break;
      case "Wednesday":
        giorno = "Mercoledì";
        break;
      case "Thursday":
        giorno = "Giovedì";
        break;
      case "Friday":
        giorno = "Venerdì";
        break;
      case "Saturday":
        giorno = "Sabato";
        break;
      case "Sunday":
        giorno = "Domenica";
        break;
    }
    String mese = DateFormat('MMMM').format(DateTime.now());
    switch (mese) {
      case "January":
        mese = "Gennaio";
        break;
      case "February":
        mese = "Febbraio";
        break;
      case "March":
        mese = "Marzo";
        break;
      case "April":
        mese = "Aprile";
        break;
      case "May":
        mese = "Maggio";
        break;
      case "June":
        mese = "Giugno";
        break;
      case "July":
        mese = "Luglio";
        break;
      case "August":
        mese = "Agosot";
        break;
      case "September":
        mese = "Settembre";
        break;
      case "October":
        mese = "Ottobre";
        break;
      case "November":
        mese = "Novembre";
        break;
      case "December":
        mese = "Dicembre";
        break;
    }
    final DateFormat formatter = DateFormat('dd £ yyyy');
    String formatted = formatter.format(adesso);
    formatted = formatted.replaceAll("£", mese);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          giorno,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
        Text(
          formatted,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
