import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabis Travel Bengkalis - Notifikasi',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Set the primary color of the application
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NotificationPage(), // Display the NotificationPage
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background as per design
      appBar: AppBar(
        backgroundColor: Colors.deepOrange, // Orange app bar color
        elevation: 0, // Remove app bar shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.notifications_off, // Mute/no notifications icon
              color: Colors.deepOrange, // Orange color for the icon
              size: 100, // Large size for the icon
            ),
            const SizedBox(height: 20), // Space between icon and text
            const Text(
              'Belum Ada Notifikasi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange, // Orange color for the text
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
