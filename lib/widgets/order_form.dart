import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/order_model.dart';
import '../theme/app_theme.dart';
import 'calendar/calendar_dialog.dart';

class OrderForm extends StatefulWidget {
  const OrderForm({Key key, @required this.formKey, @required this.order}) : super(key: key);

  final GlobalKey<FormState> formKey;
  final Order order;

  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  DateTime _shippedOnDate;
  TextEditingController _nameController;
  TextEditingController _shippedOnController;
  TextEditingController _buyerProtectionController;

  @override
  void initState() {
    super.initState();

    final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    _shippedOnDate = widget.order.shippedOn ?? today;
    _nameController = TextEditingController(text: widget.order.name ?? '');
    _shippedOnController = TextEditingController(text: _dateToString(_shippedOnDate));

    if (widget.order.closesOn != null) {
      final int remainingDays = widget.order.closesOn.difference(today).inDays;

      _buyerProtectionController = TextEditingController(text: remainingDays > 0 ? remainingDays.toString() : '0');
    } else {
      _buyerProtectionController = TextEditingController(text: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 12),
            child: _buildNameTextField(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: _buildShippedOnTextField(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 12),
            child: _buildBuyerProtectionTextField(),
          ),
        ],
      ),
    );
  }

  Widget _buildNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 17.0),
          child: Text(
            'Name',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AppTheme.grey.withOpacity(0.7),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Stack(
            children: <Widget>[
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: const BorderRadius.all(Radius.circular(38.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppTheme.lightGrey.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: Padding(
                  padding: const EdgeInsets.only(left: 13, right: 13),
                  child: TextFormField(
                    controller: _nameController,
                    validator: _validateName,
                    style: const TextStyle(fontSize: 18),
                    cursorColor: AppTheme.primary,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 6.0, right: 6.0),
                      border: InputBorder.none,
                      hintText: 'Enter a name',
                      hintStyle: TextStyle(color: AppTheme.lightGrey),
                    ),
                    onSaved: (String value) {
                      widget.order.name = value;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShippedOnTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 17.0),
          child: Text(
            'Shipped on',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AppTheme.grey.withOpacity(0.7),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: const BorderRadius.all(Radius.circular(38.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppTheme.lightGrey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 13, right: 13, top: 1, bottom: 1),
                    child: TextFormField(
                      controller: _shippedOnController,
                      enabled: false,
                      style: const TextStyle(fontSize: 18),
                      cursorColor: AppTheme.primary,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 6.0, right: 6.0),
                        border: InputBorder.none,
                      ),
                      onSaved: (_) {
                        widget.order.shippedOn = _shippedOnDate;
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(38.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppTheme.lightGrey.withOpacity(0.6),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Material(
                color: AppTheme.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _showShippedOnCalendarDialog(context: context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.calendar_today_rounded, size: 20, color: AppTheme.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBuyerProtectionTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 17.0),
          child: Text(
            'Buyer protection',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AppTheme.grey.withOpacity(0.7),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Stack(
            children: <Widget>[
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: const BorderRadius.all(Radius.circular(38.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppTheme.lightGrey.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 8.0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.5),
                child: Padding(
                  padding: const EdgeInsets.only(left: 13, right: 13),
                  child: TextFormField(
                    controller: _buyerProtectionController,
                    validator: _validateBuyerProtection,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(fontSize: 18),
                    cursorColor: AppTheme.primary,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 6.0, right: 6.0),
                      border: InputBorder.none,
                      hintText: 'Enter remaining days',
                      hintStyle: TextStyle(color: AppTheme.lightGrey),
                    ),
                    onSaved: (String value) {
                      final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                      widget.order.closesOn = today.add(Duration(days: int.parse(value)));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _validateName(String name) {
    return name.isEmpty ? 'Please enter a name' : null;
  }

  String _validateBuyerProtection(String buyerProtection) {
    return buyerProtection.isEmpty ? 'Please enter buyer protection' : null;
  }

  String _dateToString(DateTime date) {
    return DateFormat('dd/MM/y').format(_shippedOnDate);
  }

  void _showShippedOnCalendarDialog({BuildContext context}) {
    showDialog<CalendarDialog>(
      context: context,
      builder: (BuildContext context) => CalendarDialog(
        initialDate: _shippedOnDate,
        onConfirm: (DateTime date) {
          setState(() {
            _shippedOnDate = date;
            _shippedOnController.text = _dateToString(date);
          });
        },
      ),
    );
  }
}
