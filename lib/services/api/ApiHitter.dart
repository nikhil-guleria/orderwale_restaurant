import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ApiEndPoint.dart';
import 'LoggingInterceptor.dart';

class ApiHitter {
  static Dio? _dio;
  static Dio? _dioRaw;
  static CancelToken _cancelToken = CancelToken();
  final GlobalKey key = GlobalKey();

  String errorNoInternet = 'Please check your internet connection';

  static Dio getDio() {
    if (_dio == null) {
      _dio = Dio();
      _cancelToken = CancelToken();
      BaseOptions options = BaseOptions(
          baseUrl: ApiEndpoint.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30));
      _dio!.options = options;
      return _dio!
        ..interceptors.add(LoggingInterceptor());
    } else {
      return _dio!;
    }
  }

  static Dio getDioRaw(){
    if (_dioRaw == null) {
      _dioRaw = Dio();
      _cancelToken = CancelToken();
      BaseOptions options = BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30));
      _dioRaw!.options = options;
      return _dioRaw!
        ..interceptors.add(LoggingInterceptor());
    } else {
      return _dioRaw!;
    }
  }

  Future<ApiResponse> getApiResponse(String endPoint,
      {Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParams}) async {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      try {
        Response response = await getDio().get(endPoint,
            options: Options(headers: headers), queryParameters: queryParams);
        if (response.statusCode == 200) {
          if (response.data["status"] == 200 &&
              response.data["message"] == null) {
            return ApiResponse(true, response.data["status"],
                response: response, msg: '');
          } else {
            return ApiResponse(true, response.data["status"],
                response: response, msg: response.data["message"]);
          }
        } else {
          return ApiResponse(false, response.statusCode!,
              response: response, msg: response.data["message"]);
        }
      } catch (error) {
        return ApiResponse(false, error.hashCode,
            msg: error.hashCode.toString());
      }
    } else {
      return ApiResponse(false, 301, msg: errorNoInternet);
    }
  }

  getApiRawResponse(String endPoint,
      {Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParams}) async {
    var response;
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await getDio().get(endPoint,
            options: Options(headers: headers), queryParameters: queryParams);
        if (response.statusCode == 200) {
          return ApiResponse(true, response.data["code"],
              response: response, msg: response.data["message"]);
        }
        else {
          return ApiResponse(false, response.statusCode!,
              response: response, msg: response.data["message"]);
        }
      }
      else {
        return ApiResponse(false, 301, msg: errorNoInternet);
      }
    }
    catch (error) {
      try {
        response = error;
        return ApiResponse(false, response.response!.statusCode!,
            msg: response.response.data['body']);
      } catch (e) {
        return ApiResponse(false, 400, msg: 'Something went wrong..');
      }
    }
  }



  Future<ApiResponse> getPostApiResponse(String endPoint,
      {Map<String, dynamic>? headers,
        Map<String, dynamic>? data,
        FormData? formData,
        bool isFormData = false}) async {
    var body;
    var response;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await getDio().post(endPoint,
            options: Options(headers: headers),
            data: isFormData ? formData : data,
            onSendProgress: (int sent, int total) {});
        if (response.statusCode == 200) {
          if(response.data is String) {
            body = json.decode(response.data);
          } else {
            body = response.data;
          }
          return ApiResponse(true, body["code"] ?? 200, response: response, msg: body["message"]);
        } else {
          return ApiResponse(false, response.statusCode!,
              response: response, msg: response.data["message"]);
        }
      } else {
        return ApiResponse(false, 301, msg: errorNoInternet);
      }
    } catch (error) {
      try {
        response = error;
        return ApiResponse(false, response.response!.statusCode!,
            msg: response.response.data['body']);
      } catch (e) {
        return ApiResponse(false, 400, msg: 'Something went wrong..');
      }
    }
  }

  Future<ApiResponse> getPostApiJson(String endPoint,
      {Map<String, dynamic>? headers,
        String? data,
        FormData? formData,
        bool isFormData = false}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await getDio().post(endPoint,
            options: Options(headers: headers),
            data: isFormData ? formData : data,
            onSendProgress: (int sent, int total) {});
        if (response.statusCode == 200) {
          return ApiResponse(true, response.data["code"],
              response: response, msg: response.data["message"]);
        } else {
          return ApiResponse(false, response.statusCode!,
              response: response, msg: response.data["message"]);
        }
      } else {
        return ApiResponse(false, 301, msg: errorNoInternet);
      }
    } catch (error) {
      return ApiResponse(false, error.hashCode, msg: error.hashCode.toString());
    }
  }

  Future<ApiResponse> postApiWithQueryParam(String endPoint,
      {Map<String, dynamic>? headers,
        Map<String, dynamic>? data,
        FormData? formData,
        Map<String, dynamic>? queryParam,
        bool isFormData = false}) async {
    var response;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await getDio().put(endPoint,
            options: Options(headers: headers),
            data: isFormData ? formData : data,
            queryParameters: queryParam,
            onSendProgress: (int sent, int total) {});
        if (response.statusCode == 200) {
          return ApiResponse(true, response.data["code"],
              response: response, msg: response.data["message"]);
        } else {
          return ApiResponse(false, response.statusCode!,
              response: response, msg: response.data["message"]);
        }
      } else {
        return ApiResponse(false, 301, msg: errorNoInternet);
      }
    } catch (error) {
      try {
        response = error;
        return ApiResponse(false, response.response!.statusCode!,
            msg: response.response.data['body']);
      } catch (e) {
        return ApiResponse(false, 400, msg: 'Something went wrong..');
      }
    }
  }

  Future<ApiResponse> getPutApiJson(String endPoint,
      {Map<String, dynamic>? headers,
        String? data,
        FormData? formData,
        bool isFormData = false}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await getDio().put(endPoint,
            options: Options(headers: headers),
            data: isFormData ? formData : data,
            onSendProgress: (int sent, int total) {});
        if (response.statusCode == 200) {
          return ApiResponse(true, response.data["code"],
              response: response, msg: response.data["message"]);
        } else {
          return ApiResponse(false, response.statusCode!,
              response: response, msg: response.data["message"]);
        }
      } else {
        return ApiResponse(false, 301, msg: errorNoInternet);
      }
    } catch (error) {
      return ApiResponse(false, error.hashCode, msg: error.hashCode.toString());
    }
  }

  Future<ApiResponse> getDeleteApi(String endPoint,
      {Map<String, dynamic>? headers,
        Map<String, dynamic>? data,
        FormData? formData,
        bool isFormData = false}) async {
    var response;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        response = await getDio().delete(endPoint,
            options: Options(headers: headers),
            data: isFormData ? formData : data);
        if (response.statusCode == 200) {
          return ApiResponse(
              true, response.data["code"] != null ? response.data["code"] : 200,
              response: response, msg: response.data["message"]);
        } else {
          return ApiResponse(false, response.statusCode!,
              response: response, msg: response.data["message"]);
        }
      } else {
        return ApiResponse(false, 301, msg: errorNoInternet);
      }
    } catch (error) {
      try {
        response = error;
        return ApiResponse(false, response.response!.statusCode!,
            msg: response.response.data['body']);
      } catch (e) {
        return ApiResponse(false, 400, msg: 'Something went wrong..');
      }
    }
  }

  Future<ApiResponse> getPatchApiJson(String endPoint,
      {Map<String, dynamic>? headers,
        String? data,
        FormData? formData,
        bool isFormData = false}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await getDio().patch(endPoint,
            options: Options(headers: headers),
            data: isFormData ? formData : data,
            onSendProgress: (int sent, int total) {});
        if (response.statusCode == 200) {
          return ApiResponse(true, response.data["code"],
              response: response, msg: response.data["message"]);
        } else {
          return ApiResponse(false, response.statusCode!,
              response: response, msg: response.data["message"]);
        }
      } else {
        return ApiResponse(false, 301, msg: errorNoInternet);
      }
    } catch (error) {
      return ApiResponse(false, error.hashCode, msg: error.hashCode.toString());
    }
  }

  void cancelRequests({CancelToken? cancelToken}) {
    cancelToken == null
        ? _cancelToken.cancel('Cancelled')
        : cancelToken.cancel();
  }





  Future<ApiResponse> getApiRawResponses(String url,
      {Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParams}) async {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      try {
        Response response = await getDio().get(url,
            options: Options(headers: headers), queryParameters: queryParams);
        if (response.statusCode == 200) {
          if (response.data["status"] == 'OK' ) {
            return ApiResponse(true, response.statusCode!,
                response: response, msg: '');
          } else {
            return ApiResponse(true, response.statusCode!,
                response: response, msg: '');
          }
        } else {
          return ApiResponse(false, response.statusCode!,
              response: response, msg:'');
        }
      } catch (error) {
        return ApiResponse(false, error.hashCode,
            msg: error.hashCode.toString());
      }
    } else {
      return ApiResponse(false, 301, msg: errorNoInternet);
    }
  }

}

class ApiResponse {
  final bool status;
  final int responseCode;
  final String msg;
  final Response? response;

  ApiResponse(this.status, this.responseCode,
      {this.msg = "Success", this.response});
}
