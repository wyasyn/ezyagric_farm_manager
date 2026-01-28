import 'package:flutter/material.dart';

class ModernDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final String hint;
  final String? Function(String?) validator;
  final void Function(String) onChanged;

  const ModernDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.hint,
    required this.validator,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      builder: (state) {
        final isValid = value != null && state.errorText == null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label(label),
            const SizedBox(height: 8),
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final selected = await showModalBottomSheet<String>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => _DropdownSheet(
                    title: label,
                    items: items,
                    selected: value,
                  ),
                );

                if (selected != null) {
                  onChanged(selected);
                  state.didChange(selected);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: state.hasError
                        ? Colors.red
                        : isValid
                            ? Colors.green
                            : Colors.grey[300]!,
                    width: state.hasError ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value ?? hint,
                        style: TextStyle(
                          color:
                              value == null ? Colors.grey[400] : Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (isValid)
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 20)
                    else
                      const Icon(Icons.expand_more, color: Colors.grey),
                  ],
                ),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6, left: 4),
                child: Text(
                  state.errorText!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _DropdownSheet extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selected;

  const _DropdownSheet({
    required this.title,
    required this.items,
    required this.selected,
  });

  @override
  State<_DropdownSheet> createState() => _DropdownSheetState();
}

class _DropdownSheetState extends State<_DropdownSheet> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.items
        .where((e) => e.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (v) => setState(() => query = v),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final item = filtered[i];
                final selected = item == widget.selected;

                return ListTile(
                  title: Text(item),
                  trailing: selected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () => Navigator.pop(context, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
