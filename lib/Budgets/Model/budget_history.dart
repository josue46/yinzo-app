import 'package:hive_flutter/hive_flutter.dart';

part 'budget_history.g.dart';

@HiveType(typeId: 0)
class BudgetHistory {
  @HiveField(0)
  final String month;

  @HiveField(1)
  final double revenue;

  @HiveField(2)
  final double rent;

  @HiveField(3)
  final double food;

  @HiveField(4)
  final double transport;

  @HiveField(5)
  final double other;

  @HiveField(6)
  final double finalBudget;

  @HiveField(7)
  final double totalExpense;

  BudgetHistory({
    required this.month,
    required this.revenue,
    required this.rent,
    required this.food,
    required this.transport,
    required this.other,
    required this.finalBudget,
    required this.totalExpense,
  });

  static final String _boxName = "budgetHistoryBox";

  static String get boxName => _boxName;

  static Future<void> initDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(BudgetHistoryAdapter());
    await Hive.openBox<BudgetHistory>(boxName);
  }

  static Box<BudgetHistory> getBudgetHistoryBox() {
    return Hive.box<BudgetHistory>(boxName);
  }

  static Future<void> save({
    required String month,
    required double revenue,
    required double rentCost,
    required double foodCost,
    required double transportCost,
    required double costOtherExpenses,
    required double finalBudget,
    required double totalExpense,
  }) async {
    Box<BudgetHistory> box = getBudgetHistoryBox();
    await box.add(
      BudgetHistory(
        month: month,
        revenue: revenue,
        rent: rentCost,
        food: foodCost,
        transport: transportCost,
        other: costOtherExpenses,
        finalBudget: finalBudget,
        totalExpense: totalExpense,
      ),
    );
  }

  static List<BudgetHistory> getAll() {
    Box<BudgetHistory> box = getBudgetHistoryBox();
    var data = box.values.toList();
    return data;
  }

  static Future<void> delete(int index) async {
    Box<BudgetHistory> box = getBudgetHistoryBox();
    await box.deleteAt(index);
  }

  static Future<void> clear() async {
    Box<BudgetHistory> box = getBudgetHistoryBox();
    await box.clear();
  }
}
