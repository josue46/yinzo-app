import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yinzo/models/budget_history.dart';
import 'package:yinzo/utils/format_datetime.dart';
import 'package:yinzo/widgets/display_area.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  int? _touchedIndex;
  final TextEditingController _revenueController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _transportController = TextEditingController();
  final TextEditingController _otherExpenseController = TextEditingController();

  double finalBudget = 0.0;
  double totalExpense = 0.0;
  Map<String, double> _percent = {};

  void _calculerBudget() {
    final double revenue = double.tryParse(_revenueController.text) ?? 0.0;
    final double expense = _calculExpense();

    setState(() {
      finalBudget = revenue - expense;
    });
  }

  Map<String, double> _getAllEntries() {
    final double rentCost = double.tryParse(_rentController.text) ?? 0.0;
    final double foodCost = double.tryParse(_foodController.text) ?? 0.0;
    final double transportCost =
        double.tryParse(_transportController.text) ?? 0.0;
    final double costOtherExpense =
        double.tryParse(_otherExpenseController.text) ?? 0.0;

    return {
      'rent': rentCost,
      'food': foodCost,
      'transport': transportCost,
      'other': costOtherExpense,
    };
  }

  double _calculExpense() {
    double rent = _getAllEntries()['rent']!;
    double food = _getAllEntries()['food']!;
    double transport = _getAllEntries()['transport']!;
    double other = _getAllEntries()['other']!;

    setState(() {
      totalExpense = (rent + food + transport + other);
    });
    return totalExpense;
  }

  Map<String, double> _calcutionExpensePercent() {
    Map<String, double> result = _getAllEntries().map((key, value) {
      double percent = (value * 100) / totalExpense;
      return MapEntry(
        key,
        percent.isNaN ? 0.0 : double.parse(percent.toStringAsFixed(2)),
      );
    });

    return result;
  }

  @override
  void dispose() {
    super.dispose();
    _revenueController.dispose();
    _foodController.dispose();
    _rentController.dispose();
    _transportController.dispose();
    _otherExpenseController.dispose();
  }

  Widget _buildLegend(String label, Color color, double? percent) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          "$label: ${percent?.toStringAsFixed(1) ?? 0}%",
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon budget"),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).pushNamed('/budget-history');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // SECTION : Statistiques des dépenses
              const Text(
                "Statistiques de vos dépenses",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: PieChart(
                  curve: Curves.easeInCirc,
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            _touchedIndex = null;
                            return;
                          }
                          _touchedIndex =
                              pieTouchResponse
                                  .touchedSection!
                                  .touchedSectionIndex;
                        });
                      },
                    ),
                    sectionsSpace: 4,
                    centerSpaceRadius: 64,
                    sections: _buildChartSection(),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 15,
                runSpacing: 10,
                children: [
                  _buildLegend("Loyer", Colors.green, _percent['rent']),
                  _buildLegend("Nourriture", Colors.blue, _percent['food']),
                  _buildLegend(
                    "Transport",
                    Colors.orange,
                    _percent['transport'],
                  ),
                  _buildLegend("Autres", Colors.redAccent, _percent['other']),
                ],
              ),

              const SizedBox(height: 30),

              // SECTION : Calcul du budget
              const Text(
                "Calculez votre budget",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: _revenueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Revenu mensuel",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _rentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Loyer",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money_off),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                spacing: 5,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _transportController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Transport",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.money_off),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _foodController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Nourriture",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.money_off),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _otherExpenseController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Autres dépenses",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.money_off),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () async {
                  _calculerBudget();
                  setState(() {
                    _percent = _calcutionExpensePercent();
                  });
                  final String currentMonth = getCurrentFormattedMonth();
                  final double revenue =
                      double.tryParse(_revenueController.text) ?? 0.0;
                  final Map<String, double> entries = _getAllEntries();
                  await BudgetHistory.save(
                    month: currentMonth,
                    revenue: revenue,
                    rentCost: entries["rent"]!,
                    foodCost: entries["food"]!,
                    transportCost: entries["transport"]!,
                    costOtherExpenses: entries["other"]!,
                    finalBudget: finalBudget,
                    totalExpense: totalExpense,
                  );
                },
                icon: const Icon(Icons.calculate, size: 25),
                label: const Text("Calculer", style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),

              const SizedBox(height: 20),

              // Résultat
              DisplayArea(
                title: "Votre budget restant",
                finalBudget: finalBudget,
              ),
              const SizedBox(height: 20),
              DisplayArea(
                title: "Toutes vos dépenses",
                allExpense: totalExpense,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildChartSection() {
    return List.generate(4, (index) {
      final isTouched = index == _touchedIndex;
      final double radius = isTouched ? 60 : 50;

      switch (index) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: double.tryParse(_rentController.text) ?? 50,
            title: "${_percent['rent'] ?? 0.0} %",
            radius: radius,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.blue,
            value: double.tryParse(_foodController.text) ?? 30,
            title: "${_percent['food'] ?? 0.0} %",
            radius: radius,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.orange,
            value: double.tryParse(_transportController.text) ?? 25,
            title: "${_percent['transport'] ?? 0.0} %",
            radius: radius,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.redAccent,
            value: double.tryParse(_otherExpenseController.text) ?? 20,
            title: "${_percent['other'] ?? 0.0} %",
            radius: radius,
            titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
          );
        default:
          return throw Error();
      }
    });
  }
}
