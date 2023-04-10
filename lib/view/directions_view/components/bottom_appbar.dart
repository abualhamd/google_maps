import 'package:flutter/material.dart';

import '../../../app/core/utils/colors_manager.dart';

class CustomBottomAppBar extends StatefulWidget {
  final List<IconData> icons;
  final ValueChanged<int> onTap;

  const CustomBottomAppBar({
    super.key,
    required this.icons,
    required this.onTap,
  });

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<InkResponse> iconWidgets = [];
    for (int i = 0; i < widget.icons.length; i++) {
      final iconWidget = InkResponse(
          onTap: () {
            // TODO use provider
            setState(() {
              currentIndex = i;
              widget.onTap(i);
            });
          },
          child: Icon(widget.icons[i],
              color: (i != currentIndex)
                  ? ColorsManager.grey
                  : ColorsManager.blue));
      iconWidgets.add(iconWidget);
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: iconWidgets,);
  }
}