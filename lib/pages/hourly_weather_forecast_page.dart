import 'package:flutter/material.dart';

class HourlyWeatherForecast extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;
  const HourlyWeatherForecast({
    super.key,
    required this.icon,
    required this.temperature,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 108,
      child: Card(
        elevation: 6,
        child: Container(
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(temperature,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ))
                ],
              ),
            )),
      ),
    );
  }
}
