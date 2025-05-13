import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '/core/errors/exceptions.dart';
import '/data/data.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();
}

const String cachedAuthToken = 'CACHED_AUTH_TOKEN';
const String cachedUserData = 'CACHED_USER_DATA';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveToken(String token) async {
    try {
      await sharedPreferences.setString(cachedAuthToken, token);
    } catch (e) {
      throw CacheException(
        message: "Error al guardar el token: ${e.toString()}",
      );
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return sharedPreferences.getString(cachedAuthToken);
    } catch (e) {
      throw CacheException(
        message: "Error al obtener el token: ${e.toString()}",
      );
    }
  }

  @override
  Future<void> clearToken() async {
    try {
      await sharedPreferences.remove(cachedAuthToken);
    } catch (e) {
      throw CacheException(
        message: "Error al limpiar el token: ${e.toString()}",
      );
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await sharedPreferences.setString(
        cachedUserData,
        jsonEncode(user.toJson()),
      );
    } catch (e) {
      throw CacheException(
        message: "Error al guardar datos del usuario: ${e.toString()}",
      );
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final jsonString = sharedPreferences.getString(cachedUserData);
      if (jsonString != null) {
        return UserModel.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>,
        );
      }
      return null;
    } catch (e) {
      throw CacheException(
        message: "Error al obtener datos del usuario: ${e.toString()}",
      );
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await sharedPreferences.remove(cachedUserData);
    } catch (e) {
      throw CacheException(
        message: "Error al limpiar datos del usuario: ${e.toString()}",
      );
    }
  }
}
