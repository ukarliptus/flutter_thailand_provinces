import 'package:flutter/material.dart';
import 'package:flutter_thailand_provinces_example/screens/address_list_screen.dart';
import 'package:flutter_thailand_provinces_example/screens/provinces_list_screen.dart';
import 'package:flutter_thailand_provinces/flutter_thailand_provinces.dart';
import 'package:flutter_thailand_provinces_example/widgets/search_address_bottom_sheet.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProvinceDao? provinceSelected;

  final TextEditingController _controller = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  void _onTapSearchAddress() async {
    final result = await showBarModalBottomSheet<Address>(
      context: context,
      builder: (context) {
        return SearchAddressBottomSheet();
      },
    );

    if (result != null) {
      _controller.text = result.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: Text("Thailand Provinces Database"),
        ),
        body: Container(
          color: Colors.grey[200],
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProvincesListScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 80,
                            offset: Offset(0, 10))
                      ]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "จังหวัด > อำเภอ > ตำบล",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[600],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddressListScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 80,
                            offset: Offset(0, 10))
                      ]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "ค้นหาที่อยู่",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[600],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () async {
                  final list = await ProvinceProvider.all();

                  ProvinceDao? province = await ChooseProvinceDialog.show(
                    context,
                    listProvinces: list,
                    colorBackgroundHeader: Colors.purple[300],
                    colorLineHeader: Colors.purple[500],
                    styleTitle:
                        TextStyle(fontSize: 18, fontFamily: "Kanit-Regular"),
                    styleSubTitle: TextStyle(
                        fontSize: 14,
                        fontFamily: "Kanit-Regular",
                        color: Colors.grey[400]),
                    styleTextNoData: TextStyle(fontFamily: "Kanit-Regular"),
                    styleTextSearchHint: TextStyle(fontFamily: "Kanit-Regular"),
                    styleTextSearch: TextStyle(fontFamily: "Kanit-Regular"),
                  );
                  setState(() {
                    provinceSelected = province;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 80,
                            offset: Offset(0, 10))
                      ]),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              provinceSelected?.nameTh ?? "เลือกจังหวัด",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              provinceSelected?.nameEn ?? "",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey[600],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: _controller,
                maxLines: 4,
                onTap: _onTapSearchAddress,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Province \nAmhure \nDistrict \nZipCode',
                  fillColor: Colors.white,
                  filled: true,
                  hintMaxLines: 4,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              // ElevatedButton(
              //     onPressed: _onTapSearchAddress,
              //     child: Text('Show Search Address')),
            ],
          ),
        ));
  }
}
