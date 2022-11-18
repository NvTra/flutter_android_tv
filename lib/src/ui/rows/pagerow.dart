import 'package:flutter/material.dart';
import '../helper/relativesize.dart';
import '../recentfocustraversal.dart';
import 'listrow.dart';

class PageRow extends StatefulWidget {
  final List? categories;

  const PageRow({super.key, required this.categories});

  @override
  State<PageRow> createState() => _PageRowState();
}

class _PageRowState extends State<PageRow> implements FocusListener {
  @override
  void initState() {
    super.initState();
     FocusListener.add(this);
  }

  @override
  void dispose() {
    super.dispose();
    FocusListener.remove(this);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories == null) {
      return const Center();
    } else {
      return WillPopScope(
          onWillPop: null,
          child: ListView.builder(
            itemCount: widget.categories?.length,
            padding: RelativeSize.only(top: 100),
            itemBuilder: (context, index) {
              return SizedBox(
                height: RelativeSize.get(ListRow.height),
                child: ListRow(id: index,
                    category: widget.categories?[index]),
              );
            },
          ));
    }
  }

  @override
  void onFocusChanged(FocusGroup group, int row, int column) {
    if (group == FocusGroup.sidebar) {
      setState(() {

      });
    }
  }
}