import 'package:flutter/material.dart';
import '../models/farm.dart';

class FarmCard extends StatelessWidget {
  final Farm farm;
  final VoidCallback onTap;

  const FarmCard({
    Key? key,
    required this.farm,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.agriculture, color: Colors.green, size: 32),
        title: Text(
          farm.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${farm.sizeAcres} acres'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
