import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yinzo/widgets/display_area.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _revenueController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _transportController = TextEditingController();
  final TextEditingController _otherExpenseController = TextEditingController();

  double budgetFinal = 0.0;
  double allExpenses = 0.0;

  void _calculerBudget() {
    final double revenue = double.tryParse(_revenueController.text) ?? 0.0;
    final double expense = _calculExpense();

    setState(() {
      budgetFinal = revenue - expense;
    });
  }

  double _calculExpense() {
    final double rentCost = double.tryParse(_rentController.text) ?? 0.0;
    final double foodCost = double.tryParse(_foodController.text) ?? 0.0;
    final double transportCost =
        double.tryParse(_transportController.text) ?? 0.0;
    final double costOtherExpense =
        double.tryParse(_otherExpenseController.text) ?? 0.0;

    setState(() {
      allExpenses = (rentCost + foodCost + transportCost + costOtherExpense);
    });
    return allExpenses;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon budget"), centerTitle: true),
      body: SingleChildScrollView(
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
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 54,
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: double.tryParse(_rentController.text) ?? 50,
                      title: "Loyer",
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      value: double.tryParse(_foodController.text) ?? 30,
                      title: "Nourriture",
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: double.tryParse(_transportController.text) ?? 25,
                      title: "Transport",
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.redAccent,
                      value:
                          double.tryParse(_otherExpenseController.text) ?? 20,
                      title: "Autres",
                      radius: 50,
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
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
                labelText: "Revenu mensuel (CDF)",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _rentController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Loyer (CDF)",
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
              onPressed: _calculerBudget,
              icon: const Icon(Icons.calculate, size: 25),
              label: const Text("Calculer", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 20),

            /// 💰 Résultat
            DisplayArea(
              title: "Votre budget restant",
              finalBudget: budgetFinal,
            ),
            const SizedBox(height: 20),
            DisplayArea(title: "Tous vos dépenses", allExpense: allExpenses),
          ],
        ),
      ),
    );
  }
}
