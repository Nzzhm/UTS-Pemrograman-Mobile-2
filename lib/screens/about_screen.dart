import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.account_balance_wallet,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              'Money Manager',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Versi 1.0.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Deskripsi Aplikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Money Manager adalah aplikasi manajemen keuangan sederhana yang membantu Anda melacak pemasukan dan pengeluaran dengan mudah. Aplikasi ini dilengkapi dengan fitur statistik untuk membantu Anda memahami pola keuangan Anda.',
                      style: TextStyle(height: 1.5),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Fitur Utama:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem(
                        'Pencatatan transaksi pemasukan dan pengeluaran'),
                    _buildFeatureItem('Kategorisasi transaksi'),
                    _buildFeatureItem('Statistik keuangan dengan grafik'),
                    _buildFeatureItem('Filter dan pencarian transaksi'),
                    _buildFeatureItem('Penyimpanan data lokal dengan Hive'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Teknologi yang Digunakan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTechItem('Flutter - Framework UI'),
                    _buildTechItem('Hive - Database lokal'),
                    _buildTechItem('FL Chart - Grafik statistik'),
                    _buildTechItem('Intl - Format mata uang'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pengembang',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const ListTile(
                      leading: Icon(Icons.person, color: Colors.blue),
                      title: Text('Muhammad Nizham Hibatullah'),
                      subtitle: Text('23552011241'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.email, color: Colors.blue),
                      title: Text('Email'),
                      subtitle: Text('nizhamhibatullah05@gmail.com'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.school, color: Colors.blue),
                      title: Text('Universitas'),
                      subtitle: Text('Universitas Teknologi Bandung'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '© 2025 Copyright',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Dibuat dengan menggunakan Flutter',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, size: 20, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.code, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
