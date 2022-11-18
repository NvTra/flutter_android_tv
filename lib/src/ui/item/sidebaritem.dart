import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../recentfocustraversal.dart';
import '../helper/relativesize.dart';

class SidebarItem extends StatefulWidget {
  static const double iconSize = 30;

  final double w;
  final double h;
  final int id;
  final String title;
  final AssetImage icon;

  const SidebarItem({
    super.key,
    required this.id,
    required this.title,
    required this.icon,
    this.w = 300,
    this.h = 100
  });

  @override
  State<SidebarItem> createState() => SidebarItemState();
}

class SidebarItemState extends State<SidebarItem> {
  static bool showFull = true;

  final RecentFocusNode _focusNode =
    RecentFocusNode(group: FocusGroup.sidebar);

  final Duration _duration = const Duration(microseconds: 250);
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    _focusNode.row = widget.id;

    double textWidth = SidebarItemState.showFull ?
      widget.w - SidebarItem.iconSize - 50 : 0;

    return GestureDetector(
      onTap: () {
        RecentFocusTraversalPolicy.setFocus(_focusNode, true);
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Focus(
          focusNode: _focusNode,
          autofocus: true,
          onFocusChange: (value) => setState(() {
            _scale = value ? 1.1 : 1;
          }),
          child: AnimatedContainer(
            width: widget.w,
            height: widget.h,
            duration: _duration,
            curve: Curves.bounceIn,
            transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
            transformAlignment: FractionalOffset.center,
            child: Center(
                child: Row(
                    children: <Widget>[
                      Padding(
                          padding: RelativeSize.all(5),
                          child: Image(
                              width: SidebarItem.iconSize,
                              height: SidebarItem.iconSize,
                              fit: BoxFit.fill,
                              image: widget.icon,
                          )
                      ),
                      AnimatedContainer(
                        padding: RelativeSize.only(left: 10),
                        duration: const Duration(milliseconds: 250),
                        width: textWidth,
                        child: SizedBox(
                            child: Text(widget.title)
                        ),
                      ),
                    ])
              ),
            ),
          onKey: (_, event) {
            // In some cases RawKeyDownEvent isn't sent by engine.
            // To manage all cases use RawKeyUpEvent which is always sent.
            if (event is RawKeyUpEvent &&
                (event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.select)) {
              //  widget._showVirtualKeyboardIfNeeded();
              setState(() {
                // _containerColor = Colors.red[400]!;
              });
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
        ),
      ),
    );
  }

}