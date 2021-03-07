import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/app_theme.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key key, this.initialDate, this.onChange}) : super(key: key);

  final DateTime initialDate;
  final Function(DateTime) onChange;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  static const int _totalDays = 42;
  static const int _daysPerWeek = 7;

  List<DateTime> _days = <DateTime>[];
  DateTime _currentMonthDate;
  DateTime _selectedDate;

  @override
  void initState() {
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
    } else {
      _selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    }

    _handleMonthChange(_selectedDate.year, _selectedDate.month);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4, bottom: 4),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Material(
                    color: AppTheme.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                      onTap: () {
                        _handleMonthChange(_currentMonthDate.year, _currentMonthDate.month - 1);
                      },
                      child: const Icon(Icons.keyboard_arrow_left, color: AppTheme.lightGrey),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    DateFormat('MMMM, yyyy').format(_currentMonthDate),
                    style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: AppTheme.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Material(
                    color: AppTheme.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                      onTap: () {
                        _handleMonthChange(_currentMonthDate.year, _currentMonthDate.month + 1);
                      },
                      child: const Icon(Icons.keyboard_arrow_right, color: AppTheme.lightGrey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, bottom: 8),
          child: Row(children: _buildDayLabels()),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Column(children: _buildDaysTable()),
        ),
      ],
    );
  }

  List<Widget> _buildDayLabels() {
    final List<Widget> list = <Widget>[];

    for (int i = 0; i < _daysPerWeek; i++) {
      list.add(
        Expanded(
          child: Center(
            child: Text(
              DateFormat('EEE').format(_days[i]),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
              ),
            ),
          ),
        ),
      );
    }

    return list;
  }

  List<Widget> _buildDaysTable() {
    final List<Widget> grid = <Widget>[];

    int dayIndex = 0;

    for (int i = 0; i < _days.length / _daysPerWeek; i++) {
      final List<Widget> row = <Widget>[];

      for (int j = 0; j < _daysPerWeek; j++) {
        row.add(Expanded(child: _buildDaysTableElement(_days[dayIndex++])));
      }

      grid.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: row,
      ));
    }

    return grid;
  }

  Widget _buildDaysTableElement(DateTime day) {
    final Color fillColor = _selectedDate.isAtSameMomentAs(day) ? AppTheme.primary : AppTheme.transparent;
    final Color borderColor = _selectedDate.isAtSameMomentAs(day) ? AppTheme.white : AppTheme.transparent;
    final FontWeight fontWeight = _selectedDate.isAtSameMomentAs(day) ? FontWeight.bold : FontWeight.normal;
    final List<BoxShadow> boxShadow = _selectedDate.isAtSameMomentAs(day)
        ? <BoxShadow>[
            BoxShadow(color: AppTheme.lightGrey.withOpacity(0.6), blurRadius: 4, offset: const Offset(0, 0)),
          ]
        : null;

    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: <Widget>[
          Material(
            color: AppTheme.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(32.0)),
              onTap: () {
                _handleDateChange(day);
              },
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                    border: Border.all(color: borderColor, width: 2),
                    boxShadow: boxShadow,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: _getDayTextColor(day),
                        fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                        fontWeight: fontWeight,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 9,
            right: 0,
            left: 0,
            child: Container(
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                color: _isToday(day) ? AppTheme.primary : AppTheme.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime day) {
    return DateTime.now().day == day.day && DateTime.now().month == day.month && DateTime.now().year == day.year;
  }

  Color _getDayTextColor(DateTime day) {
    if (_selectedDate.isAtSameMomentAs(day)) {
      return AppTheme.white;
    }

    if (_currentMonthDate.month == day.month) {
      return AppTheme.black;
    }

    return AppTheme.lightGrey.withOpacity(0.6);
  }

  void _handleMonthChange(int year, int month) {
    final DateTime firstDayOfTheMonth = DateTime(year, month, 0);
    final int elapsedWeekDays = firstDayOfTheMonth.weekday < _daysPerWeek ? firstDayOfTheMonth.weekday : 0;
    final DateTime startDay = firstDayOfTheMonth.subtract(Duration(days: elapsedWeekDays));

    final List<DateTime> days = <DateTime>[];

    for (int i = 0; i < _totalDays; i++) {
      days.add(startDay.add(Duration(days: i + 1)));
    }

    setState(() {
      _days = days;
      _currentMonthDate = DateTime(year, month);
    });
  }

  void _handleDateChange(DateTime date) {
    setState(() {
      _selectedDate = date;
    });

    widget.onChange?.call(date);
  }
}
