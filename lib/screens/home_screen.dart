import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/hive_service.dart';
import 'add_transaction_screen.dart';
import 'transaction_list_screen.dart';
import 'statistics_screen.dart';
import 'about_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  final List<Widget> _screens = [
    const HomeContent(),
    const TransactionListScreen(),
    const StatisticsScreen(),
    const AboutScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final balance = HiveService.getBalance();
    final income = HiveService.getTotalIncome();
    final expense = HiveService.getTotalExpense();
    final transactions = HiveService.getAllTransactions();
    final recentTransactions = transactions.reversed.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Apakah Anda yakin ingin keluar?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Ya'),
                    ),
                  ],
                ),
              );

              if (confirm == true && mounted) {
                await HiveService.logout();
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Saldo',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      currencyFormat.format(balance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.arrow_downward, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Pemasukan'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currencyFormat.format(income),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.arrow_upward, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Pengeluaran'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currencyFormat.format(expense),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaksi Terbaru',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (transactions.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransactionListScreen(),
                          ),
                        ).then((_) => _refresh());
                      },
                      child: const Text('Lihat Semua'),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (recentTransactions.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada transaksi',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = recentTransactions[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: transaction.isIncome
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          child: Icon(
                            transaction.isIncome
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: transaction.isIncome
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        title: Text(transaction.title),
                        subtitle: Text(
                          '${transaction.category} • ${DateFormat('dd MMM yyyy', 'id_ID').format(transaction.date)}',
                        ),
                        trailing: Text(
                          '${transaction.isIncome ? '+' : '-'} ${currencyFormat.format(transaction.amount)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: transaction.isIncome
                                ? Colors.green
                                : Colors.red,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          ).then((_) => _refresh());
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
