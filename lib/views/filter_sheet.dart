import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/filter_controller.dart';
import '../controllers/property_controller.dart';
import '../models/filter_model.dart';
import '../core/widgets/app_button.dart';
import '../core/widgets/app_text.dart';
import '../core/animations/animations.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final _locationController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();
  String? _status;
  List<String> _tags = [];

  final tagOptions = ['Furnished', 'New', 'Luxury', 'Available', 'Pet Friendly'];
  final statusOptions = ['Available', 'Sold', 'Upcoming'];

  @override
  void initState() {
    super.initState();
    final current = context.read<FilterController>().filters;
    _locationController.text = current.location ?? '';
    _minPriceController.text = current.minPrice?.toString() ?? '';
    _maxPriceController.text = current.maxPrice?.toString() ?? '';
    _status = current.status;
    _tags = [...current.tags];
  }

  @override
  void dispose() {
    _locationController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterCtl  = context.read<FilterController>();
    final propCtl    = context.read<PropertyController>();
    final scheme     = Theme.of(context).colorScheme;          // theme‑aware
    final isDark     = scheme.brightness == Brightness.dark;

    InputDecoration _decor({
      required String hint,
      IconData? icon,
      String? label,
    }) =>
        InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: scheme.surface,                           // adapts
          prefixIcon: icon != null
              ? Icon(icon, color: scheme.onSurface)
              : null,
          hintStyle:
          TextStyle(color: scheme.onSurface.withOpacity(0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: scheme.outline),
          ),
        );

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppAnimations.fadeSlideIn(
              child: Row(
                children: [
                  Icon(Icons.tune, color: scheme.primary),
                  const SizedBox(width: 10),
                  const AppText('Filter Properties',
                      size: 20, weight: FontWeight.bold),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /* ── Location ── */
            AppAnimations.slideInUp(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText('Location',
                      size: 14, weight: FontWeight.w600),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _locationController,
                    decoration: _decor(
                      hint: 'Enter city or area',
                      icon: Icons.location_on_outlined,
                    ),
                  ),
                ],
              ),
              durationMs: 300,
            ),
            const SizedBox(height: 20),

            /* ── Price Range ── */
            AppAnimations.slideInUp(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText('Price Range',
                      size: 14, weight: FontWeight.w600),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minPriceController,
                          keyboardType: TextInputType.number,
                          decoration: _decor(
                            hint: 'Min',
                            icon: Icons.attach_money,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _maxPriceController,
                          keyboardType: TextInputType.number,
                          decoration: _decor(
                            hint: 'Max',
                            icon: Icons.attach_money,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              durationMs: 350,
            ),
            const SizedBox(height: 20),

            /* ── Status ── */
            AppAnimations.slideInUp(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText('Status',
                      size: 14, weight: FontWeight.w600),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: _decor(
                      hint: 'Select status',
                      icon: Icons.check_circle_outline,
                    ),
                    items: statusOptions
                        .map((s) =>
                        DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) => setState(() => _status = val),
                  ),
                ],
              ),
              durationMs: 400,
            ),
            const SizedBox(height: 20),

            /* ── Tags ── */
            AppAnimations.fadeIn(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText('Tags',
                      size: 14, weight: FontWeight.w600),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: tagOptions.map((tag) {
                      final selected = _tags.contains(tag);
                      return FilterChip(
                        label: AppText(tag,
                            size: 12,
                            color: selected
                                ? scheme.onPrimary
                                : scheme.onSurface),
                        selected: selected,
                        backgroundColor: scheme.surfaceVariant,
                        selectedColor:
                        scheme.primary.withOpacity(isDark ? 0.3 : 0.2),
                        onSelected: (_) {
                          setState(() {
                            selected ? _tags.remove(tag) : _tags.add(tag);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              durationMs: 450,
            ),
            const SizedBox(height: 32),

            /* ── Buttons ── */
            AppAnimations.zoomIn(
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        filterCtl.clear();
                        propCtl.refreshAll();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Clear'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: scheme.primary,
                        side: BorderSide(color: scheme.primary),
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: 'Apply Filters',
                      onPressed: () {
                        final newFilters = FilterModel(
                          location: _locationController.text.trim().isEmpty
                              ? null
                              : _locationController.text.trim(),
                          minPrice: int.tryParse(
                              _minPriceController.text.trim()),
                          maxPrice: int.tryParse(
                              _maxPriceController.text.trim()),
                          status: _status,
                          tags: _tags,
                        );
                        filterCtl.apply(newFilters);
                        propCtl.refreshAll();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              durationMs: 500,
            ),
          ],
        ),
      ),
    );
  }
}
