import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/hive_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  Map<String, double> _getCategoryData(bool isIncome) {
    final transactions = HiveService.getAllTransactions();
    final filteredTransactions =
        transactions.where((t) => t.isIncome == isIncome);

    final Map<String, double> categoryData = {};
    for (var transaction in filteredTransactions) {
      categoryData[transaction.category] =
          (categoryData[transaction.category] ?? 0) + transaction.amount;
    }

    return categoryData;
  }

  @override
  Widget build(BuildContext context) {
    final balance = HiveService.getBalance();
    final income = HiveService.getTotalIncome();
    final expense = HiveService.getTotalExpense();
    final expenseData = _getCategoryData(false);
    final incomeData = _getCategoryData(true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Ringkasan Keuangan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow('Total Saldo', balance, Colors.blue),
                    const Divider(),
                    _buildSummaryRow('Total Pemasukan', income, Colors.green),
                    const Divider(),
                    _buildSummaryRow('Total Pengeluaran', expense, Colors.red),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Expense by Category
            if (expenseData.isNotEmpty) ...[
              const Text(
                'Pengeluaran per Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: expenseData.entries.map((entry) {
                              final percentage = (entry.value / expense * 100);
                              return PieChartSectionData(
                                value: entry.value,
                                title: '${percentage.toStringAsFixed(1)}%',
                                color: _getCategoryColor(entry.key),
                                radius: 80,
                                titleStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...expenseData.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(entry.key),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(entry.key)),
                              Text(
                                currencyFormat.format(entry.value),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Income by Category
            if (incomeData.isNotEmpty) ...[
              const Text(
                'Pemasukan per Kategori',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: incomeData.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(entry.key)),
                            Text(
                              currencyFormat.format(entry.value),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],

            if (expenseData.isEmpty && incomeData.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.bar_chart,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada data statistik',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          currencyFormat.format(amount),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Makanan': Colors.orange,
      'Transport': Colors.blue,
      'Belanja': Colors.purple,
      'Hiburan': Colors.pink,
      'Kesehatan': Colors.red,
      'Pendidikan': Colors.indigo,
      'Tagihan': Colors.brown,
      'Gaji': Colors.green,
      'Bonus': Colors.lightGreen,
      'Bisnis': Colors.teal,
      'Investasi': Colors.cyan,
      'Hadiah': Colors.amber,
    };
    return colors[category] ?? Colors.grey;
  }
}
