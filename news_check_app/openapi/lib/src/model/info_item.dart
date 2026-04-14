//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'info_item.g.dart';

/// 新闻/博客列表展示项
///
/// Properties:
/// * [id] - 内容ID
/// * [title] - 标题
/// * [author] - 作者
/// * [publishTime] - 发布时间
/// * [thumbnail] - 缩略图(无则返回默认图)
/// * [viewCount] - 阅读量
/// * [commentCount] - 评论数
/// * [type] - 内容类型 news=新闻 blog=博客
@BuiltValue()
abstract class InfoItem implements Built<InfoItem, InfoItemBuilder> {
  /// 内容ID
  @BuiltValueField(wireName: r'id')
  int? get id;

  /// 标题
  @BuiltValueField(wireName: r'title')
  String? get title;

  /// 作者
  @BuiltValueField(wireName: r'author')
  String? get author;

  /// 发布时间
  @BuiltValueField(wireName: r'publishTime')
  DateTime? get publishTime;

  /// 缩略图(无则返回默认图)
  @BuiltValueField(wireName: r'thumbnail')
  String? get thumbnail;

  /// 阅读量
  @BuiltValueField(wireName: r'viewCount')
  int? get viewCount;

  /// 评论数
  @BuiltValueField(wireName: r'commentCount')
  int? get commentCount;

  /// 内容类型 news=新闻 blog=博客
  @BuiltValueField(wireName: r'type')
  InfoItemTypeEnum? get type;
  // enum typeEnum {  news,  blog,  };

  InfoItem._();

  factory InfoItem([void updates(InfoItemBuilder b)]) = _$InfoItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InfoItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InfoItem> get serializer => _$InfoItemSerializer();
}

class _$InfoItemSerializer implements PrimitiveSerializer<InfoItem> {
  @override
  final Iterable<Type> types = const [InfoItem, _$InfoItem];

  @override
  final String wireName = r'InfoItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InfoItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.id != null) {
      yield r'id';
      yield serializers.serialize(
        object.id,
        specifiedType: const FullType(int),
      );
    }
    if (object.title != null) {
      yield r'title';
      yield serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      );
    }
    if (object.author != null) {
      yield r'author';
      yield serializers.serialize(
        object.author,
        specifiedType: const FullType(String),
      );
    }
    if (object.publishTime != null) {
      yield r'publishTime';
      yield serializers.serialize(
        object.publishTime,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.thumbnail != null) {
      yield r'thumbnail';
      yield serializers.serialize(
        object.thumbnail,
        specifiedType: const FullType(String),
      );
    }
    if (object.viewCount != null) {
      yield r'viewCount';
      yield serializers.serialize(
        object.viewCount,
        specifiedType: const FullType(int),
      );
    }
    if (object.commentCount != null) {
      yield r'commentCount';
      yield serializers.serialize(
        object.commentCount,
        specifiedType: const FullType(int),
      );
    }
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(InfoItemTypeEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InfoItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InfoItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'author':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.author = valueDes;
          break;
        case r'publishTime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.publishTime = valueDes;
          break;
        case r'thumbnail':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.thumbnail = valueDes;
          break;
        case r'viewCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.viewCount = valueDes;
          break;
        case r'commentCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commentCount = valueDes;
          break;
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InfoItemTypeEnum),
          ) as InfoItemTypeEnum;
          result.type = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InfoItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InfoItemBuilder();
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

class InfoItemTypeEnum extends EnumClass {

  /// 内容类型 news=新闻 blog=博客
  @BuiltValueEnumConst(wireName: r'news')
  static const InfoItemTypeEnum news = _$infoItemTypeEnum_news;
  /// 内容类型 news=新闻 blog=博客
  @BuiltValueEnumConst(wireName: r'blog')
  static const InfoItemTypeEnum blog = _$infoItemTypeEnum_blog;

  static Serializer<InfoItemTypeEnum> get serializer => _$infoItemTypeEnumSerializer;

  const InfoItemTypeEnum._(String name): super(name);

  static BuiltSet<InfoItemTypeEnum> get values => _$infoItemTypeEnumValues;
  static InfoItemTypeEnum valueOf(String name) => _$infoItemTypeEnumValueOf(name);
}

