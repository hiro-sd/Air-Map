// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'polygon_drawing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PolygonDrawingState {
  Set<Polygon> get polygonSet => throw _privateConstructorUsedError;
  HashSet<Polyline> get polylineSet => throw _privateConstructorUsedError;
  List<LatLng> get latLngList => throw _privateConstructorUsedError;
  int? get lastXCoordinate => throw _privateConstructorUsedError;
  int? get lastYCoordinate => throw _privateConstructorUsedError;

  /// Create a copy of PolygonDrawingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PolygonDrawingStateCopyWith<PolygonDrawingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PolygonDrawingStateCopyWith<$Res> {
  factory $PolygonDrawingStateCopyWith(
          PolygonDrawingState value, $Res Function(PolygonDrawingState) then) =
      _$PolygonDrawingStateCopyWithImpl<$Res, PolygonDrawingState>;
  @useResult
  $Res call(
      {Set<Polygon> polygonSet,
      HashSet<Polyline> polylineSet,
      List<LatLng> latLngList,
      int? lastXCoordinate,
      int? lastYCoordinate});
}

/// @nodoc
class _$PolygonDrawingStateCopyWithImpl<$Res, $Val extends PolygonDrawingState>
    implements $PolygonDrawingStateCopyWith<$Res> {
  _$PolygonDrawingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PolygonDrawingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? polygonSet = null,
    Object? polylineSet = null,
    Object? latLngList = null,
    Object? lastXCoordinate = freezed,
    Object? lastYCoordinate = freezed,
  }) {
    return _then(_value.copyWith(
      polygonSet: null == polygonSet
          ? _value.polygonSet
          : polygonSet // ignore: cast_nullable_to_non_nullable
              as Set<Polygon>,
      polylineSet: null == polylineSet
          ? _value.polylineSet
          : polylineSet // ignore: cast_nullable_to_non_nullable
              as HashSet<Polyline>,
      latLngList: null == latLngList
          ? _value.latLngList
          : latLngList // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      lastXCoordinate: freezed == lastXCoordinate
          ? _value.lastXCoordinate
          : lastXCoordinate // ignore: cast_nullable_to_non_nullable
              as int?,
      lastYCoordinate: freezed == lastYCoordinate
          ? _value.lastYCoordinate
          : lastYCoordinate // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PolygonDrawingStateImplCopyWith<$Res>
    implements $PolygonDrawingStateCopyWith<$Res> {
  factory _$$PolygonDrawingStateImplCopyWith(_$PolygonDrawingStateImpl value,
          $Res Function(_$PolygonDrawingStateImpl) then) =
      __$$PolygonDrawingStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Set<Polygon> polygonSet,
      HashSet<Polyline> polylineSet,
      List<LatLng> latLngList,
      int? lastXCoordinate,
      int? lastYCoordinate});
}

/// @nodoc
class __$$PolygonDrawingStateImplCopyWithImpl<$Res>
    extends _$PolygonDrawingStateCopyWithImpl<$Res, _$PolygonDrawingStateImpl>
    implements _$$PolygonDrawingStateImplCopyWith<$Res> {
  __$$PolygonDrawingStateImplCopyWithImpl(_$PolygonDrawingStateImpl _value,
      $Res Function(_$PolygonDrawingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PolygonDrawingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? polygonSet = null,
    Object? polylineSet = null,
    Object? latLngList = null,
    Object? lastXCoordinate = freezed,
    Object? lastYCoordinate = freezed,
  }) {
    return _then(_$PolygonDrawingStateImpl(
      polygonSet: null == polygonSet
          ? _value._polygonSet
          : polygonSet // ignore: cast_nullable_to_non_nullable
              as Set<Polygon>,
      polylineSet: null == polylineSet
          ? _value.polylineSet
          : polylineSet // ignore: cast_nullable_to_non_nullable
              as HashSet<Polyline>,
      latLngList: null == latLngList
          ? _value._latLngList
          : latLngList // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
      lastXCoordinate: freezed == lastXCoordinate
          ? _value.lastXCoordinate
          : lastXCoordinate // ignore: cast_nullable_to_non_nullable
              as int?,
      lastYCoordinate: freezed == lastYCoordinate
          ? _value.lastYCoordinate
          : lastYCoordinate // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$PolygonDrawingStateImpl implements _PolygonDrawingState {
  const _$PolygonDrawingStateImpl(
      {required final Set<Polygon> polygonSet,
      required this.polylineSet,
      required final List<LatLng> latLngList,
      this.lastXCoordinate,
      this.lastYCoordinate})
      : _polygonSet = polygonSet,
        _latLngList = latLngList;

  final Set<Polygon> _polygonSet;
  @override
  Set<Polygon> get polygonSet {
    if (_polygonSet is EqualUnmodifiableSetView) return _polygonSet;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_polygonSet);
  }

  @override
  final HashSet<Polyline> polylineSet;
  final List<LatLng> _latLngList;
  @override
  List<LatLng> get latLngList {
    if (_latLngList is EqualUnmodifiableListView) return _latLngList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_latLngList);
  }

  @override
  final int? lastXCoordinate;
  @override
  final int? lastYCoordinate;

  @override
  String toString() {
    return 'PolygonDrawingState(polygonSet: $polygonSet, polylineSet: $polylineSet, latLngList: $latLngList, lastXCoordinate: $lastXCoordinate, lastYCoordinate: $lastYCoordinate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PolygonDrawingStateImpl &&
            const DeepCollectionEquality()
                .equals(other._polygonSet, _polygonSet) &&
            const DeepCollectionEquality()
                .equals(other.polylineSet, polylineSet) &&
            const DeepCollectionEquality()
                .equals(other._latLngList, _latLngList) &&
            (identical(other.lastXCoordinate, lastXCoordinate) ||
                other.lastXCoordinate == lastXCoordinate) &&
            (identical(other.lastYCoordinate, lastYCoordinate) ||
                other.lastYCoordinate == lastYCoordinate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_polygonSet),
      const DeepCollectionEquality().hash(polylineSet),
      const DeepCollectionEquality().hash(_latLngList),
      lastXCoordinate,
      lastYCoordinate);

  /// Create a copy of PolygonDrawingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PolygonDrawingStateImplCopyWith<_$PolygonDrawingStateImpl> get copyWith =>
      __$$PolygonDrawingStateImplCopyWithImpl<_$PolygonDrawingStateImpl>(
          this, _$identity);
}

abstract class _PolygonDrawingState implements PolygonDrawingState {
  const factory _PolygonDrawingState(
      {required final Set<Polygon> polygonSet,
      required final HashSet<Polyline> polylineSet,
      required final List<LatLng> latLngList,
      final int? lastXCoordinate,
      final int? lastYCoordinate}) = _$PolygonDrawingStateImpl;

  @override
  Set<Polygon> get polygonSet;
  @override
  HashSet<Polyline> get polylineSet;
  @override
  List<LatLng> get latLngList;
  @override
  int? get lastXCoordinate;
  @override
  int? get lastYCoordinate;

  /// Create a copy of PolygonDrawingState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PolygonDrawingStateImplCopyWith<_$PolygonDrawingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
