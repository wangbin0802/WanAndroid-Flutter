import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:wanandroid_flutter/http/api.dart';

class HttpClient {
  static const String GET = "GET";
  static const String POST = "POST";
  Dio dio;

  /// 定义私有变量
  static HttpClient _client;

  HttpClient() {
    dio = new Dio();
    dio.options.baseUrl = Api.BASE_URL;
    dio.options.connectTimeout = 10 * 1000;
    dio.options.sendTimeout = 10 * 1000;
    dio.options.receiveTimeout = 10 * 1000;
  }

  static HttpClient getInstance() {
    if (_client == null) {
      _client = new HttpClient();
    }
    return _client;
  }

  ///  GET 请求
  void get(String path,
      {Map<String, dynamic> data,
      Function callback,
      Function errorCallback}) async {
    _request(path, GET, callback, data: data, errorCallback: errorCallback);
  }

  /// POST 请求
  void post(String path,
      {Map<String, String> data,
      Function callback,
      Function errorCallback}) async {
    _request(path, POST, callback, errorCallback: errorCallback);
  }

  /// 私有方法，只可本类访问
  void _request(String path, String method, Function callback,
      {Map<String, dynamic> data, Function errorCallback}) async {
    data = data ?? {};
    method = method ?? GET;
    data.forEach((key, value) {
      if (path.indexOf(key) != -1) {
        path = path.replaceAll(":$key", value.toString());
      }
    });
    print("url = ${Api.BASE_URL + path}");
    try {
      Response response =
          await dio.request(path, data: data, options: Options(method: method));
      if (response?.statusCode != 200) {
        _handleErrorCallback(errorCallback, "网络连接异常");
        return;
      }
      var jsonString = json.encode(response.data);
      // map中的泛型为 dynamic
      Map<String, dynamic> dataMap = json.decode(jsonString);
      if (dataMap != null) {
        int errorCode = dataMap['errorCode'];
        String errorMsg = dataMap['errorMsg'];
        bool error = dataMap['error'];
        var results = dataMap['results'];
        var data = dataMap['data'];
        if (errorCode == 0) {
          if (callback != null) {
            callback(data);
            return;
          }
        }
        if (!error) {
          if (callback != null) {
            callback(results);
            return;
          }
        }
      } else {
        _handleErrorCallback(errorCallback, "数据解析失败");
      }
    } on DioError catch (e) {
      // 请求错误
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
    }
  }

  void _handleErrorCallback(Function errorCallback, String errorMsg) {
//    Fluttertoast.showToast(
//        msg: errorMsg,
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.CENTER);
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
  }
}
