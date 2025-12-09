import 'package:flutter/material.dart';
import '../models/farmer.dart';
import '../services/farmer_service.dart';
import '../widgets/farmer_card.dart';
import 'add_farmer_screen.dart';
import 'farmer_detail_screen.dart';

class FarmersListScreen extends StatefulWidget {
  const FarmersListScreen({Key? key}) : super(key: key);

  @override
  State<FarmersListScreen> createState() => _FarmersListScreenState();
}

class _FarmersListScreenState extends State<FarmersListScreen> {
  final FarmerService _farmerService = FarmerService();
  List<Farmer> _farmers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFarmers();
  }

  Future<void> _loadFarmers() async {
    setState(() => _isLoading = true);
    final farmers = await _farmerService.getAllFarmers();
    setState(() {
      _farmers = farmers;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _farmers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline,
                          size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No farmers registered yet',
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap + to add your first farmer',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _farmers.length,
                  itemBuilder: (context, index) {
                    final farmer = _farmers[index];
                    return FarmerCard(
                      farmer: farmer,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FarmerDetailScreen(farmer: farmer),
                          ),
                        );
                        _loadFarmers();
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFarmerScreen()),
          );
          _loadFarmers();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
