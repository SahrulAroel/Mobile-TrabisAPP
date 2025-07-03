import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // For date formatting

// ===============================================
// Layanan API (PemesananService)
// ===============================================
class PemesananService {
  static const String baseUrl =
      "http://127.0.0.1:8000/api"; // Ganti dengan URL kamu

  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Ganti "token" dengan key yang sesuai jika berbeda
    // Untuk testing, Anda bisa hardcode token di sini.
    // return "YOUR_AUTH_TOKEN";
    return prefs.getString("token");
  }

  // 1. Tampilkan semua supir + jadwal
  static Future<List<Schedule>> getSchedules() async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found.');

    final response = await http.get(
      Uri.parse("$baseUrl/tampil-driver"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];

      List<Schedule> schedules = [];
      for (var driverData in data) {
        Driver driver = Driver.fromJson(driverData);
        for (var scheduleData in driverData['jadwal']) {
          schedules.add(Schedule.fromJson(scheduleData, driver));
        }
      }
      return schedules;
    } else {
      throw Exception(
        'Failed to load drivers and schedules. Status code: ${response.statusCode}',
      );
    }
  }

  // 2. Buat pemesanan baru
  static Future<Map<String, dynamic>> createPemesanan({
    required int idJadwal,
    required int jumlahKursi,
    required String lokasiPenjemputan,
    required String lokasiTujuan,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found.');

    final response = await http.post(
      Uri.parse("$baseUrl/pemesanan"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
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
  static Future<List<Booking>> getPemesananSaya() async {
    final token = await _getToken();
    if (token == null) throw Exception('Authentication token not found.');

    final response = await http.get(
      Uri.parse("$baseUrl/lihat-pemesanan"),
      headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }
}

// ===============================================
// Model Data (disesuaikan dengan API)
// ===============================================
class Driver {
  final int id;
  final String name;
  final String carModel;
  final String plateNumber;
  final String imageUrl;

  Driver({
    required this.id,
    required this.name,
    required this.carModel,
    required this.plateNumber,
    required this.imageUrl,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id_supir'],
      name: json['nama_supir'] ?? 'N/A',
      carModel: json['mobil'] ?? 'N/A',
      plateNumber: json['plat_nomor'] ?? 'N/A',
      imageUrl:
          json['foto_supir'] ??
          'https://placehold.co/600x400/grey/white?text=No+Image',
    );
  }
}

class Schedule {
  final int id;
  final DateTime departureDateTime;
  final DateTime arrivalDateTime;
  final String origin;
  final String destination;
  final double price;
  final int capacity;
  final Driver driver;

  Schedule({
    required this.id,
    required this.departureDateTime,
    required this.arrivalDateTime,
    required this.origin,
    required this.destination,
    required this.price,
    required this.capacity,
    required this.driver,
  });

  factory Schedule.fromJson(Map<String, dynamic> json, Driver driver) {
    String departureStr = "${json['tanggal']} ${json['waktu_berangkat']}";
    String arrivalStr = "${json['tanggal']} ${json['waktu_sampai']}";

    return Schedule(
      id: json['id_jadwal'],
      departureDateTime: DateFormat("yyyy-MM-dd HH:mm:ss").parse(departureStr),
      arrivalDateTime: DateFormat("yyyy-MM-dd HH:mm:ss").parse(arrivalStr),
      origin: json['asal'] ?? 'N/A',
      destination: json['tujuan'] ?? 'N/A',
      price: (json['harga'] as num).toDouble(),
      capacity: json['kapasitas'] ?? 0,
      driver: driver,
    );
  }
}

class Booking {
  final int id;
  final int scheduleId;
  final int userId;
  final int seats;
  final String pickupLocation;
  final String destinationLocation;
  final String status;
  final String totalAmount;
  final Schedule schedule;

  Booking({
    required this.id,
    required this.scheduleId,
    required this.userId,
    required this.seats,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.status,
    required this.totalAmount,
    required this.schedule,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    final driver = Driver.fromJson(json['jadwal']['supir']);
    final schedule = Schedule.fromJson(json['jadwal'], driver);

    return Booking(
      id: json['id_pemesanan'],
      scheduleId: json['id_jadwal'],
      userId: json['id_user'],
      seats: json['jumlah_kursi'],
      pickupLocation: json['lokasi_penjemputan'],
      destinationLocation: json['lokasi_tujuan'],
      status: json['status'],
      totalAmount: json['total_harga'].toString(),
      schedule: schedule,
    );
  }
}

// ===============================================
// Main App
// ===============================================
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabis Travel Bengkalis - Home',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

// ===============================================
// HomePage
// ===============================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Schedule>> _schedulesFuture;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _schedulesFuture = PemesananService.getSchedules();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return HomeContent(schedulesFuture: _schedulesFuture);
      case 1:
        // Ganti dengan halaman Lokasi Anda jika ada
        return const Center(child: Text('Halaman Lokasi'));
      case 2:
        return const HistoryPage(); // Halaman Riwayat Pemesanan
      case 3:
        // Ganti dengan halaman Profil Anda
        return const Center(child: Text('Halaman Profil'));
      default:
        return HomeContent(schedulesFuture: _schedulesFuture);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(
          'assets/trabis_logo.png',
          width: 100,
          height: 40,
          fit: BoxFit.contain,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.deepOrange,
              size: 30,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Lokasi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final Future<List<Schedule>> schedulesFuture;
  const HomeContent({super.key, required this.schedulesFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Schedule>>(
      future: schedulesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Tidak ada driver tersedia saat ini."),
          );
        }

        final schedules = snapshot.data!;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... (Search Bar, Filter, etc. can be added here)
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Driver Tersedia',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    AvailableDriversPage(schedules: schedules),
                          ),
                        );
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 200, // Horizontal list height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: schedules.length,
                    itemBuilder: (context, index) {
                      final schedule = schedules[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      DriverDetailPage(schedule: schedule),
                            ),
                          );
                        },
                        child: Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                                child: Image.network(
                                  schedule.driver.imageUrl,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.broken_image,
                                            size: 100,
                                          ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      schedule.driver.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '${schedule.origin} - ${schedule.destination}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // ... (Your booking form section)
              ],
            ),
          ),
        );
      },
    );
  }
}

