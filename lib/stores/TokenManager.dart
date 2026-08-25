import 'package:hm_shop/constants/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  // 初始化token
  // 返回持久化对象的单例
  Future<SharedPreferences> _getInstance() {
    return SharedPreferences.getInstance();
  }

  String _token = "";

  Future<void> init() async {
    // 获取持久化实例
    final prefs = await _getInstance();
    // 获取token
    _token = prefs.getString(GlobalConstants.TOKEN_KEY) ?? "";
  }

  // 设置token
  Future<void> setToken(String val) async {
    // 获取持久化实例
    final prefs = await _getInstance();
    // token写入持久化磁盘
    prefs.setString(GlobalConstants.TOKEN_KEY, val);
    _token = val;
  }

  // 获取token
  String getToken() {
    return _token;
  }

  // 删除token
  Future<void> removeToken() async {
    // 获取持久化实例
    final prefs = await _getInstance();
    // 获取token
    prefs.remove(GlobalConstants.TOKEN_KEY);
    _token = "";
  }
}

final tokenManager = TokenManager();
