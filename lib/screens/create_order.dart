import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../repositories/order_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/order_form.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({Key key}) : super(key: key);

  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Order _order = Order();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: AppTheme.transparent,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              ListView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.only(top: 86, bottom: 62, left: 24, right: 24),
                children: <Widget>[
                  OrderForm(formKey: _formKey, order: _order),
                  const SizedBox(height: 42),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 8),
                    child: _buildConfirmButton(),
                  ),
                ],
              ),
              CustomAppBar(title: 'Create order', titleOffset: 10, scrollController: _scrollController),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      height: 52,
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
            _submit();
          },
          child: const Center(
            child: Text(
              'Confirm',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: AppTheme.white),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      await OrderRepository.create(_order);

      Navigator.pop(context);
    }
  }
}
