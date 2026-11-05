import 'package:expanse_tracker/core/data/models/expense_model.dart';
import 'package:expanse_tracker/core/data/repositories/expense_repo.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

class MainProvider extends ChangeNotifier {
  List<ExpenseModel> expenses = [];

  void addExpense(
    double amount,
    DateTime timeStamp,
    Category category,
    String note,
  ) {
    expenses.add(
      ExpenseModel(
        amount: amount,
        timeStamp: timeStamp,
        category: category,
        note: note,
      ),
    );
    ExpenseRepo.saveExpenses(expenses);
    notifyListeners();
  }

  double totalExpenses() {
    double totalExpenses = 0;
    expenses.forEach((e) => totalExpenses += e.amount);
    return totalExpenses;
  }

  void removeExpense(String id) {
    expenses.removeWhere((expense) => expense.id == id);
    ExpenseRepo.saveExpenses(expenses);
    notifyListeners();
  }

  Future<void> updateExpense(ExpenseModel updatedExpenseModel) async {
    final index = expenses.indexWhere((e) => e.id == updatedExpenseModel.id);
    if (index == -1) return;
    expenses[index] = updatedExpenseModel;
    notifyListeners();
    ExpenseRepo.saveExpenses(expenses);
  }

  void loadExpenses() async {
    expenses = await ExpenseRepo.getExpenses();
    notifyListeners();
  }
}
