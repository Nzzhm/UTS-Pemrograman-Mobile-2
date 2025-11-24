import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String category;

  @HiveField(3)
  bool isIncome;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String? note;

  Transaction({
    required this.title,
    required this.amount,
    required this.category,
    required this.isIncome,
    required this.date,
    this.note,
  });
}
