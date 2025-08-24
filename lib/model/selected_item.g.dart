// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SelectedItemsImpl _$$SelectedItemsImplFromJson(Map<String, dynamic> json) =>
    _$SelectedItemsImpl(
      selectedItems: (json['selectedItems'] as List<dynamic>)
          .map((e) => SelectedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SelectedItemsImplToJson(_$SelectedItemsImpl instance) =>
    <String, dynamic>{
      'selectedItems': instance.selectedItems,
    };

_$SelectedItemImpl _$$SelectedItemImplFromJson(Map<String, dynamic> json) =>
    _$SelectedItemImpl(
      data: (json['data'] as List<dynamic>).map((e) => e as String).toList(),
      pointFile: PointFile.fromJson(json['pointFile'] as String),
    );

Map<String, dynamic> _$$SelectedItemImplToJson(_$SelectedItemImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pointFile': instance.pointFile,
    };
