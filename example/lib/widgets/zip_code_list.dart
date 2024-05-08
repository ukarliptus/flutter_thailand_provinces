import 'package:flutter/material.dart';
import 'package:flutter_thailand_provinces/flutter_thailand_provinces.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class ZipCodeList extends StatefulWidget {
  final DistrictDao? district;
  final Function(String)? onSelected;
  const ZipCodeList({Key? key, this.district, this.onSelected})
      : super(key: key);

  @override
  _ZipCodeListState createState() => _ZipCodeListState();
}

class _ZipCodeListState extends State<ZipCodeList> {
  List<String> list = [];
  List<String> filterList = [];

  final _selectedIndexNotifier = ValueNotifier<int>(0);

  final GroupedItemScrollController itemScrollController =
      GroupedItemScrollController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    print('init ampure: ${widget.district?.nameEn}');
    // final list = await DistrictProvider.all(amphureId: widget.amphure?.id ?? 0);
    setState(() {
      this.list = [widget.district?.zipCode ?? ''];
      filterList = [widget.district?.zipCode ?? ''];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
            itemCount: filterList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filterList[index]),
                onTap: () {
                  widget.onSelected!(list[index]);
                },
              );
            }),

        // StickyGroupedListView<String, String>(
        //   itemScrollController: itemScrollController,
        //   padding: EdgeInsets.all(16),
        //   elements: filterList,
        //   groupBy: (element) => element.nameEn![0].toUpperCase(),
        //   groupSeparatorBuilder: (element) => Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //     child: Text(
        //       element.nameEn![0],
        //       style: Theme.of(context).textTheme.titleMedium,
        //     ),
        //   ),
        //   itemBuilder: (context, DistrictDao element) => ListTile(
        //     contentPadding: EdgeInsets.zero,
        //     title: Text(element.nameEn ?? ''),
        //     onTap: () {
        //       widget.onSelected!(element);
        //     },
        //   ),
        //   itemComparator: (item1, item2) =>
        //       item1.nameEn!.compareTo(item2.nameEn!),
        //   separator: const Divider(height: 1),
        //   floatingHeader: false,
        //   stickyHeaderBackgroundColor: Theme.of(context).primaryColorLight,
        // ),
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: Container(
        //     child: SingleChildScrollView(
        //       primary: false,
        //       child: Column(
        //         children: alphabet
        //             .map(
        //               (e) => Material(
        //                 color: Theme.of(context).primaryColorLight,
        //                 shape: CircleBorder(),
        //                 child: InkWell(
        //                   customBorder: CircleBorder(),
        //                   onTap: () {
        //                     final index = filterList.indexWhere(
        //                         (element) => element.nameEn![0] == e);
        //                     itemScrollController.scrollTo(
        //                         index: index,
        //                         duration: Duration(milliseconds: 200));
        //                     _selectedIndexNotifier.value = index;
        //                   },
        //                   child: Container(
        //                     padding: const EdgeInsets.all(8),
        //                     child: Text(e),
        //                   ),
        //                 ),
        //               ),
        //             )
        //             .toList(),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
