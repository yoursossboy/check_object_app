// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SelectedItems _$SelectedItemsFromJson(Map<String, dynamic> json) {
  return _SelectedItems.fromJson(json);
}

/// @nodoc
mixin _$SelectedItems {
  List<SelectedItem> get selectedItems => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SelectedItemsCopyWith<SelectedItems> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectedItemsCopyWith<$Res> {
  factory $SelectedItemsCopyWith(
          SelectedItems value, $Res Function(SelectedItems) then) =
      _$SelectedItemsCopyWithImpl<$Res, SelectedItems>;
  @useResult
  $Res call({List<SelectedItem> selectedItems});
}

/// @nodoc
class _$SelectedItemsCopyWithImpl<$Res, $Val extends SelectedItems>
    implements $SelectedItemsCopyWith<$Res> {
  _$SelectedItemsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedItems = null,
  }) {
    return _then(_value.copyWith(
      selectedItems: null == selectedItems
          ? _value.selectedItems
          : selectedItems // ignore: cast_nullable_to_non_nullable
              as List<SelectedItem>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SelectedItemsImplCopyWith<$Res>
    implements $SelectedItemsCopyWith<$Res> {
  factory _$$SelectedItemsImplCopyWith(
          _$SelectedItemsImpl value, $Res Function(_$SelectedItemsImpl) then) =
      __$$SelectedItemsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SelectedItem> selectedItems});
}

/// @nodoc
class __$$SelectedItemsImplCopyWithImpl<$Res>
    extends _$SelectedItemsCopyWithImpl<$Res, _$SelectedItemsImpl>
    implements _$$SelectedItemsImplCopyWith<$Res> {
  __$$SelectedItemsImplCopyWithImpl(
      _$SelectedItemsImpl _value, $Res Function(_$SelectedItemsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedItems = null,
  }) {
    return _then(_$SelectedItemsImpl(
      selectedItems: null == selectedItems
          ? _value.selectedItems
          : selectedItems // ignore: cast_nullable_to_non_nullable
              as List<SelectedItem>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectedItemsImpl implements _SelectedItems {
  const _$SelectedItemsImpl({required this.selectedItems});

  factory _$SelectedItemsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectedItemsImplFromJson(json);

  @override
  final List<SelectedItem> selectedItems;

  @override
  String toString() {
    return 'SelectedItems(selectedItems: $selectedItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectedItemsImpl &&
            const DeepCollectionEquality()
                .equals(other.selectedItems, selectedItems));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(selectedItems));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedItemsImplCopyWith<_$SelectedItemsImpl> get copyWith =>
      __$$SelectedItemsImplCopyWithImpl<_$SelectedItemsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectedItemsImplToJson(
      this,
    );
  }
}

abstract class _SelectedItems implements SelectedItems {
  const factory _SelectedItems(
      {required final List<SelectedItem> selectedItems}) = _$SelectedItemsImpl;

  factory _SelectedItems.fromJson(Map<String, dynamic> json) =
      _$SelectedItemsImpl.fromJson;

  @override
  List<SelectedItem> get selectedItems;
  @override
  @JsonKey(ignore: true)
  _$$SelectedItemsImplCopyWith<_$SelectedItemsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SelectedItem _$SelectedItemFromJson(Map<String, dynamic> json) {
  return _SelectedItem.fromJson(json);
}

/// @nodoc
mixin _$SelectedItem {
  List<String> get data => throw _privateConstructorUsedError;
  PointFile get pointFile => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SelectedItemCopyWith<SelectedItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectedItemCopyWith<$Res> {
  factory $SelectedItemCopyWith(
          SelectedItem value, $Res Function(SelectedItem) then) =
      _$SelectedItemCopyWithImpl<$Res, SelectedItem>;
  @useResult
  $Res call({List<String> data, PointFile pointFile});
}

/// @nodoc
class _$SelectedItemCopyWithImpl<$Res, $Val extends SelectedItem>
    implements $SelectedItemCopyWith<$Res> {
  _$SelectedItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? pointFile = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pointFile: null == pointFile
          ? _value.pointFile
          : pointFile // ignore: cast_nullable_to_non_nullable
              as PointFile,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SelectedItemImplCopyWith<$Res>
    implements $SelectedItemCopyWith<$Res> {
  factory _$$SelectedItemImplCopyWith(
          _$SelectedItemImpl value, $Res Function(_$SelectedItemImpl) then) =
      __$$SelectedItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> data, PointFile pointFile});
}

/// @nodoc
class __$$SelectedItemImplCopyWithImpl<$Res>
    extends _$SelectedItemCopyWithImpl<$Res, _$SelectedItemImpl>
    implements _$$SelectedItemImplCopyWith<$Res> {
  __$$SelectedItemImplCopyWithImpl(
      _$SelectedItemImpl _value, $Res Function(_$SelectedItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? pointFile = null,
  }) {
    return _then(_$SelectedItemImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pointFile: null == pointFile
          ? _value.pointFile
          : pointFile // ignore: cast_nullable_to_non_nullable
              as PointFile,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SelectedItemImpl implements _SelectedItem {
  _$SelectedItemImpl({required this.data, required this.pointFile});

  factory _$SelectedItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectedItemImplFromJson(json);

  @override
  final List<String> data;
  @override
  final PointFile pointFile;

  @override
  String toString() {
    return 'SelectedItem(data: $data, pointFile: $pointFile)';
  }

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedItemImplCopyWith<_$SelectedItemImpl> get copyWith =>
      __$$SelectedItemImplCopyWithImpl<_$SelectedItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectedItemImplToJson(
      this,
    );
  }
}

abstract class _SelectedItem implements SelectedItem {
  factory _SelectedItem(
      {required final List<String> data,
      required final PointFile pointFile}) = _$SelectedItemImpl;

  factory _SelectedItem.fromJson(Map<String, dynamic> json) =
      _$SelectedItemImpl.fromJson;

  @override
  List<String> get data;
  @override
  PointFile get pointFile;
  @override
  @JsonKey(ignore: true)
  _$$SelectedItemImplCopyWith<_$SelectedItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
