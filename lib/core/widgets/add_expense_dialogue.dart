import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:expanse_tracker/core/providers/main_provider.dart';

import '../data/models/expense_model.dart';

class AddExpenseDialog extends StatefulWidget {
  final ExpenseModel? expenseModel;
  const AddExpenseDialog({super.key, this.expenseModel});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  Category? selectedCategory;
  DateTime selectedDateTime = DateTime.now();

  @override
  void initState() {
    if (widget.expenseModel != null) {
      amountController.text = widget.expenseModel!.amount.toString();
      notesController.text = widget.expenseModel!.note.toString();
      selectedCategory = widget.expenseModel!.category;
      selectedDateTime = widget.expenseModel!.timeStamp;
    }
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          selectedDateTime.hour,
          selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
    );

    if (time != null) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  void _saveExpense() {
    if (amountController.text.trim().isEmpty ||
        selectedCategory == null ||
        notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Amount, category, and notes cannot be empty'),
        ),
      );
      return;
    }

    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Invalid amount')));
      return;
    }

    final provider = context.read<MainProvider>();
    final existingExpense = widget.expenseModel;
    if (existingExpense == null) {
      provider.addExpense(
        amount,
        selectedDateTime,
        selectedCategory!,
        notesController.text.trim(),
      );
    } else {
      provider.updateExpense(
        ExpenseModel(
          id: existingExpense.id,
          amount: amount,
          timeStamp: selectedDateTime,
          category: selectedCategory!,
          note: notesController.text.trim(),
        ),
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const forest = Color(0xFF1E3C31);
    const cream = Color(0xFFF5F0E6);
    return AlertDialog(
      backgroundColor: const Color(0xFFE8EDE8),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
      title: Text(widget.expenseModel == null ? 'Add Expense' : 'Edit Expense'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: _fieldDecoration('Product Amount'),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<Category>(
                initialValue: selectedCategory,
                decoration: _fieldDecoration('Category'),
                items: Category.values.map((category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(switch (category) {
                      Category.food => 'Food',
                      Category.travel => 'Travel',
                      Category.others => 'Others',
                    }),
                  );
                }).toList(),
                onChanged: (category) => setState(() => selectedCategory = category),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: notesController,
                decoration: _fieldDecoration('Notes'),
              ),
              const SizedBox(height: 18),
              Material(
                color: const Color(0xFFE0E6E0),
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: Column(children: [
                  _dateTimeTile(
                    icon: Icons.calendar_month_outlined,
                    title: 'Date',
                    value: '${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year}',
                    onTap: _pickDate,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _dateTimeTile(
                    icon: Icons.schedule_outlined,
                    title: 'Time',
                    value: '${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}',
                    onTap: _pickTime,
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: forest, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14)),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _saveExpense,
          style: FilledButton.styleFrom(
            backgroundColor: forest,
            foregroundColor: cream,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: const StadiumBorder(),
          ),
          icon: Icon(widget.expenseModel == null ? Icons.add : Icons.check),
          label: Text(widget.expenseModel == null ? 'Add Expense' : 'Save Changes'),
        ),
      ],
    );
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0xFFF5F0E6),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF39423C), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF1E3C31), width: 2),
    ),
  );

  Widget _dateTimeTile({required IconData icon, required String title, required String value, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      leading: Icon(icon, color: const Color(0xFF39423C)),
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.edit_outlined, color: Color(0xFF39423C)),
    );
  }
}
