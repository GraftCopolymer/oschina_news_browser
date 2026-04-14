// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collect_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CollectRequestTargetTypeEnum _$collectRequestTargetTypeEnum_news =
    const CollectRequestTargetTypeEnum._('news');
const CollectRequestTargetTypeEnum _$collectRequestTargetTypeEnum_blog =
    const CollectRequestTargetTypeEnum._('blog');

CollectRequestTargetTypeEnum _$collectRequestTargetTypeEnumValueOf(
    String name) {
  switch (name) {
    case 'news':
      return _$collectRequestTargetTypeEnum_news;
    case 'blog':
      return _$collectRequestTargetTypeEnum_blog;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CollectRequestTargetTypeEnum>
    _$collectRequestTargetTypeEnumValues =
    BuiltSet<CollectRequestTargetTypeEnum>(const <CollectRequestTargetTypeEnum>[
  _$collectRequestTargetTypeEnum_news,
  _$collectRequestTargetTypeEnum_blog,
]);

Serializer<CollectRequestTargetTypeEnum>
    _$collectRequestTargetTypeEnumSerializer =
    _$CollectRequestTargetTypeEnumSerializer();

class _$CollectRequestTargetTypeEnumSerializer
    implements PrimitiveSerializer<CollectRequestTargetTypeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'news': 'news',
    'blog': 'blog',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'news': 'news',
    'blog': 'blog',
  };

  @override
  final Iterable<Type> types = const <Type>[CollectRequestTargetTypeEnum];
  @override
  final String wireName = 'CollectRequestTargetTypeEnum';

  @override
  Object serialize(Serializers serializers, CollectRequestTargetTypeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CollectRequestTargetTypeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CollectRequestTargetTypeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CollectRequest extends CollectRequest {
  @override
  final CollectRequestTargetTypeEnum targetType;
  @override
  final int targetId;

  factory _$CollectRequest([void Function(CollectRequestBuilder)? updates]) =>
      (CollectRequestBuilder()..update(updates))._build();

  _$CollectRequest._({required this.targetType, required this.targetId})
      : super._();
  @override
  CollectRequest rebuild(void Function(CollectRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CollectRequestBuilder toBuilder() => CollectRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CollectRequest &&
        targetType == other.targetType &&
        targetId == other.targetId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, targetType.hashCode);
    _$hash = $jc(_$hash, targetId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CollectRequest')
          ..add('targetType', targetType)
          ..add('targetId', targetId))
        .toString();
  }
}

class CollectRequestBuilder
    implements Builder<CollectRequest, CollectRequestBuilder> {
  _$CollectRequest? _$v;

  CollectRequestTargetTypeEnum? _targetType;
  CollectRequestTargetTypeEnum? get targetType => _$this._targetType;
  set targetType(CollectRequestTargetTypeEnum? targetType) =>
      _$this._targetType = targetType;

  int? _targetId;
  int? get targetId => _$this._targetId;
  set targetId(int? targetId) => _$this._targetId = targetId;

  CollectRequestBuilder() {
    CollectRequest._defaults(this);
  }

  CollectRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _targetType = $v.targetType;
      _targetId = $v.targetId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CollectRequest other) {
    _$v = other as _$CollectRequest;
  }

  @override
  void update(void Function(CollectRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CollectRequest build() => _build();

  _$CollectRequest _build() {
    final _$result = _$v ??
        _$CollectRequest._(
          targetType: BuiltValueNullFieldError.checkNotNull(
              targetType, r'CollectRequest', 'targetType'),
          targetId: BuiltValueNullFieldError.checkNotNull(
              targetId, r'CollectRequest', 'targetId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
