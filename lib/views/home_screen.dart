import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/property_controller.dart';
import '../controllers/filter_controller.dart';
import '../core/utils/theme_controller.dart';
import 'property_card.dart';
import 'filter_sheet.dart';
import '../core/widgets/loading_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    final propertyCtl = context.read<PropertyController>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      propertyCtl.loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme           = Theme.of(context).colorScheme;
    final propertyCtl      = context.watch<PropertyController>();
    final filterCtl        = context.watch<FilterController>();
    final activeFilters    = filterCtl.filters;

    return Scaffold(
      backgroundColor: scheme.background,          // ← theme‑aware
      appBar: AppBar(
        title: const Text('Property Listings'),
        actions: [
          IconButton(
            tooltip: 'Refresh properties',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              propertyCtl.fetchProperties();
            },
          ),
          // Theme toggle
          IconButton(
            tooltip: 'Toggle light / dark',
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => context.read<ThemeController>().toggle(),
          ),

          // Active filter chip
          if (activeFilters.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: const Text('Filters Applied'),
                deleteIcon: const Icon(Icons.clear),
                onDeleted: () {
                  filterCtl.clear();
                  propertyCtl.refreshAll();
                },
              ),
            ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () => propertyCtl.fetchProperties(),
        child: Builder(
          builder: (_) {
            if (propertyCtl.loading && propertyCtl.properties.isEmpty) {
              // show animated “dream house” card instead of just a spinner
              return const LoadingCard();
            }

            if (propertyCtl.properties.isEmpty) {
              return const Center(child: Text('No properties found.'));
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: propertyCtl.properties.length +
                  (propertyCtl.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < propertyCtl.properties.length) {
                  final property = propertyCtl.properties[index];
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: PropertyCard(property: property),
                  );
                }
                // bottom loader
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: scheme.primary,           // ← theme‑aware
        child: const Icon(Icons.filter_alt),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (_) => const FilterSheet(),
          );
        },
      ),
    );
  }
}
