import 'package:flutter/material.dart';
import 'package:flutter_thailand_provinces/flutter_thailand_provinces.dart';
import 'package:flutter_thailand_provinces_example/screens/amphures_list_screen.dart';

class ProvincesListScreen extends StatefulWidget {
  ProvincesListScreen();

  @override
  _ProvincesListScreenState createState() => _ProvincesListScreenState();
}

class _ProvincesListScreenState extends State<ProvincesListScreen> {
  List<ProvinceDao> listProvinces = [];
  List<ProvinceDao> listProvincesFilter = [];
  TextEditingController _searchProvinceController = TextEditingController();

  Future<void> _init() async {
    final provinces = await ProvinceProvider.all();
    setState(() {
      listProvinces = provinces;
      listProvincesFilter = provinces;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Text("ประเทศไทย"),
      ),
      body: Column(
        children: <Widget>[
          buildSearchContainer(),
          Expanded(
            child: listProvinces.isEmpty
                ? FutureBuilder(
                    future: ProvinceProvider.all(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        listProvinces = snapshot.data;
                        listProvincesFilter = List.of(listProvinces);
                        return buildListView();
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        return Text("กำลังโหลด");
                      }
                    },
                  )
                : buildListView(),
          ),
        ],
      ),
    );
  }

  Widget buildListView() {
    return Stack(
      children: <Widget>[
        ListView.builder(
            itemCount: listProvincesFilter.length,
            itemBuilder: (context, index) {
              return buildRowProvince(listProvincesFilter[index]);
            }),
        Center(
            child: Visibility(
                visible: listProvincesFilter.isEmpty,
                child: Text(
                  "ไม่มีข้อมูล",
                  style: TextStyle(fontSize: 22),
                )))
      ],
    );
  }

  Widget buildRowProvince(ProvinceDao province) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AmphuresListScreen(
                        province: province,
                      )));
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
                    province.nameTh ?? '',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    province.nameEn ?? '',
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
          color: Colors.blue,
          border: Border(bottom: BorderSide(color: Colors.blue, width: 4))),
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: TextField(
            controller: _searchProvinceController,
            decoration: InputDecoration.collapsed(hintText: "จังหวัด.."),
            onChanged: (text) async {
              final list = await ProvinceProvider.search(keyword: text);
              setState(() {
                listProvincesFilter = list;
              });
            },
          )),
    );
  }
}
