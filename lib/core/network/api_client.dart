import 'package:dio/dio.dart';
import 'dio_interceptor.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(
      baseUrl: 'http://147.182.207.192:8003',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ));

    dio.interceptors.add(DioInterceptor());
  }
}
