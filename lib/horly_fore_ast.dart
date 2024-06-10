import 'package:flutter/material.dart';

class HorlyForeCast extends StatelessWidget {
  final int time;
  final IconData icon;
  final double temprature;
  const HorlyForeCast(
      {required this.icon,
      required this.temprature,
      required this.time,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        elevation: 20,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                ' ${time.toString()} : 00',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Icon(icon, size: 42),
              const SizedBox(height: 10),
              Text(
                '${temprature.toStringAsFixed(2)} °C',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
