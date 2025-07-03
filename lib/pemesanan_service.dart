import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PemesananService {
  static const String baseUrl =
      "http://127.0.0.1:8000/api"; // Ganti dengan URL kamu

  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // 1. Tampilkan semua supir + jadwal
  static Future<Map<String, dynamic>> getDrivers() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/tampil-driver"),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(response.body);
  }

  // 2. Buat pemesanan baru
  static Future<Map<String, dynamic>> createPemesanan({
    required int idJadwal,
    required int jumlahKursi,
    required String lokasiPenjemputan,
    required String lokasiTujuan,
  }) async {
    final token = await _getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/pemesanan"),
      headers: {"Authorization": "Bearer $token"},
      body: {
        "id_jadwal": idJadwal.toString(),
        "jumlah_kursi": jumlahKursi.toString(),
        "lokasi_penjemputan": lokasiPenjemputan,
        "lokasi_tujuan": lokasiTujuan,
      },
    );

    return jsonDecode(response.body);
  }

  // 3. Lihat semua pemesanan user
  static Future<Map<String, dynamic>> getPemesananSaya() async {
    final token = await _getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/lihat-pemesanan"),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(response.body);
  }

  // 4. Update pemesanan (status, kursi, dll)
  static Future<Map<String, dynamic>> updatePemesanan({
    required int idPemesanan,
    int? jumlahKursi,
    String? lokasiPenjemputan,
    String? lokasiTujuan,
    String? status,
  }) async {
    final token = await _getToken();

    final Map<String, String> body = {};
    if (jumlahKursi != null) body['jumlah_kursi'] = jumlahKursi.toString();
    if (lokasiPenjemputan != null)
      body['lokasi_penjemputan'] = lokasiPenjemputan;
    if (lokasiTujuan != null) body['lokasi_tujuan'] = lokasiTujuan;
    if (status != null) body['status'] = status;

    final response = await http.put(
      Uri.parse("$baseUrl/update-pemesanan/$idPemesanan"),
      headers: {"Authorization": "Bearer $token"},
      body: body,
    );

    return jsonDecode(response.body);
  }

  // 5. Hapus pemesanan
  static Future<Map<String, dynamic>> deletePemesanan(int idPemesanan) async {
    final token = await _getToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/hapus-pemesanan/$idPemesanan"),
      headers: {"Authorization": "Bearer $token"},
    );

    return jsonDecode(response.body);
  }
}
