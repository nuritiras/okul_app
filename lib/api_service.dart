import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ogrenci_model.dart';

class ApiService {
  // DİKKAT: Android Emülatör kullanıyorsanız "10.0.2.2" yazın.
  // Chrome (Web) veya iOS Simulator kullanıyorsanız "127.0.0.1" yazın.
  static const String baseUrl = "http://127.0.0.1:8000/api/ogrenciler/";

  Future<List<Ogrenci>> fetchOgrenciler() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((data) => Ogrenci.fromJson(data)).toList();
    } else {
      throw Exception('Veriler alınamadı');
    }
  }

  Future<bool> ogrenciEkle(Ogrenci ogrenci) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(ogrenci.toJson()),
    );
    return response.statusCode == 201;
  }

  Future<bool> ogrenciGuncelle(int id, Ogrenci ogrenci) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(ogrenci.toJson()),
    );
    return response.statusCode == 200;
  }

  Future<bool> ogrenciSil(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl$id/'));
    return response.statusCode == 204;
  }
}