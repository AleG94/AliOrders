import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({Key key, @required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        letterSpacing: 0.5,
        color: AppTheme.lightText,
      ),
    );
  }
}
