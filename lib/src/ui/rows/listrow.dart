import 'package:flutter/material.dart';
import '../item/videocard.dart';
import '../recentfocustraversal.dart';
import '../helper/relativesize.dart';

class ListRow extends StatelessWidget {
  static const double _textHeight = 40;
  static const double _marginTop = 15;
  static const double _marginBottom = 15;
  static const double _cardWidth = 330;
  static const double _cardHeight = 300;
  static const double height =
      _textHeight + _marginTop + _marginBottom +
      _cardHeight + _marginTop + _marginBottom;

  final int id;
  final dynamic category;

  const ListRow({super.key, required this.id, required this.category});

  @override
  Widget build(BuildContext context) {
    final paddingTitle = RelativeSize.fromLTRB(
        80, _marginTop,
        0, _marginBottom);

    final paddingCards = RelativeSize.fromLTRB(
        50, _textHeight + _marginTop + _marginBottom + _marginTop,
        0, _marginBottom);

    return Stack(
      children: <Widget>[
        Padding(
          padding: paddingTitle,
          child: Text(category['name'],
            style: const TextStyle(fontSize: 40),
            textScaleFactor: RelativeSize.factor)),
        FocusTraversalGroup(
          policy: const RecentFocusTraversalPolicy(group: FocusGroup.listRow),
          child: ListView.builder(
            itemCount: category['videos'].length,
            scrollDirection: Axis.horizontal,
            padding: paddingCards,
            itemBuilder: (context, index) => 
                VideoCard(row: id, column: index, 
                    w: RelativeSize.get(_cardWidth),
                    h: RelativeSize.get(_cardHeight),
                    video: category['videos'][index]),
          ),
        )
      ],
    );
  }
}

