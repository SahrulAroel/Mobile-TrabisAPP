import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabis Travel Bengkalis - Riwayat',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Mengatur warna dasar aplikasi
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HistoryPage(), // Menampilkan HistoryPage sebagai halaman utama
    );
  }
}

// ===============================================
// Model Data untuk Riwayat Perjalanan
// ===============================================
class TripHistory {
  final String id;
  final String origin;
  final String destination;
  final String originTime;
  final String destinationTime;
  final String driverName;
  final String driverRating;
  final String driverImage; // URL atau path aset gambar driver
  final String carType;
  final String carPlate;
  final String price;
  final int numberOfPassengers;
  final DateTime departureDate;
  final String departureTime;
  final String status; // Misalnya: 'Completed', 'Canceled', 'Pending'
  final String paymentStatus; // Misalnya: 'Lunas', 'Belum Lunas'

  TripHistory({
    required this.id,
    required this.origin,
    required this.destination,
    required this.originTime,
    required this.destinationTime,
    required this.driverName,
    required this.driverRating,
    required this.driverImage,
    required this.carType,
    required this.carPlate,
    required this.price,
    required this.numberOfPassengers,
    required this.departureDate,
    required this.departureTime,
    required this.status,
    required this.paymentStatus,
  });
}

// ===============================================
// Halaman HistoryPage (Daftar Riwayat Perjalanan)
// ===============================================
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Indeks untuk Bottom Navigation Bar, diatur ke 2 (Riwayat)
  int _selectedIndex = 2; // Mengganti dari Pesan ke Riwayat berdasarkan bottom nav bar

  // Contoh data riwayat perjalanan
  final List<TripHistory> _tripHistories = [
    TripHistory(
      id: 'TRB-001',
      origin: 'Bengkalis',
      destination: 'Pekanbaru',
      originTime: '10.00 AM',
      destinationTime: '14.00 PM',
      driverName: 'Mang Eza',
      driverRating: '4.9',
      driverImage: 'https://placehold.co/60x60/cccccc/ffffff?text=ME',
      carType: 'Avanza',
      carPlate: 'BM 1234 HP',
      price: 'Rp. 300.000',
      numberOfPassengers: 2,
      departureDate: DateTime(2025, 6, 16),
      departureTime: '10.00 AM',
      status: 'Completed',
      paymentStatus: 'Lunas',
    ),
    TripHistory(
      id: 'TRB-002',
      origin: 'Pekanbaru',
      destination: 'Dumai',
      originTime: '08.00 AM',
      destinationTime: '12.00 PM',
      driverName: 'Bapak Joni',
      driverRating: '4.7',
      driverImage: 'https://placehold.co/60x60/cccccc/ffffff?text=BJ',
      carType: 'Innova',
      carPlate: 'BM 5678 JI',
      price: 'Rp. 250.000',
      numberOfPassengers: 3,
      departureDate: DateTime(2025, 6, 10),
      departureTime: '08.00 AM',
      status: 'Completed',
      paymentStatus: 'Lunas',
    ),
    TripHistory(
      id: 'TRB-003',
      origin: 'Bengkalis',
      destination: 'Siak',
      originTime: '14.00 PM',
      destinationTime: '17.00 PM',
      driverName: 'Ibu Ani',
      driverRating: '4.5',
      driverImage: 'https://placehold.co/60x60/cccccc/ffffff?text=IA',
      carType: 'Xenia',
      carPlate: 'BM 9012 AN',
      price: 'Rp. 180.000',
      numberOfPassengers: 1,
      departureDate: DateTime(2025, 6, 5),
      departureTime: '14.00 PM',
      status: 'Canceled',
      paymentStatus: 'Belum Lunas',
    ),
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Logika navigasi antar halaman bottom nav bar
    print('Bottom nav item $index tapped!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Latar belakang abu-abu muda
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Menghilangkan bayangan app bar
        title: Row(
          children: [
            Image.asset(
              'assets/trabis_logo.png', // Pastikan Anda memiliki file ini di folder assets
              width: 100,
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 5),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.deepOrange, size: 30),
            onPressed: () {
              // Aksi ketika ikon notifikasi ditekan
              print('Notification icon pressed!');
              // Navigasi ke halaman notifikasi jika ada
              // Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'History Perjalanan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true, // Agar ListView tidak mengambil seluruh tinggi
                physics: const NeverScrollableScrollPhysics(), // Menonaktifkan scroll ListView
                itemCount: _tripHistories.length,
                itemBuilder: (context, index) {
                  final trip = _tripHistories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryDetailPage(trip: trip),
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
                          children: [
                            // Rute dan Waktu
                            Row(
                              children: [
                                const Icon(Icons.radio_button_checked, color: Colors.blue, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  trip.origin,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  trip.originTime,
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                              child: DottedLine(
                                dashLength: 4.0,
                                dashGapLength: 4.0,
                                lineThickness: 1.0,
                                dashColor: Colors.grey,
                                direction: Axis.vertical,
                                lineLength: 20,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.deepOrange, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  trip.destination,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  trip.destinationTime,
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                            const Divider(height: 20, thickness: 1), // Garis pemisah
                            // Info Driver dan Harga
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(trip.driverImage),
                                  onBackgroundImageError: (exception, stackTrace) {
                                    debugPrint('Error loading driver image: $exception');
                                  },
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.driverName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.amber, size: 15),
                                          Text(
                                            trip.driverRating,
                                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'Harga',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      trip.price,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.deepOrange,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _selectedIndex, // Mengatur item yang aktif
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Lokasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history), // Ikon Riwayat
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// Widget DottedLine untuk garis putus-putus (sama seperti di halaman Maps)
class DottedLine extends StatelessWidget {
  final double dashLength;
  final double dashGapLength;
  final double lineThickness;
  final Color dashColor;
  final Axis direction;
  final double lineLength;

  const DottedLine({
    super.key,
    this.dashLength = 5.0,
    this.dashGapLength = 3.0,
    this.lineThickness = 1.0,
    this.dashColor = Colors.black,
    this.direction = Axis.horizontal,
    this.lineLength = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double len = direction == Axis.horizontal ? constraints.constrainWidth() : lineLength;
        final int dashCount = (len / (dashLength + dashGapLength)).floor();
        return Flex(
          direction: direction,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: direction == Axis.horizontal ? dashLength : lineThickness,
              height: direction == Axis.vertical ? dashLength : lineThickness,
              child: DecoratedBox(
                decoration: BoxDecoration(color: dashColor),
              ),
            );
          }),
        );
      },
    );
  }
}


// ===============================================
// Halaman HistoryDetailPage (Detail Riwayat Perjalanan)
// ===============================================
class HistoryDetailPage extends StatelessWidget {
  final TripHistory trip;

  const HistoryDetailPage({super.key, required this.trip});

  // Helper untuk format tanggal
  String _formatDate(DateTime date) {
    final Map<int, String> monthNames = {
      1: 'Januari', 2: 'Februari', 3: 'Maret', 4: 'April', 5: 'Mei', 6: 'Juni',
      7: 'Juli', 8: 'Agustus', 9: 'September', 10: 'Oktober', 11: 'November', 12: 'Desember'
    };
    return '${date.day} ${monthNames[date.month]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      appBar: AppBar(
        backgroundColor: Colors.deepOrange, // Warna app bar oranye
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: const Text(
          'Detail History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Tanggal dan Status di bagian atas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_formatDate(trip.departureDate)} ${trip.departureTime}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  trip.status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: trip.status == 'Completed' ? Colors.green : (trip.status == 'Canceled' ? Colors.red : Colors.orange),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Trip Detail',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            // Card Trip Detail
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100], // Latar belakang abu-abu muda
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Rute dan Waktu
                  Row(
                    children: [
                      const Icon(Icons.radio_button_checked, color: Colors.blue, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        trip.origin,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        trip.originTime,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                    child: DottedLine(
                      dashLength: 4.0,
                      dashGapLength: 4.0,
                      lineThickness: 1.0,
                      dashColor: Colors.grey,
                      direction: Axis.vertical,
                      lineLength: 20,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.deepOrange, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        trip.destination,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        trip.destinationTime,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 1), // Garis pemisah
                  // Info Driver dan Mobil
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(trip.driverImage),
                        onBackgroundImageError: (exception, stackTrace) {
                          debugPrint('Error loading driver image: $exception');
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.driverName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 15),
                                Text(
                                  trip.driverRating,
                                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            trip.carType,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            trip.carPlate,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Detail Tambahan
            _buildDetailRow('Jumlah Penumpang', '${trip.numberOfPassengers} Orang'),
            const SizedBox(height: 10),
            _buildDetailRow('Tanggal Keberangkatan', _formatDate(trip.departureDate)),
            const SizedBox(height: 10),
            _buildDetailRow('Jam Keberangkatan', trip.departureTime),
            const SizedBox(height: 10),
            _buildDetailRow('Harga', trip.price),
            const Divider(height: 30, thickness: 1), // Garis pemisah
            _buildDetailRow('Status', trip.paymentStatus,
                valueColor: trip.paymentStatus == 'Lunas' ? Colors.green : Colors.red),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk baris detail
  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
