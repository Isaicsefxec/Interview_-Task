import 'package:flutter/material.dart';
import '../models/filter_model.dart';

class FilterController extends ChangeNotifier {
  FilterModel _filters = const FilterModel();

  FilterModel get filters => _filters;

  void update({
    String? location,
    int? minPrice,
    int? maxPrice,
    String? status,
    List<String>? tags,
  }) {
    _filters = FilterModel(
      location: location ?? _filters.location,
      minPrice: minPrice ?? _filters.minPrice,
      maxPrice: maxPrice ?? _filters.maxPrice,
      status: status ?? _filters.status,
      tags: tags ?? _filters.tags,
    );
    notifyListeners();
  }

  void apply(FilterModel newFilters) {
    _filters = newFilters;
    notifyListeners();
  }

  void clear() {
    _filters = const FilterModel();
    notifyListeners();
  }

  bool get hasFilters => !_filters.isEmpty;
}
