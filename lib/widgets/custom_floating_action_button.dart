import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    Key key,
    @required this.child,
    @required this.color,
    @required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final Color color;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.35),
            offset: const Offset(8.0, 16.0),
            blurRadius: 16.0,
          ),
        ],
      ),
      child: Material(
        color: AppTheme.transparent,
        child: InkWell(
          splashColor: AppTheme.white.withOpacity(0.1),
          highlightColor: AppTheme.transparent,
          focusColor: AppTheme.transparent,
          onTap: () => onPressed(),
          child: child,
        ),
      ),
    );
  }
}
