//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'api_response.g.dart';

/// 全局统一API响应格式
///
/// Properties:
/// * [code] - 响应码 200=成功 400=参数错误 401=未授权 500=服务器错误
/// * [msg] - 响应信息
/// * [data] - 响应数据
@BuiltValue()
abstract class ApiResponse implements Built<ApiResponse, ApiResponseBuilder> {
  /// 响应码 200=成功 400=参数错误 401=未授权 500=服务器错误
  @BuiltValueField(wireName: r'code')
  int? get code;

  /// 响应信息
  @BuiltValueField(wireName: r'msg')
  String? get msg;

  /// 响应数据
  @BuiltValueField(wireName: r'data')
  JsonObject? get data;

  ApiResponse._();

  factory ApiResponse([void updates(ApiResponseBuilder b)]) = _$ApiResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ApiResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ApiResponse> get serializer => _$ApiResponseSerializer();
}

class _$ApiResponseSerializer implements PrimitiveSerializer<ApiResponse> {
  @override
  final Iterable<Type> types = const [ApiResponse, _$ApiResponse];

  @override
  final String wireName = r'ApiResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ApiResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.code != null) {
      yield r'code';
      yield serializers.serialize(
        object.code,
        specifiedType: const FullType(int),
      );
    }
    if (object.msg != null) {
      yield r'msg';
      yield serializers.serialize(
        object.msg,
        specifiedType: const FullType(String),
      );
    }
    if (object.data != null) {
      yield r'data';
      yield serializers.serialize(
        object.data,
        specifiedType: const FullType.nullable(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ApiResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ApiResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.code = valueDes;
          break;
        case r'msg':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.msg = valueDes;
          break;
        case r'data':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.data = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ApiResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ApiResponseBuilder();
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

