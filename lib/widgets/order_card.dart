import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_model.dart';
import '../theme/app_theme.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({Key key, @required this.order, this.onTap}) : super(key: key);

  final Order order;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Stack(
        children: <Widget>[
          _buildCard(),
          _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildCard() {
    return Card(
      margin: const EdgeInsets.all(0),
      color: AppTheme.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 1,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 20),
          child: IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Expanded(flex: 1, child: _buildDate()),
                const Padding(
                  padding: EdgeInsets.only(left: 6.0, right: 10.0),
                  child: VerticalDivider(color: AppTheme.divider, thickness: 0.5),
                ),
                Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          order.name,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: AppTheme.darkText,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: _buildProgressBar(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '${_getRemainingDays()} ${_getRemainingDays() == 1 ? 'day' : 'days'} left',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: AppTheme.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDate() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          _getClosingDay(),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
            color: AppTheme.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _getClosingMonth(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.27,
            color: AppTheme.grey,
          ),
        )
      ],
    );
  }

  Widget _buildProgressBar() {
    final Color color = _getProgressBarColor();

    return Container(
      height: 7,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: _getRemainingDays(),
            child: Container(
              height: 7,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[color, color.withOpacity(0.5)]),
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              ),
            ),
          ),
          Expanded(
            flex: _getTotalDays() - _getRemainingDays(),
            child: const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      child: Material(
        color: AppTheme.transparent,
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          onTap: () => onTap?.call(),
        ),
      ),
    );
  }

  String _getClosingDay() {
    return DateFormat('d').format(order.closesOn);
  }

  String _getClosingMonth() {
    return DateFormat('MMM').format(order.closesOn);
  }

  int _getRemainingDays() {
    final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final int days = order.closesOn.difference(today).inDays;

    return days > 0 ? days : 0;
  }

  int _getTotalDays() {
    return order.closesOn.difference(order.shippedOn).inDays;
  }

  Color _getProgressBarColor() {
    final int remainingDays = _getRemainingDays();

    if (remainingDays > 15) {
      return AppTheme.blue;
    } else if (remainingDays <= 15 && remainingDays > 7) {
      return AppTheme.orange;
    } else {
      return AppTheme.red;
    }
  }
}
