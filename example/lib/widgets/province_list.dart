import 'package:flutter/material.dart';
import 'package:flutter_thailand_provinces/flutter_thailand_provinces.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class ProvinceList extends StatefulWidget {
  final Function(ProvinceDao)? onSelected;
  const ProvinceList({Key? key, this.onSelected}) : super(key: key);

  @override
  _ProvinceListState createState() => _ProvinceListState();
}

class _ProvinceListState extends State<ProvinceList> {
  List<ProvinceDao> listProvinces = [];
  List<ProvinceDao> listProvincesFilter = [];
  List<String> alphabet = [];

  final _selectedIndexNotifier = ValueNotifier<int>(0);

  final GroupedItemScrollController itemScrollController =
      GroupedItemScrollController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final provinces = await ProvinceProvider.all();
    setState(() {
      listProvinces = provinces;
      listProvincesFilter = provinces;
      alphabet =
          provinces.map((e) => e.nameEn![0].toUpperCase()).toSet().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StickyGroupedListView<ProvinceDao, String>(
          itemScrollController: itemScrollController,
          padding: EdgeInsets.all(16),
          elements: listProvincesFilter,
          groupBy: (element) => element.nameEn![0].toUpperCase(),
          groupSeparatorBuilder: (element) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              element.nameEn![0],
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          itemBuilder: (context, ProvinceDao element) => ListTile(
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
          alignment: Alignment.topRight,
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
                            final index = listProvincesFilter.indexWhere(
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
