import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'calendar.dart';

class CalendarDialog extends StatefulWidget {
  const CalendarDialog({
    Key key,
    this.initialDate,
    this.onConfirm,
    this.barrierDismissible = true,
  }) : super(key: key);

  final DateTime initialDate;
  final bool barrierDismissible;
  final Function(DateTime) onConfirm;

  @override
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> with SingleTickerProviderStateMixin {
  DateTime _selectedDate;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate;
    } else {
      _selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    }

    _animationController = AnimationController(duration: const Duration(milliseconds: 250), vsync: this)..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: AppTheme.transparent,
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: _animationController.value,
              child: InkWell(
                splashColor: AppTheme.transparent,
                focusColor: AppTheme.transparent,
                highlightColor: AppTheme.transparent,
                hoverColor: AppTheme.transparent,
                onTap: () {
                  if (widget.barrierDismissible) {
                    Navigator.pop(context);
                  }
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: AppTheme.lightGrey.withOpacity(0.2),
                            offset: const Offset(4, 4),
                            blurRadius: 8.0,
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Calendar(
                              initialDate: widget.initialDate,
                              onChange: (DateTime date) {
                                setState(() {
                                  _selectedDate = date;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary,
                                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: AppTheme.lightGrey.withOpacity(0.6),
                                      blurRadius: 8,
                                      offset: const Offset(4, 4),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: AppTheme.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                    highlightColor: AppTheme.transparent,
                                    onTap: () {
                                      widget.onConfirm?.call(_selectedDate);
                                      Navigator.pop(context);
                                    },
                                    child: const Center(
                                      child: Text(
                                        'Confirm',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: AppTheme.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
