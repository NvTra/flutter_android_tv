import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;
import '../recentfocustraversal.dart';
import '../helper/relativesize.dart';

class VideoCard extends StatefulWidget {
  static const double focusScale = 1.15;
  final double w;
  final double h;
  final Color color;
  final bool autofocus;
  final int row, column;
  final dynamic video;

  const VideoCard({
    super.key,
    required this.row,
    required this.column,
    required this.w,
    required this.h,
    required this.video,
    this.color = Colors.grey,
    this.autofocus = true,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  final RecentFocusNode _focusNode = RecentFocusNode(group: FocusGroup.listRow);
  final Duration _duration = const Duration(microseconds: 500);
  double _scale = 1.0;
  double _elevation = 5;
  Color _color = Colors.blue;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _focusNode.row = widget.row;
    _focusNode.column = widget.column;

    return GestureDetector(
      onTap: () {
        RecentFocusTraversalPolicy.setFocus(_focusNode, true);
      },
      child: Padding(
        padding: RelativeSize.all(3),
        child: Focus(
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          onFocusChange: (value) => setState(() {
            _scale = value ? VideoCard.focusScale : 1;
            _color = value ? Colors.blueAccent : Colors.blue;
            _elevation = value ? 10 : 5;
          }),
          child: AnimatedContainer(
            width: widget.w,
            height: widget.h,
            duration: _duration,
            curve: Curves.bounceIn,
            transform: Matrix4.diagonal3(Vector3(_scale, _scale, _scale)),
            transformAlignment: FractionalOffset.center,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: _color,
              semanticContainer: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: _elevation,
              child: Column(
                children: <Widget> [
                  Image.network(
                    widget.video['image'],
                    height: widget.h * 0.58,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: widget.h * 0.3,
                    child: Text(widget.video['name'])
                  ),
                ],
              )
            ),
          ),
          onKey: (_, event) {
            // In some cases RawKeyDownEvent isn't sent by engine.
            // To manage all cases use RawKeyUpEvent which is always sent.
            if (event is RawKeyUpEvent) {
                if (event.logicalKey == LogicalKeyboardKey.backspace ||
                  event.logicalKey == LogicalKeyboardKey.goBack) {
                  RecentFocusTraversalPolicy.moveToSidebar();
                  return KeyEventResult.skipRemainingHandlers;
                }
            }
            return KeyEventResult.ignored;
          },
        ),
      ),
    );
  }
}