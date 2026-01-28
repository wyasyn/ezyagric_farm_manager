import 'package:ezyagric_farm_manager/widgets/modern_dropdown.dart';
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
  final _locationController = TextEditingController();
  final _mainCropController = TextEditingController();
  final _contactPersonController = TextEditingController();

  String? _selectedRegion;
  String? _selectedDistrict;

  bool _isSaving = false;
  final FarmService _farmService = FarmService();

  @override
  void dispose() {
    _nameController.dispose();
    _sizeController.dispose();
    _locationController.dispose();
    _mainCropController.dispose();
    _contactPersonController.dispose();
    super.dispose();
  }

  Future<void> _saveFarm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final farm = Farm(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        farmerId: widget.farmer.id,
        name: _nameController.text.trim(),
        sizeAcres: double.parse(_sizeController.text),
        region: _selectedRegion!,
        district: _selectedDistrict!,
        location: _locationController.text.trim(),
        mainCrop: _mainCropController.text.trim(),
        contactPerson: _contactPersonController.text.trim(),
      );

      await _farmService.addFarm(farm);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Farm added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final districts = _selectedRegion == null
        ? <String>[]
        : Farm.getDistrictsForRegion(_selectedRegion!);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
            children: [
              _topBar(),
              const SizedBox(height: 32),
              const Text(
                'Farm Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Provide details about the farm.',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              _inputLabel('Farm name*'),
              const SizedBox(height: 8),
              _textField(
                controller: _nameController,
                hint: 'e.g. Green Valley Farm',
                validator: (v) => Farm.validateTextField(v, 'Farm name'),
              ),
              const SizedBox(height: 20),
              _inputLabel('Size (Acres)*'),
              const SizedBox(height: 8),
              _numberField(
                controller: _sizeController,
                hint: 'e.g. 5.5',
              ),
              const SizedBox(height: 20),
              ModernDropdown(
                label: 'Region*',
                hint: 'Select region',
                value: _selectedRegion,
                items: Farm.getRegions(),
                validator: (v) => Farm.validateDropdown(v, 'Region'),
                onChanged: (v) {
                  setState(() {
                    _selectedRegion = v;
                    _selectedDistrict = null;
                  });
                },
              ),
              const SizedBox(height: 20),
              ModernDropdown(
                label: 'District*',
                hint: 'Select district',
                value: _selectedDistrict,
                items: districts,
                validator: (v) => Farm.validateDropdown(v, 'District'),
                onChanged: (v) => setState(() => _selectedDistrict = v),
              ),
              const SizedBox(height: 20),
              _inputLabel('Location*'),
              const SizedBox(height: 8),
              _textField(
                controller: _locationController,
                hint: 'Village / Parish',
                validator: (v) => Farm.validateTextField(v, 'Location'),
              ),
              const SizedBox(height: 20),
              _inputLabel('Main crop*'),
              const SizedBox(height: 8),
              _textField(
                controller: _mainCropController,
                hint: 'e.g. Maize',
                validator: (v) => Farm.validateTextField(v, 'Main crop'),
              ),
              const SizedBox(height: 20),
              _inputLabel('Contact person*'),
              const SizedBox(height: 8),
              _textField(
                controller: _contactPersonController,
                hint: 'e.g. Farm Manager',
                validator: (v) => Farm.validateTextField(v, 'Contact person'),
              ),
            ],
          ),
        ),
      ),

      /// BOTTOM BUTTON
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveFarm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Continue',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// UI helpers

  Widget _topBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(width: 16),
        const Text(
          'Add Farm',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _inputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
  }) {
    final isValid =
        controller.text.isNotEmpty && validator(controller.text) == null;

    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: (_) => setState(() {}),
      decoration: _inputDecoration(hint: hint, isValid: isValid),
    );
  }

  Widget _numberField({
    required TextEditingController controller,
    required String hint,
  }) {
    final isValid = controller.text.isNotEmpty &&
        Farm.validateSizeField(controller.text) == null;

    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: Farm.validateSizeField,
      onChanged: (_) => setState(() {}),
      decoration: _inputDecoration(hint: hint, isValid: isValid),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required bool isValid,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.white,
      suffixIcon:
          isValid ? const Icon(Icons.check_circle, color: Colors.green) : null,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.green, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
