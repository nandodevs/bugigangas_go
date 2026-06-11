// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'package_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PackageModel _$PackageModelFromJson(Map<String, dynamic> json) {
  return _PackageModel.fromJson(json);
}

/// @nodoc
mixin _$PackageModel {
  String get code => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<TrackingEvent> get events => throw _privateConstructorUsedError;
  DateTime? get lastUpdate => throw _privateConstructorUsedError;
  String? get origin => throw _privateConstructorUsedError;
  String? get destination => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get archived => throw _privateConstructorUsedError;
  String? get carrier => throw _privateConstructorUsedError;
  String? get packageType => throw _privateConstructorUsedError;
  String? get packageCategory => throw _privateConstructorUsedError;
  DateTime? get estimatedDelivery => throw _privateConstructorUsedError;
  bool get delayed => throw _privateConstructorUsedError;
  bool get lockerDelivery => throw _privateConstructorUsedError;

  /// Serializes this PackageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PackageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PackageModelCopyWith<PackageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PackageModelCopyWith<$Res> {
  factory $PackageModelCopyWith(
    PackageModel value,
    $Res Function(PackageModel) then,
  ) = _$PackageModelCopyWithImpl<$Res, PackageModel>;
  @useResult
  $Res call({
    String code,
    String status,
    String description,
    List<TrackingEvent> events,
    DateTime? lastUpdate,
    String? origin,
    String? destination,
    List<String> tags,
    bool archived,
    String? carrier,
    String? packageType,
    String? packageCategory,
    DateTime? estimatedDelivery,
    bool delayed,
    bool lockerDelivery,
  });
}

