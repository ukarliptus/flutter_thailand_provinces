import 'package:flutter/material.dart';
import 'package:flutter_thailand_provinces_example/widgets/address_list.dart';
import 'package:flutter_thailand_provinces_example/widgets/amphure_list.dart';
import 'package:flutter_thailand_provinces_example/widgets/district_list.dart';
import 'package:flutter_thailand_provinces_example/widgets/province_list.dart';
import 'package:flutter_thailand_provinces_example/widgets/zip_code_list.dart';
import 'package:flutter_thailand_provinces/flutter_thailand_provinces.dart';

class SearchAddressBottomSheet extends StatefulWidget {
  const SearchAddressBottomSheet({Key? key}) : super(key: key);

  @override
  _SearchAddressBottomSheetState createState() =>
      _SearchAddressBottomSheetState();
}

class _SearchAddressBottomSheetState extends State<SearchAddressBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  List<AddressDao> listAddresses = [];
  AddressDao addressDao = AddressDao();
  String zipCode = '';

  String keyword = '';

  final PageController _pageController = PageController();

  Future<void> _init() async {}

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _onSearch(String keyword) async {
    // print(search);
    final result = await AddressProvider.search(keyword: keyword);
    setState(() {
      this.keyword = keyword;
      listAddresses = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            'Search Address Bottom Sheet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              onChanged: _onSearch,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Search Address',
                prefixIcon: Icon(Icons.search),
                fillColor: Theme.of(context).primaryColorLight,
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _onSearch('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
          ),
          if (keyword.isEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '${addressDao.province?.nameEn ?? ''}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (addressDao.amphure != null) ...[
                      Text(
                        ' > ${addressDao.amphure?.nameEn}',
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                    if (addressDao.district != null) ...[
                      Text(
                        ' > ${addressDao.district?.nameEn}',
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                    if (zipCode.isNotEmpty) ...[
                      Text(
                        ' > $zipCode',
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  ],
                ),
              ),
            ),
          (keyword.isNotEmpty)
              ? Expanded(
                  child: AddressList(
                  addressList: listAddresses,
                  onSelected: (address) {
                    Navigator.pop(
                        context,
                        Address(
                          province: address.province,
                          amphure: address.amphure,
                          district: address.district,
                          zipCode: address.district?.zipCode,
                        ));
                  },
                ))
              : Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      ProvinceList(
                        onSelected: (province) {
                          print(province.nameEn);
                          setState(() {
                            addressDao.province = province;
                          });
                          _pageController.jumpToPage(1);
                        },
                      ),
                      AmpureList(
                        province: addressDao.province,
                        onSelected: (amphure) {
                          print(amphure.nameEn);
                          setState(() {
                            addressDao.amphure = amphure;
                          });
                          _pageController.jumpToPage(2);
                        },
                      ),
                      DistrictList(
                        amphure: addressDao.amphure,
                        onSelected: (district) {
                          print(district.nameEn);
                          setState(() {
                            addressDao.district = district;
                          });
                          _pageController.jumpToPage(3);
                        },
                      ),
                      ZipCodeList(
                        district: addressDao.district,
                        onSelected: (zipCode) {
                          setState(() {
                            this.zipCode = zipCode;
                          });

                          Navigator.pop(
                            context,
                            Address(
                              province: addressDao.province,
                              amphure: addressDao.amphure,
                              district: addressDao.district,
                              zipCode: zipCode,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class Address {
  final ProvinceDao? province;
  final AmphureDao? amphure;
  final DistrictDao? district;
  final String? zipCode;

  Address({
    this.province,
    this.amphure,
    this.district,
    this.zipCode,
  });

  String get address {
    return [
      province?.nameEn ?? 'Province',
      amphure?.nameEn ?? 'Amphure',
      district?.nameEn ?? 'District',
      zipCode ?? 'Zip Code',
    ].join('\n');
  }
}
