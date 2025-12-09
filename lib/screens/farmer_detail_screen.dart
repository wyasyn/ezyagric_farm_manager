import 'package:flutter/material.dart';
import '../models/farmer.dart';
import '../models/farm.dart';
import '../services/farm_service.dart';
import '../widgets/farm_card.dart';
import 'add_farm_screen.dart';
import 'farm_detail_screen.dart';

class FarmerDetailScreen extends StatefulWidget {
  final Farmer farmer;

  const FarmerDetailScreen({Key? key, required this.farmer}) : super(key: key);

  @override
  State<FarmerDetailScreen> createState() => _FarmerDetailScreenState();
}

class _FarmerDetailScreenState extends State<FarmerDetailScreen> {
  final FarmService _farmService = FarmService();
  List<Farm> _farms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFarms();
  }

  Future<void> _loadFarms() async {
    setState(() => _isLoading = true);
    final farms = await _farmService.getFarmsByFarmerId(widget.farmer.id);
    setState(() {
      _farms = farms;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.farmer.name),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: Colors.green.shade50,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green,
                  child: Text(
                    widget.farmer.name[0].toUpperCase(),
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.farmer.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      widget.farmer.phoneNumber,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.agriculture, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  'Farms (${_farms.length})',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _farms.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.agriculture,
                                size: 80, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'No farms added yet',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Tap + to add a farm',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _farms.length,
                        itemBuilder: (context, index) {
                          final farm = _farms[index];
                          return FarmCard(
                            farm: farm,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FarmDetailScreen(farm: farm),
                                ),
                              );
                              _loadFarms();
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFarmScreen(farmer: widget.farmer),
            ),
          );
          _loadFarms();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
