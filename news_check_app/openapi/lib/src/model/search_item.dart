//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'search_item.g.dart';

/// SearchItem
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [author] 
/// * [publishTime] 
/// * [type] 
/// * [url] 
@BuiltValue()
abstract class SearchItem implements Built<SearchItem, SearchItemBuilder> {
  @BuiltValueField(wireName: r'id')
  int? get id;

  @BuiltValueField(wireName: r'title')
  String? get title;

  @BuiltValueField(wireName: r'author')
  String? get author;

  @BuiltValueField(wireName: r'publishTime')
  DateTime? get publishTime;

  @BuiltValueField(wireName: r'type')
  SearchItemTypeEnum? get type;
  // enum typeEnum {  news,  blog,  project,  post,  };

  @BuiltValueField(wireName: r'url')
  String? get url;

  SearchItem._();

  factory SearchItem([void updates(SearchItemBuilder b)]) = _$SearchItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SearchItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SearchItem> get serializer => _$SearchItemSerializer();
}

class _$SearchItemSerializer implements PrimitiveSerializer<SearchItem> {
  @override
  final Iterable<Type> types = const [SearchItem, _$SearchItem];

  @override
  final String wireName = r'SearchItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SearchItem object, {
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
    if (object.type != null) {
      yield r'type';
      yield serializers.serialize(
        object.type,
        specifiedType: const FullType(SearchItemTypeEnum),
      );
    }
    if (object.url != null) {
      yield r'url';
      yield serializers.serialize(
        object.url,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SearchItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SearchItemBuilder result,
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
        case r'type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SearchItemTypeEnum),
          ) as SearchItemTypeEnum;
          result.type = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SearchItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SearchItemBuilder();
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

class SearchItemTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'news')
  static const SearchItemTypeEnum news = _$searchItemTypeEnum_news;
  @BuiltValueEnumConst(wireName: r'blog')
  static const SearchItemTypeEnum blog = _$searchItemTypeEnum_blog;
  @BuiltValueEnumConst(wireName: r'project')
  static const SearchItemTypeEnum project = _$searchItemTypeEnum_project;
  @BuiltValueEnumConst(wireName: r'post')
  static const SearchItemTypeEnum post = _$searchItemTypeEnum_post;

  static Serializer<SearchItemTypeEnum> get serializer => _$searchItemTypeEnumSerializer;

  const SearchItemTypeEnum._(String name): super(name);

  static BuiltSet<SearchItemTypeEnum> get values => _$searchItemTypeEnumValues;
  static SearchItemTypeEnum valueOf(String name) => _$searchItemTypeEnumValueOf(name);
}

