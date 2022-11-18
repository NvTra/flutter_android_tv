import 'package:flutter/material.dart';
import 'item/sidebaritem.dart';
import 'recentfocustraversal.dart';
import 'helper/relativesize.dart';
import '../data/dataprovider.dart';
import 'rows/pagerow.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> implements FocusListener {
  late double _maxWidth;
  List? pages;
  double _size = 300;
  int row = 0;

  get _widthLeft => RelativeSize.get(_size);
  get _widthRight => _maxWidth - _widthLeft;

  void showFull(bool full) {
    SidebarItemState.showFull = full;

    setState(() {
      _size = full ? 300 : 100;
    });
  }

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

  void loadData() async {
    var data = await DataProvider.load();
    setState(() {
      pages = data['pages'];
    });
  }

  @override
  Widget build(BuildContext context) {
    RelativeSize.init(context);
    loadData();

    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      _maxWidth = constraints.maxWidth;

      return Row(
          children: <Widget>[
            AnimatedContainer(
                width: _widthLeft,
                color: Colors.grey,
                duration: const Duration(milliseconds: 250),
                child: FocusTraversalGroup(
                    policy: const RecentFocusTraversalPolicy(group: FocusGroup.sidebar),
                    child: ListView.builder(
                        itemCount: pages?.length ?? 0,
                        padding: EdgeInsets.only(top: RelativeSize.get(100)),
                        itemBuilder: (context, index) {
                          return SidebarItem(id: index,
                              title: pages?[index]['name'],
                              icon: AssetImage(pages?[index]['icon']),
                              w: RelativeSize.get(300),
                              h: RelativeSize.get(100));
                        }
                    )
                )
            ),
            AnimatedContainer(
              width: _widthRight,
              duration: const Duration(milliseconds: 250),
              child: PageRow(categories: pages?[row]['categories']),
            ),
          ]
      );
    });
  }

  @override
  void onFocusChanged(FocusGroup group, int row, int column) {
    showFull(group == FocusGroup.sidebar);
    if (group == FocusGroup.sidebar) this.row = row;
  }
}
