import 'package:flutter/material.dart';

class AdditionalInformationCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String labelLevel;
  const AdditionalInformationCard({
    super.key,
    required this.icon,
    required this.label,
    required this.labelLevel,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 35,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            labelLevel,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
