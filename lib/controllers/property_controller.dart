import 'package:flutter/material.dart';
import '../models/property_model.dart';
import '../core/network/api_service.dart';
import 'filter_controller.dart';
import 'analytics_service.dart';
import '../core/utils/app_logger.dart'; // <-- Logger import

class PropertyController extends ChangeNotifier {
  final ApiService _apiService;
  final AnalyticsService _analyticsService;
  FilterController filterController;

  PropertyController({
    required this.filterController,
    required ApiService apiService,
    required AnalyticsService analyticsService,
  })  : _apiService = apiService,
        _analyticsService = analyticsService;

  List<PropertyModel> _properties = [];
  int _currentPage = 1;
  bool _loading = false;
  bool _hasMore = true;
  String? _lastError;

  // Public getters
  List<PropertyModel> get properties => List.unmodifiable(_properties);
  int get currentPage => _currentPage;
  bool get loading => _loading;
  bool get hasMore => _hasMore;
  String? get lastError => _lastError;

  /// Fetch Properties with Pagination and Filters
  Future<void> fetchProperties({bool loadMore = false}) async {
    if (_loading) return;

    _loading = true;
    _lastError = null;
    notifyListeners();

    try {
      if (!loadMore) {
        _currentPage = 1;
        _properties.clear();
      }

      final stopwatch = Stopwatch()..start();
      _analyticsService.logInteraction('fetch_properties_start');

      final rawList = await _apiService.fetchProperties(
        page: _currentPage,
        pageSize: 20,
        location: filterController.filters.location,
        minPrice: filterController.filters.minPrice,
        maxPrice: filterController.filters.maxPrice,
        status: filterController.filters.status,
        tags: filterController.filters.tags,
      );

      stopwatch.stop();
      _analyticsService.logInteraction('fetch_properties_success');
      _analyticsService.logTimeSpent(
        'fetch_properties_page_$_currentPage',
        stopwatch.elapsed,
      );

      AppLogger.debug('📦 Fetched ${rawList.length} properties');

      final items = await _parseProperties(rawList);
      AppLogger.debug('✅ Successfully parsed ${items.length} properties');

      if (loadMore) {
        _properties.addAll(items);
      } else {
        _properties = items;
      }

      _hasMore = items.length == 20;
      if (loadMore) _currentPage++;
    } catch (e) {
      _lastError = 'Failed to load properties: ${e.toString()}';
      AppLogger.error('❌ fetchProperties failed: $_lastError');
      _analyticsService.logInteraction('fetch_properties_failed');
      if (!loadMore) _properties = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Helper method to parse properties with error handling
  Future<List<PropertyModel>> _parseProperties(List<dynamic> rawList) async {
    final parsedProperties = <PropertyModel>[];
    int parseErrors = 0;

    for (final item in rawList) {
      try {
        final property = PropertyModel.fromJson(item);
        parsedProperties.add(property);
      } catch (e) {
        parseErrors++;
        AppLogger.error('❌ Failed to parse property: $e');
        _analyticsService.logInteraction('property_parse_error');
      }
    }

    if (parseErrors > 0) {
      _analyticsService.logInteraction('parse_errors_$parseErrors');
    }

    return parsedProperties;
  }

  /// Load next page if available
  Future<void> loadNextPage() async {
    if (!_loading && _hasMore) {
      _analyticsService.logInteraction('load_next_page');
      await fetchProperties(loadMore: true);
    }
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    _currentPage = 1;
    _hasMore = true;
    _analyticsService.logInteraction('refresh_all');
    await fetchProperties();
  }

  /// Update filter controller and refresh data
  Future<void> updateFilterController(FilterController newController) async {
    filterController = newController;
    _analyticsService.logInteraction('filters_updated');
    await refreshAll();
  }

  /// Log property view for analytics
  void logPropertyView(String propertyId) {
    _analyticsService.logView(propertyId);
    _analyticsService.logInteraction('view_property_$propertyId');
  }
}
