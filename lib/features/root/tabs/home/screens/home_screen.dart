import 'package:expanse_tracker/core/providers/main_provider.dart';
import 'package:expanse_tracker/core/widgets/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const forest = Color(0xFF1E3C31);
  static const sage = Color(0xFF849074);
  static const sand = Color(0xFFCBB891);

  @override
  void initState() {
    super.initState();
    context.read<MainProvider>().loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MainProvider>(
          builder: (context, provider, child) {
            final expenses = provider.expenses;
            final now = DateTime.now();
            final monthExpenses = expenses.where(
              (expense) =>
                  expense.timeStamp.year == now.year &&
                  expense.timeStamp.month == now.month,
            );
            final monthTotal = monthExpenses.fold<double>(
              0,
              (sum, expense) => sum + expense.amount,
            );
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: forest,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.spa_outlined,
                                color: Color(0xFFF5F0E6),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'STILLWELL',
                                  style: TextStyle(
                                    fontSize: 11,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w800,
                                    color: sage,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Your expenses',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        Container(
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: forest,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  22,
                                  21,
                                  22,
                                  20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _monthLabel(now).toUpperCase(),
                                      style: const TextStyle(
                                        color: Color(0xFFB6C0AA),
                                        fontSize: 11,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Spent this month',
                                      style: TextStyle(
                                        color: Color(0xFFF5F0E6),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      monthTotal.toStringAsFixed(2),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${monthExpenses.length} ${monthExpenses.length == 1 ? 'expense' : 'expenses'} recorded',
                                      style: const TextStyle(
                                        color: Color(0xFFB6C0AA),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(height: 9, color: sage),
                              Container(height: 9, color: sand),
                              Container(
                                height: 9,
                                color: const Color(0xFFF5F0E6),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 27),
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Recent activity',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            Text(
                              '${expenses.length} total',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                ),
                if (expenses.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE7E8DD),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: const Icon(
                                Icons.receipt_long_outlined,
                                size: 30,
                                color: forest,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'A fresh start',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Add your first expense to see it here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 100),
                    sliver: SliverList.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) =>
                          ExpenseTile(expense: expenses[index]),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _monthLabel(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
