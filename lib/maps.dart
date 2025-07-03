import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabis Travel Bengkalis - Pemesanan',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Mengatur warna dasar aplikasi
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const OrderPage(), // Menampilkan OrderPage sebagai halaman utama
    );
  }
}

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // Indeks untuk Bottom Navigation Bar, diatur ke 1 (Lokasi) atau 2 (Pesan, jika itu maksudnya)
  // Berdasarkan gambar Maps.png, ikon lokasi aktif, jadi kita set ke 1
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Logika navigasi antar halaman bottom nav bar
    // Anda dapat menambahkan Navigator.pushReplacement di sini untuk navigasi antar halaman utama
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Lokasi Terkini',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                  // Placeholder untuk Maps
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45, // Mengambil 45% tinggi layar
                    width: double.infinity,
                    color: Colors.grey[300], // Warna abu-abu untuk placeholder
                    child: Image.network(
                      'https://placehold.co/600x400/eeeeee/cccccc?text=MAPS_PLACEHOLDER', // Gambar placeholder
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map, size: 50, color: Colors.grey[600]),
                              SizedBox(height: 10),
                              Text('Map data not available', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        // Informasi Driver
                        Row(
                          children: [
                            // Menghapus 'const' dari CircleAvatar ini
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: const NetworkImage('https://placehold.co/60x60/cccccc/ffffff?text=ME'), // Placeholder gambar profil driver
                              onBackgroundImageError: (exception, stackTrace) {
                                debugPrint('Error loading driver image: $exception');
                              },
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Mang Eza',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: const [
                                      Icon(Icons.star, color: Colors.amber, size: 18),
                                      Text(
                                        '4.9',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Tombol Chat
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.chat_rounded, color: Colors.white, size: 28),
                                onPressed: () {
                                  // Navigasi ke halaman chat
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const DriverChatPage(driverName: 'Mang Eza')),
                                  );
                                  print('Chat button pressed!');
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Lokasi Penjemputan dan Tujuan
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
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
                              Row(
                                children: [
                                  const Icon(Icons.radio_button_checked, color: Colors.red, size: 20),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Pekanbaru', // Lokasi penjemputan
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Jl. Sudirman No. 123', // Detail lokasi (opsional)
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Lokasi Anda', // Tujuan
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Jl. Imam Munandar No. 45', // Detail lokasi (opsional)
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _selectedIndex,
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
            icon: Icon(Icons.history),
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

// Widget DottedLine untuk garis putus-putus
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
// Halaman Baru: DriverChatPage
// ===============================================

// Model untuk merepresentasikan sebuah pesan dalam chat
class ChatMessage {
  final String text;
  final bool isSender; // true jika pesan dari pengguna, false jika dari agen CS

  ChatMessage({required this.text, required this.isSender});
}

class DriverChatPage extends StatefulWidget {
  final String driverName;

  const DriverChatPage({super.key, required this.driverName});

  @override
  State<DriverChatPage> createState() => _DriverChatPageState();
}

class _DriverChatPageState extends State<DriverChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    // Contoh pesan awal sesuai gambar Pemesanan.png
    ChatMessage(text: 'mang, mano dkw?', isSender: true),
    ChatMessage(text: 'ni a. lagi jemput budak', isSender: false),
    ChatMessage(text: 'oke mang, kami tunggu sesuai lokasi e', isSender: true),
    ChatMessage(text: 'iyo wak, budak ni tengah berak kang di bawa teceperit pulak kat mobil ni kang', isSender: false),
    ChatMessage(text: 'haha oke wak kami pun tengah sarapan ni', isSender: true),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(text: _messageController.text, isSender: true));
      });
      _messageController.clear();
      // Anda bisa menambahkan logika untuk mengirim pesan ke backend di sini.
      // Untuk demo, kita bisa menambahkan balasan otomatis sederhana.
      _receiveAutoReply();
    }
  }

  void _receiveAutoReply() {
    // Simulasi balasan otomatis setelah beberapa saat
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(ChatMessage(text: 'Oke, segera meluncur!', isSender: false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange, // Warna app bar oranye
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: Row(
          children: [
            // Ikon kepala robot atau ikon driver
            const Icon(Icons.android, color: Colors.white, size: 28), // Placeholder untuk ikon driver
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.driverName, // Nama driver dari parameter
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Text(
                  '● Online', // Status Online
                  style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.all(12.0),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7, // Lebar maksimal gelembung pesan
                    ),
                    decoration: BoxDecoration(
                      color: message.isSender ? Colors.deepOrange : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15.0),
                        topRight: const Radius.circular(15.0),
                        // Gelembung chat khas: bagian bawah sesuai sisi pengirim/penerima lurus
                        bottomLeft: message.isSender ? const Radius.circular(15.0) : const Radius.circular(0.0),
                        bottomRight: message.isSender ? const Radius.circular(0.0) : const Radius.circular(15.0),
                      ),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isSender ? Colors.white : Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input field dan tombol kirim
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3), // Bayangan ke atas
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Write your message',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: const TextStyle(color: Colors.black),
                      maxLines: null, // Memungkinkan input multi-baris
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Tombol Mikrofon
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.deepOrange, size: 28),
                    onPressed: () {
                      print('Microphone button pressed!');
                      // Logika untuk input suara
                    },
                  ),
                ),
                // Tombol Kirim
                CircleAvatar(
                  backgroundColor: Colors.deepOrange,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
