import 'dart:async';
import 'dart:typed_data';

import 'package:check_object/core/local_api_service.dart';
import 'package:check_object/core/remote_api_service.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:check_object/model/house_object.dart';
import 'package:check_object/multiselect_page.dart';
import 'package:check_object/providers/house_objects.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final GlobalKey _refreshIndicatorKey = GlobalKey();

  late List<HouseObject> dataList;
  bool loading = false;
  bool loaded = false;

  Future<List<HouseObject>> fetchData() async {
    final Excel excel = await LocalApiService().fromFile(FileTypeApi.xlsx);
    final List<HouseObject> newdataList = createDataList(excel);
    context.read<HouseObjects>().addAll(newdataList);
    return newdataList;
  }

  @override
  void initState() {
    dataList = context.read<HouseObjects>().houseObjects;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          _reload();
          setState(() {});
        },
        child: FutureBuilder<List<HouseObject>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Не удалось получить файлы с сервера!'),
                    TextButton(
                      onPressed: () async {
                        final Uint8List byteData = await RemoteApiService().getData();
                        if (byteData.isNotEmpty) {
                          await LocalApiService().saveFile(byteData: byteData);
                        }
                        _reload();
                      },
                      child: const Text('Попробовать еще раз'),
                    ),
                  ],
                ),
              );
            } else {
              return const MultiselectPage();
            }
          },
        ),
      ),
    );
  }

  List<HouseObject> createDataList(Excel excel) {
    List<HouseObject> houseObjects = [];
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        if ((row[1]?.rowIndex ?? 0) == 0) {
          continue;
        }
        final String service = row[1]?.value.toString() ?? '';
        final String shortService = row[2]?.value.toString() ?? '';
        final String location = row[5]?.value.toString() ?? '';
        final String shortLocation = row[6]?.value.toString() ?? '';
        final String period = row[9]?.value.toString() ?? '';

        final HouseObject houseObject = HouseObject(
          county: table,
          service: service,
          shortService: shortService,
          location: location,
          shortLocation: shortLocation,
          period: period,
        );
        houseObjects.add(houseObject);
      }
    }
    return houseObjects;
  }

  void _reload() {
    setState(() {});
  }
}
