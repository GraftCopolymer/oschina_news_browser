//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'blog_detail.g.dart';

/// 博客详情数据
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [author] 
/// * [authorId] 
/// * [publishTime] 
/// * [content] - 博客HTML内容
/// * [url] - 博客链接
/// * [favorite] - 0=未收藏 1=已收藏
/// * [commentCount] 
@BuiltValue()
abstract class BlogDetail implements Built<BlogDetail, BlogDetailBuilder> {
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

  /// 博客HTML内容
  @BuiltValueField(wireName: r'content')
  String? get content;

  /// 博客链接
  @BuiltValueField(wireName: r'url')
  String? get url;

  /// 0=未收藏 1=已收藏
  @BuiltValueField(wireName: r'favorite')
  BlogDetailFavoriteEnum? get favorite;
  // enum favoriteEnum {  0,  1,  };

  @BuiltValueField(wireName: r'commentCount')
  int? get commentCount;

  BlogDetail._();

  factory BlogDetail([void updates(BlogDetailBuilder b)]) = _$BlogDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BlogDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BlogDetail> get serializer => _$BlogDetailSerializer();
}

class _$BlogDetailSerializer implements PrimitiveSerializer<BlogDetail> {
  @override
  final Iterable<Type> types = const [BlogDetail, _$BlogDetail];

  @override
  final String wireName = r'BlogDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BlogDetail object, {
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
        specifiedType: const FullType(BlogDetailFavoriteEnum),
      );
    }
    if (object.commentCount != null) {
      yield r'commentCount';
      yield serializers.serialize(
        object.commentCount,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BlogDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BlogDetailBuilder result,
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
            specifiedType: const FullType(BlogDetailFavoriteEnum),
          ) as BlogDetailFavoriteEnum;
          result.favorite = valueDes;
          break;
        case r'commentCount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commentCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BlogDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BlogDetailBuilder();
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

class BlogDetailFavoriteEnum extends EnumClass {

  /// 0=未收藏 1=已收藏
  @BuiltValueEnumConst(wireNumber: 0)
  static const BlogDetailFavoriteEnum number0 = _$blogDetailFavoriteEnum_number0;
  /// 0=未收藏 1=已收藏
  @BuiltValueEnumConst(wireNumber: 1)
  static const BlogDetailFavoriteEnum number1 = _$blogDetailFavoriteEnum_number1;

  static Serializer<BlogDetailFavoriteEnum> get serializer => _$blogDetailFavoriteEnumSerializer;

  const BlogDetailFavoriteEnum._(String name): super(name);

  static BuiltSet<BlogDetailFavoriteEnum> get values => _$blogDetailFavoriteEnumValues;
  static BlogDetailFavoriteEnum valueOf(String name) => _$blogDetailFavoriteEnumValueOf(name);
}

