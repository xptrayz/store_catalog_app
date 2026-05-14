import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../utils/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Simpan token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Ambil token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Hapus token (logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // LOGIN - Sesuai contoh di PDF
  // LOGIN
  Future<Map<String, dynamic>> login(String nim, String password) async {
    final url = Uri.parse('${Constants.BASE_URL}/api/auth/login');

    // DEBUG: Print URL yang terbentuk
    print('🔍 URL Login: $url');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'username': nim, 'password': password}),
    );

    // DEBUG: Print response
    print('🔍 Status Code: ${response.statusCode}');
    print('🔍 Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['data']['token'];
      await saveToken(token);
      return {'success': true, 'token': token, 'message': 'Login berhasil!'};
    } else {
      throw Exception('Login gagal: ${response.body}');
    }
  }

  // GET PRODUCTS (Draft) - Menggunakan Class Model
  Future<ProductResponse> getProducts() async {
    final token = await getToken();
    final url = Uri.parse('${Constants.BASE_URL}/api/products');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProductResponse.fromJson(data);
    } else {
      throw Exception('Gagal mengambil produk: ${response.body}');
    }
  }

  // CREATE PRODUCT (Draft) - Menggunakan Class Model
  Future<Map<String, dynamic>> createProduct({
    required String name,
    required int price,
    required String description,
  }) async {
    final token = await getToken();
    final url = Uri.parse('${Constants.BASE_URL}/api/products');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal menyimpan produk: ${response.body}');
    }
  }

  // DELETE PRODUCT (Soft Delete)
  Future<Map<String, dynamic>> deleteProduct(int productId) async {
    final token = await getToken();
    final url = Uri.parse('${Constants.BASE_URL}/api/products/$productId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal menghapus produk: ${response.body}');
    }
  }

  // SUBMIT TUGAS - Sesuai contoh di PDF
  Future<Map<String, dynamic>> submitTask({
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    final token = await getToken();
    final url = Uri.parse('${Constants.BASE_URL}/api/products/submit');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'price': price,
        'description': description,
        'github_url': githubUrl,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal submit tugas: ${response.body}');
    }
  }
}
