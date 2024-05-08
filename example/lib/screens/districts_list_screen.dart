import 'package:flutter/material.dart';
import 'package:flutter_thailand_provinces/flutter_thailand_provinces.dart';

class DistrictsListScreen extends StatefulWidget {
  final AmphureDao amphure;

  DistrictsListScreen({required this.amphure});

  @override
  _DistrictsListScreenState createState() => _DistrictsListScreenState();
}

class _DistrictsListScreenState extends State<DistrictsListScreen> {
  TextEditingController _searchDistrictController = TextEditingController();
  List<DistrictDao> listDistricts = [];
  List<DistrictDao> listDistrictsFilter = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red[300],
          elevation: 0,
          title: Text(widget.amphure.nameTh ?? ''),
        ),
        body: Column(children: [
          buildSearchContainer(),
          Expanded(
            child: listDistricts.isEmpty
                ? FutureBuilder(
                    future:
                        DistrictProvider.all(amphureId: widget.amphure.id ?? 0),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        listDistricts = snapshot.data;
                        listDistrictsFilter = List.of(listDistricts);
                        return buildListView();
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return Text("กำลังโหลด");
                      }
                    },
                  )
                : buildListView(),
          )
        ]));
  }

  Widget buildListView() {
    return Stack(children: [
      ListView.builder(
          itemCount: listDistrictsFilter.length,
          itemBuilder: (context, index) {
            return buildRowDistricts(listDistrictsFilter[index]);
          }),
      Center(
          child: Visibility(
              visible: listDistrictsFilter.isEmpty,
              child: Text(
                "ไม่มีข้อมูล",
                style: TextStyle(fontSize: 22),
              )))
    ]);
  }

  Widget buildRowDistricts(DistrictDao district) {
    return GestureDetector(
        onTap: () {
          print(district.zipCode);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    district.nameTh ?? '',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    district.nameEn ?? '',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[200],
            )
          ],
        ));
  }

  Widget buildSearchContainer() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red[300],
          border: Border(bottom: BorderSide(color: Colors.red, width: 4))),
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: TextField(
            controller: _searchDistrictController,
            decoration: InputDecoration.collapsed(hintText: "ตำบล.."),
            onChanged: (text) async {
              final list = await DistrictProvider.searchInAmphure(
                  amphureId: widget.amphure.id ?? 0, keyword: text);
              print("${list.length}");
              setState(() {
                listDistrictsFilter = list;
              });
            },
          )),
    );
  }
}
