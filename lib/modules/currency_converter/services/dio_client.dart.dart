import 'dart:developer';

import 'package:dio/dio.dart';

// https://docs.awesomeapi.com.br/api-de-moedas
// GET  https://economia.awesomeapi.com.br/json/last/:moedas
class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    log('======= DIO INICIADO');
    _dio
      ..options.baseUrl = 'https://economia.awesomeapi.com.br/'
      ..options.headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
      ..options.connectTimeout = Duration(seconds: 5)
      ..options.receiveTimeout = Duration(seconds: 3);
  }

  Future<Response> getReq(String coin) async {
    try {
      final response = await _dio.get('json/last/$coin');
      if (response.statusCode == 200) {
        log('SUCESSO: ${response.data}');
        return response;
      } else {
        throw Exception(
            'Erro ao realizar a requisição: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      log('ERRO: ${e.message} - ${e.response?.data ?? ''}');
      throw Exception('Erro ao realizar a requisição');
    }
  }
}
