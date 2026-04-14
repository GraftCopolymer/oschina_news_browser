//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'collect_request.g.dart';

/// 收藏/取消收藏请求参数
///
/// Properties:
/// * [targetType] - 收藏目标类型
/// * [targetId] - 收藏目标ID
@BuiltValue()
abstract class CollectRequest implements Built<CollectRequest, CollectRequestBuilder> {
  /// 收藏目标类型
  @BuiltValueField(wireName: r'targetType')
  CollectRequestTargetTypeEnum get targetType;
  // enum targetTypeEnum {  news,  blog,  };

  /// 收藏目标ID
  @BuiltValueField(wireName: r'targetId')
  int get targetId;

  CollectRequest._();

  factory CollectRequest([void updates(CollectRequestBuilder b)]) = _$CollectRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CollectRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CollectRequest> get serializer => _$CollectRequestSerializer();
}

class _$CollectRequestSerializer implements PrimitiveSerializer<CollectRequest> {
  @override
  final Iterable<Type> types = const [CollectRequest, _$CollectRequest];

  @override
  final String wireName = r'CollectRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CollectRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'targetType';
    yield serializers.serialize(
      object.targetType,
      specifiedType: const FullType(CollectRequestTargetTypeEnum),
    );
    yield r'targetId';
    yield serializers.serialize(
      object.targetId,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CollectRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CollectRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'targetType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CollectRequestTargetTypeEnum),
          ) as CollectRequestTargetTypeEnum;
          result.targetType = valueDes;
          break;
        case r'targetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.targetId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CollectRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CollectRequestBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class CollectRequestTargetTypeEnum extends EnumClass {

  /// 收藏目标类型
  @BuiltValueEnumConst(wireName: r'news')
  static const CollectRequestTargetTypeEnum news = _$collectRequestTargetTypeEnum_news;
  /// 收藏目标类型
  @BuiltValueEnumConst(wireName: r'blog')
  static const CollectRequestTargetTypeEnum blog = _$collectRequestTargetTypeEnum_blog;

  static Serializer<CollectRequestTargetTypeEnum> get serializer => _$collectRequestTargetTypeEnumSerializer;

  const CollectRequestTargetTypeEnum._(String name): super(name);

  static BuiltSet<CollectRequestTargetTypeEnum> get values => _$collectRequestTargetTypeEnumValues;
  static CollectRequestTargetTypeEnum valueOf(String name) => _$collectRequestTargetTypeEnumValueOf(name);
}

