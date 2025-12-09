import 'package:flutter/material.dart';
import '../models/farmer.dart';

class FarmerCard extends StatelessWidget {
  final Farmer farmer;
  final VoidCallback onTap;

  const FarmerCard({
    Key? key,
    required this.farmer,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Text(
            farmer.name[0].toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          farmer.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(farmer.phoneNumber),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
