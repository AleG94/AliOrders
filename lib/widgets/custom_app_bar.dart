import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.scrollController,
    this.titleOffset = 0,
    this.actions,
  }) : super(key: key);

  final String title;
  final double titleOffset;
  final ScrollController scrollController;
  final List<Widget> actions;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  double opacity = 0.0;

  @override
  void initState() {
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset >= 23) {
        if (opacity != 1.0) {
          setState(() {
            opacity = 1.0;
          });
        }
      } else if (widget.scrollController.offset <= 24 && widget.scrollController.offset >= 0) {
        if (opacity != widget.scrollController.offset / 24) {
          setState(() {
            opacity = widget.scrollController.offset / 24;
          });
        }
      } else if (widget.scrollController.offset <= 0) {
        if (opacity != 0.0) {
          setState(() {
            opacity = 0.0;
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppTheme.white.withOpacity(opacity),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32.0),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppTheme.grey.withOpacity(0.4 * opacity),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 16 + widget.titleOffset,
              right: 16,
              top: 16 - 8.0 * opacity,
              bottom: 12 - 8.0 * opacity,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22 + 6 - 6 * opacity,
                        letterSpacing: 1.2,
                        color: AppTheme.darkerText,
                      ),
                    ),
                  ),
                ),
                ...?widget.actions
              ],
            ),
          ),
        ),
      ],
    );
  }
}