/// @nodoc
class _$PackageModelCopyWithImpl<$Res, $Val extends PackageModel>
    implements $PackageModelCopyWith<$Res> {
  _$PackageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PackageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? status = null,
    Object? description = null,
    Object? events = null,
    Object? lastUpdate = freezed,
    Object? origin = freezed,
    Object? destination = freezed,
    Object? tags = null,
    Object? archived = null,
    Object? carrier = freezed,
    Object? packageType = freezed,
    Object? packageCategory = freezed,
    Object? estimatedDelivery = freezed,
    Object? delayed = null,
    Object? lockerDelivery = null,
  }) {
    return _then(
      _value.copyWith(
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            events: null == events
                ? _value.events
                : events // ignore: cast_nullable_to_non_nullable
                      as List<TrackingEvent>,
            lastUpdate: freezed == lastUpdate
                ? _value.lastUpdate
                : lastUpdate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            origin: freezed == origin
                ? _value.origin
                : origin // ignore: cast_nullable_to_non_nullable
                      as String?,
            destination: freezed == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            archived: null == archived
                ? _value.archived
                : archived // ignore: cast_nullable_to_non_nullable
                      as bool,
            carrier: freezed == carrier
                ? _value.carrier
                : carrier // ignore: cast_nullable_to_non_nullable
                      as String?,
            packageType: freezed == packageType
                ? _value.packageType
                : packageType // ignore: cast_nullable_to_non_nullable
                      as String?,
            packageCategory: freezed == packageCategory
                ? _value.packageCategory
                : packageCategory // ignore: cast_nullable_to_non_nullable
                      as String?,
            estimatedDelivery: freezed == estimatedDelivery
                ? _value.estimatedDelivery
                : estimatedDelivery // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            delayed: null == delayed
                ? _value.delayed
                : delayed // ignore: cast_nullable_to_non_nullable
                      as bool,
            lockerDelivery: null == lockerDelivery
                ? _value.lockerDelivery
                : lockerDelivery // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PackageModelImplCopyWith<$Res>
    implements $PackageModelCopyWith<$Res> {
  factory _$$PackageModelImplCopyWith(
    _$PackageModelImpl value,
    $Res Function(_$PackageModelImpl) then,
  ) = __$$PackageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String code,
    String status,
    String description,
    List<TrackingEvent> events,
    DateTime? lastUpdate,
    String? origin,
    String? destination,
    List<String> tags,
    bool archived,
    String? carrier,
    String? packageType,
    String? packageCategory,
    DateTime? estimatedDelivery,
    bool delayed,
    bool lockerDelivery,
  });
}

/// @nodoc
class __$$PackageModelImplCopyWithImpl<$Res>
    extends _$PackageModelCopyWithImpl<$Res, _$PackageModelImpl>
    implements _$$PackageModelImplCopyWith<$Res> {
  __$$PackageModelImplCopyWithImpl(
    _$PackageModelImpl _value,
    $Res Function(_$PackageModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PackageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? status = null,
    Object? description = null,
    Object? events = null,
    Object? lastUpdate = freezed,
    Object? origin = freezed,
    Object? destination = freezed,
    Object? tags = null,
    Object? archived = null,
    Object? carrier = freezed,
    Object? packageType = freezed,
    Object? packageCategory = freezed,
    Object? estimatedDelivery = freezed,
    Object? delayed = null,
    Object? lockerDelivery = null,
  }) {
    return _then(
      _$PackageModelImpl(
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        events: null == events
            ? _value._events
            : events // ignore: cast_nullable_to_non_nullable
                  as List<TrackingEvent>,
        lastUpdate: freezed == lastUpdate
            ? _value.lastUpdate
            : lastUpdate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        origin: freezed == origin
            ? _value.origin
            : origin // ignore: cast_nullable_to_non_nullable
                  as String?,
        destination: freezed == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        archived: null == archived
            ? _value.archived
            : archived // ignore: cast_nullable_to_non_nullable
                  as bool,
        carrier: freezed == carrier
            ? _value.carrier
            : carrier // ignore: cast_nullable_to_non_nullable
                  as String?,
        packageType: freezed == packageType
            ? _value.packageType
            : packageType // ignore: cast_nullable_to_non_nullable
                  as String?,
        packageCategory: freezed == packageCategory
            ? _value.packageCategory
            : packageCategory // ignore: cast_nullable_to_non_nullable
                  as String?,
        estimatedDelivery: freezed == estimatedDelivery
            ? _value.estimatedDelivery
            : estimatedDelivery // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        delayed: null == delayed
            ? _value.delayed
            : delayed // ignore: cast_nullable_to_non_nullable
                  as bool,
        lockerDelivery: null == lockerDelivery
            ? _value.lockerDelivery
            : lockerDelivery // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PackageModelImpl implements _PackageModel {
  const _$PackageModelImpl({
    required this.code,
    required this.status,
    required this.description,
    final List<TrackingEvent> events = const [],
    this.lastUpdate,
    this.origin,
    this.destination,
    final List<String> tags = const [],
    this.archived = false,
    this.carrier,
    this.packageType,
    this.packageCategory,
    this.estimatedDelivery,
    this.delayed = false,
    this.lockerDelivery = false,
  })  : _events = events,
        _tags = tags;

  factory _$PackageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PackageModelImplFromJson(json);

  @override
  final String code;
  @override
  final String status;
  @override
  final String description;
  final List<TrackingEvent> _events;
  @override
  @JsonKey()
  List<TrackingEvent> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  final DateTime? lastUpdate;
  @override
  final String? origin;
  @override
  final String? destination;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final bool archived;
  @override
  final String? carrier;
  @override
  final String? packageType;
  @override
  final String? packageCategory;
  @override
  final DateTime? estimatedDelivery;
  @override
  final bool delayed;
  @override
  final bool lockerDelivery;

  @override
  String toString() {
    return 'PackageModel(code: $code, status: $status, description: $description, events: $events, lastUpdate: $lastUpdate, origin: $origin, destination: $destination, tags: $tags, archived: $archived, carrier: $carrier, packageType: $packageType, packageCategory: $packageCategory, estimatedDelivery: $estimatedDelivery, delayed: $delayed, lockerDelivery: $lockerDelivery)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PackageModelImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            (identical(other.lastUpdate, lastUpdate) ||
                other.lastUpdate == lastUpdate) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.archived, archived) ||
                other.archived == archived) &&
            (identical(other.carrier, carrier) || other.carrier == carrier) &&
            (identical(other.packageType, packageType) ||
                other.packageType == packageType) &&
            (identical(other.packageCategory, packageCategory) ||
                other.packageCategory == packageCategory) &&
            (identical(other.estimatedDelivery, estimatedDelivery) ||
                other.estimatedDelivery == estimatedDelivery) &&
            (identical(other.delayed, delayed) || other.delayed == delayed) &&
            (identical(other.lockerDelivery, lockerDelivery) ||
                other.lockerDelivery == lockerDelivery));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
        runtimeType,
        code,
        status,
        description,
        const DeepCollectionEquality().hash(_events),
        lastUpdate,
        origin,
        destination,
        const DeepCollectionEquality().hash(_tags),
        archived,
        carrier,
        packageType,
        packageCategory,
        estimatedDelivery,
        delayed,
        lockerDelivery,
      );

  /// Create a copy of PackageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PackageModelImplCopyWith<_$PackageModelImpl> get copyWith =>
      __$$PackageModelImplCopyWithImpl<_$PackageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PackageModelImplToJson(this);
  }
}

abstract class _PackageModel implements PackageModel {
  const factory _PackageModel({
    required final String code,
    required final String status,
    required final String description,
    final List<TrackingEvent> events,
    final DateTime? lastUpdate,
    final String? origin,
    final String? destination,
    final List<String> tags,
    final bool archived,
    final String? carrier,
    final String? packageType,
    final String? packageCategory,
    final DateTime? estimatedDelivery,
    final bool delayed,
    final bool lockerDelivery,
  }) = _$PackageModelImpl;

  factory _PackageModel.fromJson(Map<String, dynamic> json) =
      _$PackageModelImpl.fromJson;

  @override
  String get code;
  @override
  String get status;
  @override
  String get description;
  @override
  List<TrackingEvent> get events;
  @override
  DateTime? get lastUpdate;
  @override
  String? get origin;
  @override
  String? get destination;
  @override
  List<String> get tags;
  @override
  bool get archived;
  @override
  String? get carrier;
  @override
  String? get packageType;
  @override
  String? get packageCategory;
  @override
  DateTime? get estimatedDelivery;
  @override
  bool get delayed;
  @override
  bool get lockerDelivery;

  /// Create a copy of PackageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PackageModelImplCopyWith<_$PackageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
