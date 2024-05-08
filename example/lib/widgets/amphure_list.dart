import 'package:flutter/material.dart';
import 'package:flutter_thailand_provinces/flutter_thailand_provinces.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class AmpureList extends StatefulWidget {
  final ProvinceDao? province;
  final Function(AmphureDao)? onSelected;
  const AmpureList({Key? key, this.province, this.onSelected})
      : super(key: key);

  @override
  _AmpureListState createState() => _AmpureListState();
}

class _AmpureListState extends State<AmpureList> {
  List<AmphureDao> list = [];
  List<AmphureDao> filterList = [];
  List<String> alphabet = [];

  final _selectedIndexNotifier = ValueNotifier<int>(0);

  final GroupedItemScrollController itemScrollController =
      GroupedItemScrollController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant AmpureList oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.province != widget.province) {
    //   _init();
    // }
    print('didUpdateWidget');
  }

  Future<void> _init() async {
    print('init ampure: ${widget.province?.nameEn}');
    final list =
        await AmphureProvider.all(provinceId: widget.province?.id ?? 0);
    setState(() {
      this.list = list;
      filterList = list;
      alphabet = list.map((e) => e.nameEn![0].toUpperCase()).toSet().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StickyGroupedListView<AmphureDao, String>(
          itemScrollController: itemScrollController,
          padding: EdgeInsets.all(16),
          elements: filterList,
          groupBy: (element) => element.nameEn![0].toUpperCase(),
          groupSeparatorBuilder: (element) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              element.nameEn![0],
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          itemBuilder: (context, AmphureDao element) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(element.nameEn ?? ''),
            onTap: () {
              widget.onSelected!(element);
            },
          ),
          itemComparator: (item1, item2) =>
              item1.nameEn!.compareTo(item2.nameEn!),
          separator: const Divider(height: 1),
          floatingHeader: false,
          stickyHeaderBackgroundColor: Theme.of(context).primaryColorLight,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                children: alphabet
                    .map(
                      (e) => Material(
                        color: Theme.of(context).primaryColorLight,
                        shape: CircleBorder(),
                        child: InkWell(
                          customBorder: CircleBorder(),
                          onTap: () {
                            final index = filterList.indexWhere(
                                (element) => element.nameEn![0] == e);
                            itemScrollController.scrollTo(
                                index: index,
                                duration: Duration(milliseconds: 200));
                            _selectedIndexNotifier.value = index;
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(e),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
