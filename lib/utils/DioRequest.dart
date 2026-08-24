// 基于Dio进行二次封装
import 'package:dio/dio.dart';
import 'package:hm_shop/constants/index.dart';

class DioRequest {
  final _dio = Dio();

  // 基础地址和拦截器
  DioRequest() {
    _dio.options
      ..baseUrl = GlobalConstants.BASE_URL
      ..connectTimeout = Duration(seconds: GlobalConstants.TIME_OUT)
      ..sendTimeout = Duration(seconds: GlobalConstants.TIME_OUT)
      ..receiveTimeout = Duration(seconds: GlobalConstants.TIME_OUT);
    _addInterceptor();
  }

  void _addInterceptor() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handle) {
          handle.next(request);
        },
        onResponse: (response, handle) {
          if (response.statusCode! >= 200 && response.statusCode! < 300) {
            handle.next(response);
            return;
          }
          handle.reject(DioException(requestOptions: response.requestOptions));
        },
        onError: (error, handle) {
          handle.reject(error);
        },
      ),
    );
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? params}) {
    return _handleResquest(_dio.get(url, queryParameters: params));
  }

  // 进一步处理返回结果
  Future<dynamic> _handleResquest(Future<Response<dynamic>> task) async {
    try {
      Response<dynamic> res = await task;
      final data = res.data as Map<String, dynamic>; // res.data才是返回响应真正的数据
      print(
        "realUri：${res.realUri}，\n"
        "statusCode：${res.statusCode}，\n"
        "statusMessage：${res.statusMessage}，\n"
        "data：${res.data}",
      );
      if (data["code"] == GlobalConstants.SUCCESS_CODE) {
        return data["result"];
      }
      throw Exception(data["msg"]);
    } catch (e) {
      throw Exception(e);
    }
  }
}

// 单例对象
final dioRequest = DioRequest();
