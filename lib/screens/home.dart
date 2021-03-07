import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../repositories/order_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_floating_action_button.dart';
import '../widgets/order_card.dart';
import '../widgets/section_title.dart';
import '../widgets/summary_card.dart';
import 'create_order.dart';
import 'edit_order.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        backgroundColor: AppTheme.transparent,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              FutureBuilder<List<Order>>(
                future: OrderRepository.list(),
                builder: (BuildContext context, AsyncSnapshot<List<Order>> snapshot) {
                  _animationController.forward();

                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  final List<Order> orders = snapshot.data;

                  return ListView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(top: 86, bottom: 62, left: 24, right: 24),
                    children: <Widget>[
                      _buildSummarySection(orders),
                      const SizedBox(height: 38),
                      _buildOrdersSection(orders),
                    ],
                  );
                },
              ),
              _buildAppBar()
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildAppBar() {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - animation.value), 0.0),
            child: CustomAppBar(title: 'AliOrders', scrollController: _scrollController),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)),
      child: CustomFloatingActionButton(
        color: AppTheme.primary,
        onPressed: () {
          Navigator.push<CreateOrder>(
            context,
            MaterialPageRoute<CreateOrder>(builder: (BuildContext context) => const CreateOrder()),
          );
        },
        child: const Icon(Icons.add, color: AppTheme.white, size: 32),
      ),
    );
  }

  Widget _buildSummarySection(List<Order> orders) {
    final Animation<double> titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    final Animation<double> cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.15, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: titleAnimation,
              child: Transform(
                transform: Matrix4.translationValues(0.0, 30 * (1.0 - titleAnimation.value), 0.0),
                child: const SectionTitle(title: 'Summary'),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: cardAnimation,
              child: Transform(
                transform: Matrix4.translationValues(0.0, 30 * (1.0 - cardAnimation.value), 0.0),
                child: Row(children: <Widget>[
                  Flexible(
                    child: SummaryCard(
                      title: 'Total',
                      value: orders.length.toString(),
                      startColor: AppTheme.darkBlue,
                      endColor: AppTheme.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: SummaryCard(
                      title: 'Closing',
                      value: _getClosingOrdersCount(orders).toString(),
                      startColor: AppTheme.red,
                      endColor: AppTheme.orange,
                    ),
                  ),
                ]),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildOrdersSection(List<Order> orders) {
    final List<Widget> rows = <Widget>[];

    for (int i = 0; i < orders.length; i++) {
      rows.add(
        Dismissible(
          key: UniqueKey(),
          onDismissed: (_) async {
            await OrderRepository.delete(orders[i].id);
            orders.removeAt(i);
            setState(() {});
          },
          child: _buildOrderCard(orders[i], i),
        ),
      );
    }

    if (orders.isEmpty) {
      rows.add(_buildEmptyImage());
    }

    final Animation<double> titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: titleAnimation,
              child: Transform(
                transform: Matrix4.translationValues(0.0, 30 * (1.0 - titleAnimation.value), 0.0),
                child: const SectionTitle(title: 'Orders'),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Column(children: <Widget>[...rows]),
      ],
    );
  }

  Widget _buildOrderCard(Order order, int index) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.45 + ((1 - 0.45) / 6) * index, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 30 * (1.0 - animation.value), 0.0),
            child: OrderCard(
              order: order,
              onTap: () {
                Navigator.push<EditOrder>(
                  context,
                  MaterialPageRoute<EditOrder>(builder: (BuildContext context) => EditOrder(order: order)),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyImage() {
    final Animation<double> emptyImageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.65, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        final double windowHeight = MediaQuery.of(context).size.height;
        final double windowWidth = MediaQuery.of(context).size.width;
        final double aspectRatio = windowHeight / windowWidth;
        final bool is16By9 = aspectRatio <= 1.77;

        return FadeTransition(
          opacity: emptyImageAnimation,
          child: Center(
            child: Container(
              padding: EdgeInsets.only(top: is16By9 ? 0 : windowHeight * 0.05),
              width: is16By9 ? windowWidth * 0.72 : windowWidth * 0.85,
              child: Image.asset('assets/img/courier.png'),
            ),
          ),
        );
      },
    );
  }

  int _getClosingOrdersCount(List<Order> orders) {
    final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return orders.where((Order order) => order.closesOn.difference(today).inDays <= 15).toList().length;
  }
}
