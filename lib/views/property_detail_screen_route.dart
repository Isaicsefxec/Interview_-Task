import 'package:flutter/material.dart';
import '../core/network/api_service.dart';
import '../models/property_model.dart';
import 'property_detail_screen.dart';
class PropertyDetailScreenRoute extends StatefulWidget {
  final String id;

  const PropertyDetailScreenRoute({super.key, required this.id});

  @override
  State<PropertyDetailScreenRoute> createState() => _PropertyDetailScreenRouteState();
}

class _PropertyDetailScreenRouteState extends State<PropertyDetailScreenRoute> {
  PropertyModel? property;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadProperty();
  }

  Future<void> _loadProperty() async {
    try {
      final api = ApiService();
      // Try to fetch single property first
      final propertyData = await _tryFetchSingleProperty(api);

      if (propertyData != null) {
        if (!mounted) return;
        setState(() {
          property = propertyData;
          isLoading = false;
        });
        return;
      }

      // Fallback to fetching all properties
      final properties = await _fetchAllProperties(api);
      final foundProperty = properties.firstWhere(
            (p) => p.id == widget.id,
        orElse: () => PropertyModel.empty(),
      );

      if (!mounted) return;
      setState(() {
        property = foundProperty.id.isNotEmpty ? foundProperty : null;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading property: $e');
      if (!mounted) return;
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<PropertyModel?> _tryFetchSingleProperty(ApiService api) async {
    try {
      final data = await api.fetchPropertyById(widget.id);
      return PropertyModel.fromJson(data);
    } catch (e) {
      debugPrint('Single property fetch failed, falling back to all properties');
      return null;
    }
  }

  Future<List<PropertyModel>> _fetchAllProperties(ApiService api) async {
    final rawList = await api.fetchProperties();
    return rawList.map((e) => PropertyModel.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading property details...'),
            ],
          ),
        ),
      );
    }

    if (hasError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text('Failed to load property'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProperty,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (property == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(
          child: Text('Property not found'),
        ),
      );
    }

    return PropertyDetailScreen(property: property!);
  }
}