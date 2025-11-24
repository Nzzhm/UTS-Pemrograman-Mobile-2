import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/hive_service.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  String _filter = 'Semua';

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var transactions = HiveService.getAllTransactions().reversed.toList();

    if (_filter == 'Pemasukan') {
      transactions = transactions.where((t) => t.isIncome).toList();
    } else if (_filter == 'Pengeluaran') {
      transactions = transactions.where((t) => !t.isIncome).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Transaksi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Semua'),
                  selected: _filter == 'Semua',
                  onSelected: (selected) {
                    setState(() {
                      _filter = 'Semua';
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Pemasukan'),
                  selected: _filter == 'Pemasukan',
                  onSelected: (selected) {
                    setState(() {
                      _filter = 'Pemasukan';
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Pengeluaran'),
                  selected: _filter == 'Pengeluaran',
                  onSelected: (selected) {
                    setState(() {
                      _filter = 'Pengeluaran';
                    });
                  },
                ),
              ],
            ),
          ),

          // Transaction List
          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final actualIndex = HiveService.getAllTransactions()
                          .toList()
                          .indexOf(transaction);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${transaction.category} • ${DateFormat('dd MMM yyyy', 'id_ID').format(transaction.date)}',
                              ),
                              if (transaction.note != null &&
                                  transaction.note!.isNotEmpty)
                                Text(
                                  transaction.note!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${transaction.isIncome ? '+' : '-'} ${currencyFormat.format(transaction.amount)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: transaction.isIncome
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Hapus Transaksi'),
                                      content: const Text(
                                        'Apakah Anda yakin ingin menghapus transaksi ini?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await HiveService.deleteTransaction(
                                        actualIndex);
                                    _refresh();
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Transaksi berhasil dihapus'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
