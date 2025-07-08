import 'package:dio/dio.dart';
import '../utils/app_logger.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug('➡️ ${options.method} ${options.uri}');
    if (options.data != null) AppLogger.debug('Request Body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.info('✅ ${response.statusCode} ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('❌ ${err.type} ${err.message}');
    if (err.response != null) {
      AppLogger.error('Response Error: ${err.response?.statusCode} => ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}
