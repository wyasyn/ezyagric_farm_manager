import 'package:flutter/material.dart';
import '../models/season_plan.dart';
import '../models/actual_activity.dart';
import '../models/activity_type.dart';
import '../services/season_service.dart';
import '../utils/date_formatter.dart';

class LogActualActivityScreen extends StatefulWidget {
  final SeasonPlan seasonPlan;

  const LogActualActivityScreen({Key? key, required this.seasonPlan})
      : super(key: key);

  @override
  State<LogActualActivityScreen> createState() =>
      _LogActualActivityScreenState();
}

class _LogActualActivityScreenState extends State<LogActualActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();
  final SeasonService _seasonService = SeasonService();

  ActivityType? _selectedActivityType;
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;

  @override
  void dispose() {
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedActivityType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an activity type')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final activity = ActualActivity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      seasonPlanId: widget.seasonPlan.id,
      activityType: _selectedActivityType!,
      actualDate: _selectedDate,
      actualCostUgx: double.parse(_costController.text.trim()),
      notes: _notesController.text.trim(),
    );

    await _seasonService.addActualActivity(activity);

    if (!mounted) return;

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Activity logged successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // TOP BAR (same style as CreateSeasonScreen)
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Log Actual Activity',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Section Title
              const Text(
                'Activity Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Provide the actual activity information and cost.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 24),

              // Activity Type
              _inputLabel("Activity Type*"),
              const SizedBox(height: 8),
              _styledDropdown<ActivityType>(
                value: _selectedActivityType,
                hint: "Select activity type",
                items: ActivityType.values
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(getActivityDisplayName(type)),
                        ))
                    .toList(),
                validator: (value) =>
                    value == null ? "Please select an activity type" : null,
                onChanged: (value) =>
                    setState(() => _selectedActivityType = value),
              ),

              const SizedBox(height: 20),

              // Date Picker
              _inputLabel("Actual Date*"),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: _styledBox(
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.grey, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        DateFormatter.formatDate(_selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Cost
              _inputLabel("Actual Cost (UGX)*"),
              const SizedBox(height: 8),
              _styledInput(
                controller: _costController,
                hint: "Enter cost",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Enter actual cost";
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return "Enter a valid number";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Notes
              _inputLabel("Notes (optional)"),
              const SizedBox(height: 8),
              _styledInput(
                controller: _notesController,
                hint: "Any observations or comments",
                validator: (_) => null,
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _isSaving ? null : _save,
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
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Log Activity',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable label
  Widget _inputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Styled input (same as CreateSeasonScreen)
  Widget _styledInput({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: Colors.green, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  // Styled dropdown
  Widget _styledDropdown<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required String hint,
    required Function(T?) onChanged,
    required String? Function(T?) validator,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  // Styled box for date
  Widget _styledBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
