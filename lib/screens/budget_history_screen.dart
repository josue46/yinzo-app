import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:icons_plus/icons_plus.dart' show AntDesign;
import 'package:yinzo/models/budget_history.dart';

class BudgetHistoryScreen extends StatefulWidget {
  const BudgetHistoryScreen({super.key});

  @override
  State<BudgetHistoryScreen> createState() => _BudgetHistoryScreenState();
}

class _BudgetHistoryScreenState extends State<BudgetHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text("Historique des dépenses"),
        backgroundColor: Color(0xFFF5F5F5),
        actions: <Widget>[
          IconButton(
            color: Color.fromARGB(255, 203, 113, 2),
            iconSize: 28,
            icon: Icon(AntDesign.clear_outline),
            onPressed: () async {
              bool? res = await askBeforeDeleting(
                context,
                title:
                    "Toute l'historique sera supprimé. Voulez-vous continuer ?",
              );
              if (res!) await BudgetHistory.clear();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: BudgetHistory.getBudgetHistoryBox().listenable(),
          builder: (context, box, _) {
            // bool hasData = ;
            return !box.values.isNotEmpty
                ? Padding(
                  padding: const EdgeInsets.all(28),
                  child: Center(
                    child: const Text(
                      "Faîtes vos calcules et retrouvez toute votre historique ici.",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: box.values.length,
                    itemBuilder: (context, index) {
                      final history = box.values.toList()[index];
                      return Dismissible(
                        background: Container(
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                        key: Key(history.hashCode.toString()),
                        confirmDismiss: (direction) async {
                          return await askBeforeDeleting(context);
                        },
                        onDismissed: (direction) async {
                          await BudgetHistory.delete(index);
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            titleTextStyle: const TextStyle(fontSize: 18),
                            title: Text("Mois : ${history.month}"),
                            subtitle: Text(
                              "Revenu: ${history.revenue.toStringAsFixed(0)} \$ | "
                              "Dépenses: ${history.totalExpense.toStringAsFixed(0)} \$ | "
                              "Restant: ${history.finalBudget.toStringAsFixed(0)} \$",
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                bool? res = await askBeforeDeleting(context);
                                if (res!) {
                                  await BudgetHistory.delete(index);
                                }
                              },
                              icon: Icon(
                                Icons.delete,
                                size: 22,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
          },
        ),
      ),
    );
  }

  Future<bool?> askBeforeDeleting(
    BuildContext context, {
    String title = "Êtes-vous sûr de vouloir le supprimer ?",
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Text(title),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Non"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: const Text("Historique supprimé...")),
                );
              },
              child: const Text("Oui"),
            ),
          ],
        );
      },
    );
  }
}
