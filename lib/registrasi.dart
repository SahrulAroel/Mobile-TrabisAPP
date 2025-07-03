import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabis Travel Bengkalis - Register', // Judul aplikasi disesuaikan
      theme: ThemeData(
        primarySwatch: Colors.orange, // Mengatur warna dasar aplikasi
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
          const RegisterPage(), // Menampilkan RegisterPage sebagai halaman utama
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController =
      TextEditingController(); // Tambahan untuk Email
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController(); // Tambahan untuk Confirm Password

  bool _isPasswordVisible = false; // Untuk mengontrol visibilitas password
  bool _isConfirmPasswordVisible =
      false; // Untuk mengontrol visibilitas confirm password

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Fungsi untuk menampilkan notifikasi berhasil atau gagal
  void _showRegisterStatus(BuildContext context, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false, // Pengguna harus mengetuk tombol untuk menutup
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ikon Register Berhasil/Gagal
                Icon(
                  isSuccess
                      ? Icons.person_add
                      : Icons.person_remove, // Ikon tambah/hapus pengguna
                  color: Colors.deepOrange, // Warna ikon
                  size: 60,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Register', // Judul pop-up
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isSuccess
                      ? 'Anda Berhasil Mendaftar Di aplikasi ini'
                      : 'Anda Gagal Mendaftar Di aplikasi ini',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Tutup dialog
                      // Anda bisa menambahkan navigasi ke halaman login jika registrasi berhasil
                      if (isSuccess) {
                        // Contoh: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                        print(
                          'Navigating to login page after successful registration.',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih sesuai gambar
      body: SafeArea(
        // Menggunakan SafeArea untuk menghindari area sistem seperti notch atau status bar
        child: SingleChildScrollView(
          // Memungkinkan halaman discroll jika konten melebihi tinggi layar
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 50), // Spasi di bagian atas
              // Logo Trabis
              Image.asset(
                'assets/trabis_logo.png', // Pastikan Anda memiliki file ini di folder assets
                width: 250, // Sesuaikan ukuran logo
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),

              // Teks REGISTER
              const Text(
                'REGISTER', // Diubah menjadi REGISTER
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.deepOrange, // Warna oranye sesuai desain
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50), // Spasi sebelum input fields
              // Input Username
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20), // Spasi antar input fields
              // Input Email (Baru)
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress, // Keyboard tipe email
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20), // Spasi antar input fields
              // Input Password
              TextField(
                controller: _passwordController,
                obscureText:
                    !_isPasswordVisible, // Mengontrol visibilitas teks password
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20), // Spasi antar input fields
              // Input Confirm Password (Baru)
              TextField(
                controller: _confirmPasswordController,
                obscureText:
                    !_isConfirmPasswordVisible, // Mengontrol visibilitas teks confirm password
                decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.deepOrange,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.deepOrange,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 30), // Spasi sebelum tombol Sign In
              // Tombol Sign In
              SizedBox(
                width: double.infinity, // Mengisi lebar penuh
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Logika pendaftaran:
                    final username = _usernameController.text;
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    final confirmPassword = _confirmPasswordController.text;

                    print('Attempting registration...');
                    print('Username: $username');
                    print('Email: $email');
                    print('Password: $password');
                    print('Confirm Password: $confirmPassword');

                    // Contoh simulasi validasi dan hasil pendaftaran
                    if (username.isNotEmpty &&
                        email.isNotEmpty &&
                        password.isNotEmpty &&
                        password == confirmPassword) {
                      // Simulasikan pendaftaran berhasil
                      print('Registration successful!');
                      _showRegisterStatus(
                        context,
                        true,
                      ); // Tampilkan pop-up berhasil
                    } else {
                      // Simulasikan pendaftaran gagal (misal: password tidak cocok, ada field kosong)
                      print('Registration failed!');
                      _showRegisterStatus(
                        context,
                        false,
                      ); // Tampilkan pop-up gagal
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.deepOrange, // Warna oranye sesuai desain
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        30,
                      ), // Bentuk tombol bulat
                    ),
                    elevation: 5, // Efek bayangan
                  ),
                  child: const Text(
                    'Sign In', // Diubah menjadi Sign In
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ), // Spasi sebelum teks "Sudah punya akun?"
              // Teks "Sudah punya akun?" dan "Log In"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Sudah punya akun? ', // Diubah
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Aksi ketika "Log In" ditekan (misal: navigasi kembali ke halaman login)
                      print('Log In clicked!');
                      // Contoh: Navigator.pop(context); // Kembali ke halaman sebelumnya
                    },
                    child: const Text(
                      'Log In', // Diubah
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange, // Warna oranye untuk tautan
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30), // Spasi di bagian bawah
            ],
          ),
        ),
      ),
    );
  }
}
