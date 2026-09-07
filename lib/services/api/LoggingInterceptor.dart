import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      if (options.method == 'POST') {
        print(
            'REQUEST[${options.method}] => PATH: ${options
                .path} => DATA: ${options.data.toString()} => HEADER: ${options
                .headers}');
      } else if (options.method == 'PATCH') {
        print(
            'REQUEST[${options.method}] => PATH: ${options
                .path} => DATA: ${options.data.toString()} => HEADER: ${options
                .headers}');
      } else if (options.method == 'PUT') {
        print(
            'REQUEST[${options.method}] => PATH: ${options
                .path} => DATA: ${options.data.toString()} => HEADER: ${options
                .headers}');
      } else if (options.method == 'DELETE') {
        print(
            'REQUEST[${options.method}] => PATH: ${options
                .path} => DATA: ${options.data.toString()} => HEADER: ${options
                .headers}');
      } else {
        print(
            'REQUEST[${options.method}] => PATH: ${options
                .path} => QUERY: ${options
                .queryParameters}  => HEADER: ${options.headers}');
      }
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions
            .path} => DATA: ${response.data}',
      );
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions
            .path}=> DATA: ${err.error}',
      );
    }
    return super.onError(err, handler);
  }
}
