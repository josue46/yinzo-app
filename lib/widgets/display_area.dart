import 'package:flutter/material.dart';

class DisplayArea extends StatelessWidget {
  const DisplayArea({
    super.key,
    required this.title,
    this.finalBudget,
    this.allExpense,
  });

  final String title;
  final double? finalBudget;
  final double? allExpense;

  @override
  Widget build(BuildContext context) {
    final double toVerify = finalBudget ?? allExpense!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            toVerify >= 50
                ? Colors.green.shade50
                : toVerify < 50 && toVerify >= 20
                ? Colors.orange.shade50
                : Colors.red.shade50,
        border: Border.all(
          color:
              toVerify >= 50
                  ? Colors.green
                  : toVerify < 50 && toVerify >= 20
                  ? Colors.orange
                  : Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        "$title : ${toVerify.toStringAsFixed(2)} \$",
        style: TextStyle(
          fontSize: 18,
          color:
              toVerify >= 50
                  ? Colors.green
                  : toVerify < 50 && toVerify >= 20
                  ? Colors.orange
                  : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
