import 'package:flutter/material.dart';
import 'package:check_object/model/house_object.dart';
import 'package:check_object/providers/multi_select_provider.dart';
import 'package:check_object/multiselect_dialog.dart';
import 'package:check_object/pages/camera_page.dart';
import 'package:check_object/providers/house_objects.dart';
import 'package:provider/provider.dart';

class SelectData extends StatelessWidget {
  final TextStyle dialogTextStyle;
  final Color? checkColor;
  final Color? activeColor;
  final VoidCallback saveForm;
  final Function(bool)? onDone;

  const SelectData({
    super.key,
    this.dialogTextStyle = const TextStyle(),
    this.activeColor,
    this.checkColor,
    required this.saveForm,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final selectedData = context.read<MultiSelectProvider>().data;
    final dataList = context.read<HouseObjects>().houseObjects;
    List? initialSelected = selectedData;

    final items = <MultiSelectDialogItem<dynamic>>[];
    final dataItems = [];

    if (initialSelected.isEmpty) {
      final Set<String> seen = <String>{};
      dataList.where((e) => seen.add(e.county)).toList();
      dataItems
        ..clear()
        ..addAll(seen.toList());
    } else if (initialSelected.length == 1) {
      final List<HouseObject> selectedRows =
          dataList.where((e) => e.county == initialSelected[0]).toList();
      final Set<String> seen = <String>{};
      selectedRows.where((e) => seen.add(e.shortService)).toList();
      dataItems
        ..clear()
        ..addAll(seen.toList());
    } else if (initialSelected.length == 2) {
      final List<HouseObject> selectedRows =
          dataList.where((e) => e.shortService == initialSelected[1]).toList();
      final Set<String> seen = <String>{};
      selectedRows.where((e) => seen.add(e.shortLocation)).toList();
      dataItems
        ..clear()
        ..addAll(seen.toList());
    }

    for (var item in dataItems) {
      items.add(MultiSelectDialogItem(item, false));
    }

    if (items.isNotEmpty) {
      return MultiSelectDialog(
        items: items,
        initialSelectedValues: initialSelected,
        labelStyle: dialogTextStyle,
        activeColor: activeColor,
        checkColor: checkColor,
        saveForm: saveForm,
      );
    } else {
      if (dataList.isNotEmpty) {
        return CameraPage(
          saveForm: saveForm,
          onDone: onDone,
        );
      } else {
        return const Center(child: Text('Загрузите объекты'));
      }
    }
  }
}
