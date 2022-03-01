import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Times> fetchTimes() async {
  final response = await http.get(
      Uri.parse('https://api.pray.zone/v2/times/today.json?city=kuala-lumpur'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Times.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

class Times {
  final String imsak;
  final String sunrise;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String midnight;

  Times({
    required this.imsak,
    required this.sunrise,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.midnight,
  });

  factory Times.fromJson(Map<String, dynamic> json) {
    return Times(
      imsak: json['results']['datetime'][0]['times']['Imsak'],
      sunrise: json['results']['datetime'][0]['times']['Sunrise'],
      fajr: json['results']['datetime'][0]['times']['Fajr'],
      dhuhr: json['results']['datetime'][0]['times']['Dhuhr'],
      asr: json['results']['datetime'][0]['times']['Asr'],
      sunset: json['results']['datetime'][0]['times']['Sunset'],
      maghrib: json['results']['datetime'][0]['times']['Maghrib'],
      isha: json['results']['datetime'][0]['times']['Isha'],
      midnight: json['results']['datetime'][0]['times']['Midnight'],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PrayTimes(),
  ));
}

class PrayTimes extends StatefulWidget {
  PrayTimes({Key? key}) : super(key: key);

  @override
  _PrayTimesState createState() => _PrayTimesState();
}

class _PrayTimesState extends State<PrayTimes> {
  late Future<Times> futureTimes;

  @override
  void initState() {
    super.initState();
    futureTimes = fetchTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pray Times'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Times>(
        future: futureTimes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text('Imsak'),
                          Text('Sunrise'),
                          Text('Fajr'),
                          Text('Dhuhr'),
                          Text('Asr'),
                          Text('Sunset'),
                          Text('Maghrib'),
                          Text('Isha'),
                          Text('Midnight'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(snapshot.data!.imsak),
                    Text(snapshot.data!.sunrise),
                    Text(snapshot.data!.fajr),
                    Text(snapshot.data!.dhuhr),
                    Text(snapshot.data!.asr),
                    Text(snapshot.data!.sunset),
                    Text(snapshot.data!.maghrib),
                    Text(snapshot.data!.isha),
                    Text(snapshot.data!.midnight),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
