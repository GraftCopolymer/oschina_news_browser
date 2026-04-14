//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:openapi/src/model/related_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'news_detail.g.dart';

/// 新闻详情数据
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [author] 
/// * [authorId] 
/// * [publishTime] 
/// * [content] - 新闻HTML内容
/// * [url] - 原文链接
/// * [favorite] - 0=未收藏 1=已收藏
/// * [commentCount] 
/// * [relatedList] 
@BuiltValue()
abstract class NewsDetail implements Built<NewsDetail, NewsDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'author')
  String? get author;

  @BuiltValueField(wireName: r'authorId')
  int? get authorId;

  @BuiltValueField(wireName: r'publishTime')
  DateTime? get publishTime;

  /// 新闻HTML内容
  @BuiltValueField(wireName: r'content')
  String? get content;

  /// 原文链接
  @BuiltValueField(wireName: r'url')
  String? get url;

  /// 0=未收藏 1=已收藏
  @BuiltValueField(wireName: r'favorite')
  NewsDetailFavoriteEnum? get favorite;
  // enum favoriteEnum {  0,  1,  };

  @BuiltValueField(wireName: r'commentCount')
  int? get commentCount;

  @BuiltValueField(wireName: r'relatedList')
  BuiltList<RelatedItem>? get relatedList;

  NewsDetail._();

  factory NewsDetail([void updates(NewsDetailBuilder b)]) = _$NewsDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(NewsDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<NewsDetail> get serializer => _$NewsDetailSerializer();
}

class _$NewsDetailSerializer implements PrimitiveSerializer<NewsDetail> {
  @override
  final Iterable<Type> types = const [NewsDetail, _$NewsDetail];

  @override
  final String wireName = r'NewsDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    NewsDetail object, {
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
    if (object.authorId != null) {
      yield r'authorId';
      yield serializers.serialize(
        object.authorId,
        specifiedType: const FullType(int),
      );
    }
    if (object.publishTime != null) {
      yield r'publishTime';
      yield serializers.serialize(
        object.publishTime,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.content != null) {
      yield r'content';
      yield serializers.serialize(
        object.content,
        specifiedType: const FullType(String),
      );
    }
    if (object.url != null) {
      yield r'url';
      yield serializers.serialize(
        object.url,
        specifiedType: const FullType(String),
      );
    }
    if (object.favorite != null) {
      yield r'favorite';
      yield serializers.serialize(
        object.favorite,
        specifiedType: const FullType(NewsDetailFavoriteEnum),
      );
    }
    if (object.commentCount != null) {
      yield r'commentCount';
      yield serializers.serialize(
        object.commentCount,
        specifiedType: const FullType(int),
      );
    }
    if (object.relatedList != null) {
      yield r'relatedList';
      yield serializers.serialize(
        object.relatedList,
        specifiedType: const FullType(BuiltList, [FullType(RelatedItem)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    NewsDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required NewsDetailBuilder result,
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
        case r'authorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.authorId = valueDes;
          break;
        case r'publishTime':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.publishTime = valueDes;
          break;
        case r'content':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.content = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'favorite':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(NewsDetailFavoriteEnum),
          ) as NewsDetailFavoriteEnum;
          result.favorite = valueDes;
          break;
        case r'commentCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commentCount = valueDes;
          break;
        case r'relatedList':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RelatedItem)]),
          ) as BuiltList<RelatedItem>;
          result.relatedList.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  NewsDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NewsDetailBuilder();
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

class NewsDetailFavoriteEnum extends EnumClass {

  /// 0=未收藏 1=已收藏
  @BuiltValueEnumConst(wireNumber: 0)
  static const NewsDetailFavoriteEnum number0 = _$newsDetailFavoriteEnum_number0;
  /// 0=未收藏 1=已收藏
  @BuiltValueEnumConst(wireNumber: 1)
  static const NewsDetailFavoriteEnum number1 = _$newsDetailFavoriteEnum_number1;

  static Serializer<NewsDetailFavoriteEnum> get serializer => _$newsDetailFavoriteEnumSerializer;

  const NewsDetailFavoriteEnum._(String name): super(name);

  static BuiltSet<NewsDetailFavoriteEnum> get values => _$newsDetailFavoriteEnumValues;
  static NewsDetailFavoriteEnum valueOf(String name) => _$newsDetailFavoriteEnumValueOf(name);
}

