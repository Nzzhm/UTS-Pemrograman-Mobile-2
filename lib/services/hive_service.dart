import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';
import '../models/transaction.dart';

class HiveService {
  static const String userBox = 'users';
  static const String transactionBox = 'transactions';
  static const String settingsBox = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(TransactionAdapter());

    await Hive.openBox<User>(userBox);
    await Hive.openBox<Transaction>(transactionBox);
    await Hive.openBox(settingsBox);
  }

  static Box<User> getUserBox() => Hive.box<User>(userBox);

  static Future<void> registerUser(User user) async {
    final box = getUserBox();
    await box.add(user);
  }

  static User? loginUser(String username, String password) {
    final box = getUserBox();
    return box.values
            .firstWhere(
              (user) => user.username == username && user.password == password,
              orElse: () => User(username: '', password: '', name: ''),
            )
            .username
            .isEmpty
        ? null
        : box.values.firstWhere(
            (user) => user.username == username && user.password == password,
          );
  }

  static bool userExists(String username) {
    final box = getUserBox();
    return box.values.any((user) => user.username == username);
  }

  // Transaction methods
  static Box<Transaction> getTransactionBox() =>
      Hive.box<Transaction>(transactionBox);

  static Future<void> addTransaction(Transaction transaction) async {
    final box = getTransactionBox();
    await box.add(transaction);
  }

  static Future<void> deleteTransaction(int index) async {
    final box = getTransactionBox();
    await box.deleteAt(index);
  }

  static List<Transaction> getAllTransactions() {
    final box = getTransactionBox();
    return box.values.toList();
  }

  static double getTotalIncome() {
    final transactions = getAllTransactions();
    return transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double getTotalExpense() {
    final transactions = getAllTransactions();
    return transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double getBalance() {
    return getTotalIncome() - getTotalExpense();
  }

  // Settings methods
  static Box getSettingsBox() => Hive.box(settingsBox);

  static Future<void> setLoggedIn(bool value) async {
    final box = getSettingsBox();
    await box.put('isLoggedIn', value);
  }

  static bool isLoggedIn() {
    final box = getSettingsBox();
    return box.get('isLoggedIn', defaultValue: false);
  }

  static Future<void> setCurrentUser(String username) async {
    final box = getSettingsBox();
    await box.put('currentUser', username);
  }

  static String? getCurrentUser() {
    final box = getSettingsBox();
    return box.get('currentUser');
  }

  static Future<void> logout() async {
    final box = getSettingsBox();
    await box.put('isLoggedIn', false);
    await box.delete('currentUser');
  }
}
