import 'package:expanse_tracker/core/data/models/expense_model.dart';
import 'package:expanse_tracker/core/providers/main_provider.dart';
import 'package:expanse_tracker/core/widgets/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<ExpenseModel> _getExpenses(DateTime day) {
    return context
        .read<MainProvider>()
        .expenses
        .where(
          (e) =>
              e.timeStamp.day == day.day &&
              e.timeStamp.month == day.month &&
              e.timeStamp.year == day.year,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (context, mainProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Calendar', style: TextStyle(fontWeight: FontWeight.w700)),
            toolbarHeight: 68,
          ),

          body: Column(
            children: [
              TableCalendar<ExpenseModel>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(color: Color(0xFFCBB891), shape: BoxShape.circle),
                  selectedDecoration: BoxDecoration(color: Color(0xFF1E3C31), shape: BoxShape.circle),
                  markerDecoration: BoxDecoration(color: Color(0xFF849074), shape: BoxShape.circle),
                  weekendTextStyle: TextStyle(color: Color(0xFF849074)),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF1E3C31)),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF1E3C31)),
                ),

                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },

                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                //new
                eventLoader: (day) {
                  return _getExpenses(day);
                },
                //new
                calendarBuilders: CalendarBuilders<ExpenseModel>(
                  markerBuilder: (context, day, events) {
                    if (events.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Positioned(
                      bottom: 1,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                        color: const Color(0xFF1E3C31),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${events.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (_selectedDay != null) ...[
                Text(
                  'Selected date: ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                ),
                //new
                Expanded(
                  child: ListView(
                    children: _getExpenses(_selectedDay!).map((expense) {
                      return ExpenseTile(expense: expense);
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
