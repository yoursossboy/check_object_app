import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:check_object/model/point_file.dart';

part 'selected_item.freezed.dart';
part 'selected_item.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class SelectedItems with _$SelectedItems {
  const factory SelectedItems({
    required List<SelectedItem> selectedItems,
  }) = _SelectedItems;

  factory SelectedItems.fromList(List list) {
    return SelectedItems(
      selectedItems: list
          .map((e) => SelectedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory SelectedItems.fromJson(Map<String, dynamic> json) =>
      _$SelectedItemsFromJson(json);
}

@unfreezed
class SelectedItem with _$SelectedItem {
  factory SelectedItem({
    required final List<String> data,
    required final PointFile pointFile,
  }) = _SelectedItem;

  factory SelectedItem.fromJson(Map<String, dynamic> json) =>
      _$SelectedItemFromJson(json);
}