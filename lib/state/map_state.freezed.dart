// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MapState {
  Set<Marker> get markers => throw _privateConstructorUsedError;
  Set<Marker> get departureMarkers => throw _privateConstructorUsedError;
  Set<Marker> get destinationMarkers => throw _privateConstructorUsedError;
  CameraPosition get initialCenter => throw _privateConstructorUsedError;
  bool get showAllAirports => throw _privateConstructorUsedError;
  String? get selectedDeparture => throw _privateConstructorUsedError;
  String? get selectedDestination => throw _privateConstructorUsedError;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapStateCopyWith<MapState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapStateCopyWith<$Res> {
  factory $MapStateCopyWith(MapState value, $Res Function(MapState) then) =
      _$MapStateCopyWithImpl<$Res, MapState>;
  @useResult
  $Res call(
      {Set<Marker> markers,
      Set<Marker> departureMarkers,
      Set<Marker> destinationMarkers,
      CameraPosition initialCenter,
      bool showAllAirports,
      String? selectedDeparture,
      String? selectedDestination});
}

/// @nodoc
class _$MapStateCopyWithImpl<$Res, $Val extends MapState>
    implements $MapStateCopyWith<$Res> {
  _$MapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? markers = null,
    Object? departureMarkers = null,
    Object? destinationMarkers = null,
    Object? initialCenter = null,
    Object? showAllAirports = null,
    Object? selectedDeparture = freezed,
    Object? selectedDestination = freezed,
  }) {
    return _then(_value.copyWith(
      markers: null == markers
          ? _value.markers
          : markers // ignore: cast_nullable_to_non_nullable
              as Set<Marker>,
      departureMarkers: null == departureMarkers
          ? _value.departureMarkers
          : departureMarkers // ignore: cast_nullable_to_non_nullable
              as Set<Marker>,
      destinationMarkers: null == destinationMarkers
          ? _value.destinationMarkers
          : destinationMarkers // ignore: cast_nullable_to_non_nullable
              as Set<Marker>,
      initialCenter: null == initialCenter
          ? _value.initialCenter
          : initialCenter // ignore: cast_nullable_to_non_nullable
              as CameraPosition,
      showAllAirports: null == showAllAirports
          ? _value.showAllAirports
          : showAllAirports // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedDeparture: freezed == selectedDeparture
          ? _value.selectedDeparture
          : selectedDeparture // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDestination: freezed == selectedDestination
          ? _value.selectedDestination
          : selectedDestination // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MapStateImplCopyWith<$Res>
    implements $MapStateCopyWith<$Res> {
  factory _$$MapStateImplCopyWith(
          _$MapStateImpl value, $Res Function(_$MapStateImpl) then) =
      __$$MapStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Set<Marker> markers,
      Set<Marker> departureMarkers,
      Set<Marker> destinationMarkers,
      CameraPosition initialCenter,
      bool showAllAirports,
      String? selectedDeparture,
      String? selectedDestination});
}

/// @nodoc
class __$$MapStateImplCopyWithImpl<$Res>
    extends _$MapStateCopyWithImpl<$Res, _$MapStateImpl>
    implements _$$MapStateImplCopyWith<$Res> {
  __$$MapStateImplCopyWithImpl(
      _$MapStateImpl _value, $Res Function(_$MapStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? markers = null,
    Object? departureMarkers = null,
    Object? destinationMarkers = null,
    Object? initialCenter = null,
    Object? showAllAirports = null,
    Object? selectedDeparture = freezed,
    Object? selectedDestination = freezed,
  }) {
    return _then(_$MapStateImpl(
      markers: null == markers
          ? _value._markers
          : markers // ignore: cast_nullable_to_non_nullable
              as Set<Marker>,
      departureMarkers: null == departureMarkers
          ? _value._departureMarkers
          : departureMarkers // ignore: cast_nullable_to_non_nullable
              as Set<Marker>,
      destinationMarkers: null == destinationMarkers
          ? _value._destinationMarkers
          : destinationMarkers // ignore: cast_nullable_to_non_nullable
              as Set<Marker>,
      initialCenter: null == initialCenter
          ? _value.initialCenter
          : initialCenter // ignore: cast_nullable_to_non_nullable
              as CameraPosition,
      showAllAirports: null == showAllAirports
          ? _value.showAllAirports
          : showAllAirports // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedDeparture: freezed == selectedDeparture
          ? _value.selectedDeparture
          : selectedDeparture // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDestination: freezed == selectedDestination
          ? _value.selectedDestination
          : selectedDestination // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MapStateImpl implements _MapState {
  const _$MapStateImpl(
      {required final Set<Marker> markers,
      required final Set<Marker> departureMarkers,
      required final Set<Marker> destinationMarkers,
      required this.initialCenter,
      required this.showAllAirports,
      this.selectedDeparture,
      this.selectedDestination})
      : _markers = markers,
        _departureMarkers = departureMarkers,
        _destinationMarkers = destinationMarkers;

  final Set<Marker> _markers;
  @override
  Set<Marker> get markers {
    if (_markers is EqualUnmodifiableSetView) return _markers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_markers);
  }

  final Set<Marker> _departureMarkers;
  @override
  Set<Marker> get departureMarkers {
    if (_departureMarkers is EqualUnmodifiableSetView) return _departureMarkers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_departureMarkers);
  }

  final Set<Marker> _destinationMarkers;
  @override
  Set<Marker> get destinationMarkers {
    if (_destinationMarkers is EqualUnmodifiableSetView)
      return _destinationMarkers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_destinationMarkers);
  }

  @override
  final CameraPosition initialCenter;
  @override
  final bool showAllAirports;
  @override
  final String? selectedDeparture;
  @override
  final String? selectedDestination;

  @override
  String toString() {
    return 'MapState(markers: $markers, departureMarkers: $departureMarkers, destinationMarkers: $destinationMarkers, initialCenter: $initialCenter, showAllAirports: $showAllAirports, selectedDeparture: $selectedDeparture, selectedDestination: $selectedDestination)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapStateImpl &&
            const DeepCollectionEquality().equals(other._markers, _markers) &&
            const DeepCollectionEquality()
                .equals(other._departureMarkers, _departureMarkers) &&
            const DeepCollectionEquality()
                .equals(other._destinationMarkers, _destinationMarkers) &&
            (identical(other.initialCenter, initialCenter) ||
                other.initialCenter == initialCenter) &&
            (identical(other.showAllAirports, showAllAirports) ||
                other.showAllAirports == showAllAirports) &&
            (identical(other.selectedDeparture, selectedDeparture) ||
                other.selectedDeparture == selectedDeparture) &&
            (identical(other.selectedDestination, selectedDestination) ||
                other.selectedDestination == selectedDestination));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_markers),
      const DeepCollectionEquality().hash(_departureMarkers),
      const DeepCollectionEquality().hash(_destinationMarkers),
      initialCenter,
      showAllAirports,
      selectedDeparture,
      selectedDestination);

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapStateImplCopyWith<_$MapStateImpl> get copyWith =>
      __$$MapStateImplCopyWithImpl<_$MapStateImpl>(this, _$identity);
}

abstract class _MapState implements MapState {
  const factory _MapState(
      {required final Set<Marker> markers,
      required final Set<Marker> departureMarkers,
      required final Set<Marker> destinationMarkers,
      required final CameraPosition initialCenter,
      required final bool showAllAirports,
      final String? selectedDeparture,
      final String? selectedDestination}) = _$MapStateImpl;

  @override
  Set<Marker> get markers;
  @override
  Set<Marker> get departureMarkers;
  @override
  Set<Marker> get destinationMarkers;
  @override
  CameraPosition get initialCenter;
  @override
  bool get showAllAirports;
  @override
  String? get selectedDeparture;
  @override
  String? get selectedDestination;

  /// Create a copy of MapState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapStateImplCopyWith<_$MapStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
