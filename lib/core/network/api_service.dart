import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_endpoints.dart';
import 'network_exceptions.dart';
import '../utils/app_logger.dart'; // <-- import your logger

class ApiService {
  final ApiClient _client = ApiClient();

  Future<List<dynamic>> fetchProperties({
    int page = 1,
    int pageSize = 20,
    int? minPrice,
    int? maxPrice,
    String? location,
    List<String>? tags,
    String? status,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'page_size': pageSize,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (location != null) 'location': location,
        if (tags != null && tags.isNotEmpty) 'tags': tags,
        if (status != null) 'status': status,
      };

      final response = await _client.dio.get(
        ApiEndpoints.properties,
        queryParameters: queryParams,
      );

      // 📦 Log the full response
      AppLogger.debug('📦 API Response: ${response.data}');

      final data = response.data;

      if (data is Map<String, dynamic> && data['properties'] is List) {
        return data['properties'] as List;
      }

      return <dynamic>[]; // fallback

    } on DioException catch (e) {
      AppLogger.error('❌ DioException: ${e.message}');
      throw NetworkException.fromDioError(e);
    }
  }

  Future<Map<String, dynamic>> fetchPropertyById(String id) async {
    try {
      final response = await _client.dio.get(
        '${ApiEndpoints.properties}/$id',
      );

      AppLogger.debug('📦 Single Property Response: ${response.data}');

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      }

      throw const FormatException('Invalid property data format');
    } on DioException catch (e) {
      AppLogger.error('❌ DioException (Single): ${e.message}');
      throw NetworkException.fromDioError(e);
    }
  }
}
