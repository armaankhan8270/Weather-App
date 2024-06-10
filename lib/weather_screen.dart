// ignore_for_file: unnecessary_string_interpolations

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/addional_information.dart';
import 'package:weather_app/horly_fore_ast.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  TextEditingController textEditingController = TextEditingController();
  String enteredText = 'mumbai';

  double tempCurrent = 0;
  double temp = 0;
  double temp1 = 0;
  double temp2 = 0;
  double temp3 = 0;
  double temp4 = 0;
  double temp5 = 0;
  double wind = 0;
  String time = '';
  double humedity = 0;
  double pressure = 0;
  String sky = 'sky';

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather(enteredText);
  }

  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    try {
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=653ff8da59fad982f84d5c74cfac9240'));
      final data = jsonDecode(res.body);
      tempCurrent = (data['list'][1]['main']['temp'] - 273.15);

      final currentData = data['list'][0];
      if (int.parse(data['cod']) != 200) {
        throw 'an error occurred';
      }
      setState(() {
        temp = ((currentData['main']['temp']) - 32) * 0.555;
        temp1 = (data['list'][1]['main']['temp']);
        temp2 = (data['list'][2]['main']['temp']);
        temp3 = (data['list'][3]['main']['temp']);
        temp4 = (data['list'][4]['main']['temp']);
        temp5 = (data['list'][5]['main']['temp']);
        sky = (currentData['weather'][0]['main']);
        wind = (currentData['wind']['speed']);
        humedity = (currentData['main']['humidity']);
        pressure = (currentData['main']['pressure']);
      });
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather(enteredText);
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            final data = snapshot.data!;

            final currentData = data['list'][0];
            final hourlyTemp = currentData['main']['temp'].toString();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              '${tempCurrent.toStringAsFixed(2)} °C',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              sky == 'Clouds' || sky == "Rain"
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 64,
                            ),
                            Text('$sky', style: const TextStyle(fontSize: 22)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Weather Forecast",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i <= 5; i++)
                          HorlyForeCast(
                            icon: data['list'][i + 1]['weather'][0]['main'] ==
                                        'Clouds' ||
                                    data['list'][i + 1]['weather'][0]['main'] ==
                                        'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            temprature:
                                data['list'][i]['main']['temp'] - 273.15,
                            time: i * 3,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        additional_information(
                          icon: Icons.water_drop,
                          label: 'Humidity',
                          value: "$humedity",
                        ),
                        additional_information(
                          icon: Icons.speed,
                          label: 'Wind Speed',
                          value: "$wind",
                        ),
                        additional_information(
                          icon: Icons.umbrella,
                          label: 'Pressure',
                          value: "$pressure",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Container(
                      width: 300,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: TextField(
                                controller: textEditingController,
                                decoration: const InputDecoration(
                                  hintText: 'City........',
                                  hintStyle: TextStyle(color: Colors.black),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search,
                                size: 32, color: Colors.black),
                            onPressed: () {
                              setState(() {
                                enteredText = textEditingController.text;
                                weather = getCurrentWeather(enteredText);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
