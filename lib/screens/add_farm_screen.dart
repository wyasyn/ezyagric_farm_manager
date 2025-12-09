import 'package:flutter/material.dart';
import '../models/farmer.dart';
import '../models/farm.dart';
import '../services/farm_service.dart';

class AddFarmScreen extends StatefulWidget {
  final Farmer farmer;

  const AddFarmScreen({Key? key, required this.farmer}) : super(key: key);

  @override
  State<AddFarmScreen> createState() => _AddFarmScreenState();
}

class _AddFarmScreenState extends State<AddFarmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sizeController = TextEditingController();
  final FarmService _farmService = FarmService();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _saveFarm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final farm = Farm(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      farmerId: widget.farmer.id,
      name: _nameController.text.trim(),
      sizeAcres: double.parse(_sizeController.text.trim()),
    );

    await _farmService.addFarm(farm);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Farm added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Farm'),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.green),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Farmer:',
                            style: TextStyle(color: Colors.grey)),
                        Text(
                          widget.farmer.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Farm Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.agriculture),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter farm name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _sizeController,
              decoration: const InputDecoration(
                labelText: 'Size (Acres)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter farm size';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveFarm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Save Farm', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
