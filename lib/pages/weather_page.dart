import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app/pages/additional_information_page.dart';
import 'package:weather_app/pages/hourly_weather_forecast_page.dart';
import 'package:weather_app/pages/weather_api.dart';
import 'package:intl/intl.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() {
    return _WeatherPageState();
  }
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<Map<String, dynamic>> weather;
  late double temp;
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Chennai';
      final res = await http.get(
        Uri.parse(
            'http://api.openweathermap.org/data/2.5/forecast?q=$cityName,in&APPID=$secretKey'),
      );

      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
          )
        ],
      ),
      body: FutureBuilder(
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
          final currentWeather = data['list'][0];
          final currentTemp = currentWeather['main']['temp'];
          final currentSky = currentWeather['weather'][0]['main'];
          final currentPressure = currentWeather['main']['pressure'];
          final currentHumidity = currentWeather['main']['humidity'];
          final currentWindSpeed = currentWeather['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentSky == 'Clouds'
                                    ? Icons.cloud
                                    : (currentSky == 'Rain')
                                        ? Icons.cloudy_snowing
                                        : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 1; i <= 5; i++)
                //         HourlyWeatherForecast(
                //             icon: (data['list'][i]['weather'][0]['main']
                //                         .toString()) ==
                //                     'Cloud'
                //                 ? Icons.cloud
                //                 : (data['list'][i]['weather'][0]['main'] ==
                //                         'Rain')
                //                     ? Icons.cloudy_snowing
                //                     : Icons.sunny,
                //             time: data['list'][i]['dt_txt']
                //                 .toString()
                //                 .split(" ")[1],
                //             temperature:
                //                 data['list'][i]['main']['temp'].toString())
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 108,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final hourlyIcon = (data['list'][index + 1]['weather'][0]
                                      ['main']
                                  .toString()) ==
                              'Cloud'
                          ? Icons.cloud
                          : (data['list'][index + 1]['weather'][0]['main'] ==
                                  'Rain')
                              ? Icons.cloudy_snowing
                              : Icons.sunny;
                      final hourlyTime =
                          DateTime.parse(data['list'][index + 1]['dt_txt']);

                      final hourlyTemp =
                          data['list'][index + 1]['main']['temp'].toString();

                      return HourlyWeatherForecast(
                        icon: hourlyIcon,
                        temperature: hourlyTemp,
                        time: DateFormat.j().format(hourlyTime),
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformationCard(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      labelLevel: currentHumidity.toString(),
                    ),
                    AdditionalInformationCard(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      labelLevel: currentWindSpeed.toString(),
                    ),
                    AdditionalInformationCard(
                      icon: Icons.data_thresholding,
                      label: 'Pressure',
                      labelLevel: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
