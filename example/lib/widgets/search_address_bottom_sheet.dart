import 'package:flutter/material.dart';
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
  AddressDao addressDao = AddressDao();
  String zipCode = '';

  final PageController _pageController = PageController();

  Future<void> _init() async {}

  @override
  void initState() {
    super.initState();
    _init();
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
              decoration: InputDecoration(
                // filled: true,
                hintText: 'Search Address',
                prefixIcon: Icon(Icons.search),
                fillColor: Theme.of(context).primaryColorLight,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
          ),
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
          Expanded(
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
                    print(zipCode);
                    setState(() {
                      this.zipCode = zipCode;
                    });
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
}