// ===============================================
// AvailableDriversPage (Shows all schedules)
// ===============================================
class AvailableDriversPage extends StatelessWidget {
  final List<Schedule> schedules;
  const AvailableDriversPage({super.key, required this.schedules});

  String formatPrice(double price) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatCurrency.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'Driver Tersedia',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriverDetailPage(schedule: schedule),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        schedule.driver.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.car_rental, size: 150),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      schedule.driver.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.deepOrange,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${schedule.origin} - ${schedule.destination}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.deepOrange,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          DateFormat(
                            'dd MMM yyyy, HH:mm',
                          ).format(schedule.departureDateTime),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        formatPrice(schedule.price),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ===============================================
// DriverDetailPage (Shows details of one schedule)
// ===============================================
class DriverDetailPage extends StatelessWidget {
  final Schedule schedule;
  const DriverDetailPage({super.key, required this.schedule});

  String formatPrice(double price) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatCurrency.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'Detail Driver',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              schedule.driver.imageUrl,
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 80),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.driver.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    Icons.location_on,
                    '${schedule.origin} - ${schedule.destination}',
                    rightText: DateFormat(
                      'HH:mm',
                    ).format(schedule.departureDateTime),
                  ),
                  const SizedBox(height: 10),
                  _buildDetailRow(
                    Icons.credit_card,
                    'Plat no ${schedule.driver.plateNumber}',
                    rightText: formatPrice(schedule.price),
                    rightTextColor: Colors.deepOrange,
                  ),
                  const SizedBox(height: 5),
                  _buildDetailRow(Icons.person, '${schedule.capacity} Orang'),
                  const SizedBox(height: 10),
                  _buildDetailRow(Icons.car_rental, schedule.driver.carModel),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    BookingFormPage(schedule: schedule),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pesan Sekarang',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String leftText, {
    String? rightText,
    Color? rightTextColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepOrange, size: 24),
        const SizedBox(width: 10),
        Text(leftText, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        if (rightText != null)
          Text(
            rightText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: rightTextColor,
            ),
          ),
      ],
    );
  }
}

// ===============================================
// Halaman Baru: BookingFormPage (Form Pemesanan)
// ===============================================
class BookingFormPage extends StatefulWidget {
  final Schedule schedule;

  const BookingFormPage({super.key, required this.schedule});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passengersController = TextEditingController(
    text: '1',
  );
  // Asumsi lokasi penjemputan & tujuan diisi manual
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pickupController.text = widget.schedule.origin;
    _destinationController.text = widget.schedule.destination;
  }

  @override
  void dispose() {
    _passengersController.dispose();
    _pickupController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final response = await PemesananService.createPemesanan(
          idJadwal: widget.schedule.id,
          jumlahKursi: int.parse(_passengersController.text),
          lokasiPenjemputan: _pickupController.text,
          lokasiTujuan: _destinationController.text,
        );

        setState(() => _isLoading = false);

        if (response['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Pemesanan berhasil!'),
              backgroundColor: Colors.green,
            ),
          );
          // Kembali ke halaman utama setelah sukses
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Gagal membuat pemesanan.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          'Form Pemesanan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Isi Detail Pemesanan',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _pickupController,
                label: 'Lokasi Penjemputan',
                hint: 'Masukkan alamat jemput',
                validator:
                    (value) =>
                        value!.isEmpty
                            ? 'Lokasi penjemputan tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _destinationController,
                label: 'Lokasi Tujuan',
                hint: 'Masukkan alamat tujuan',
                validator:
                    (value) =>
                        value!.isEmpty
                            ? 'Lokasi tujuan tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _passengersController,
                label: 'Jumlah Kursi',
                hint: '1',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Jumlah kursi tidak boleh kosong';
                  final count = int.tryParse(value);
                  if (count == null || count <= 0) return 'Jumlah tidak valid';
                  if (count > widget.schedule.capacity)
                    return 'Melebihi kapasitas (${widget.schedule.capacity})';
                  return null;
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          onPressed: _submitBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Pesan Sekarang',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.deepOrange,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.deepOrange,
                width: 2.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ===============================================
// Halaman Riwayat (HistoryPage)
// ===============================================
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = PemesananService.getPemesananSaya();
  }

  String formatPrice(String price) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatCurrency.format(double.parse(price));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<Booking>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Anda belum memiliki riwayat pemesanan."),
            );
          }

          final bookings = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat(
                              'dd MMM yyyy, HH:mm',
                            ).format(booking.schedule.departureDateTime),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            booking.status,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  booking.status.toLowerCase() == 'selesai'
                                      ? Colors.green
                                      : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Text(
                        '${booking.schedule.origin} -> ${booking.schedule.destination}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Driver: ${booking.schedule.driver.name} (${booking.schedule.driver.carModel})',
                      ),
                      const SizedBox(height: 8),
                      Text('${booking.seats} kursi'),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          formatPrice(booking.totalAmount),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
