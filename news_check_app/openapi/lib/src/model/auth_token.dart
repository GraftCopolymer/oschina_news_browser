//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_token.g.dart';

/// AuthToken
///
/// Properties:
/// * [accessToken] - 后端JWT令牌
/// * [expiresIn] - 过期时间(秒)
/// * [userInfo] - 用户基础信息
@BuiltValue()
abstract class AuthToken implements Built<AuthToken, AuthTokenBuilder> {
  /// 后端JWT令牌
  @BuiltValueField(wireName: r'accessToken')
  String? get accessToken;

  /// 过期时间(秒)
  @BuiltValueField(wireName: r'expiresIn')
  int? get expiresIn;

  /// 用户基础信息
  @BuiltValueField(wireName: r'userInfo')
  JsonObject? get userInfo;

  AuthToken._();

  factory AuthToken([void updates(AuthTokenBuilder b)]) = _$AuthToken;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthTokenBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthToken> get serializer => _$AuthTokenSerializer();
}

class _$AuthTokenSerializer implements PrimitiveSerializer<AuthToken> {
  @override
  final Iterable<Type> types = const [AuthToken, _$AuthToken];

  @override
  final String wireName = r'AuthToken';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthToken object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.accessToken != null) {
      yield r'accessToken';
      yield serializers.serialize(
        object.accessToken,
        specifiedType: const FullType(String),
      );
    }
    if (object.expiresIn != null) {
      yield r'expiresIn';
      yield serializers.serialize(
        object.expiresIn,
        specifiedType: const FullType(int),
      );
    }
    if (object.userInfo != null) {
      yield r'userInfo';
      yield serializers.serialize(
        object.userInfo,
        specifiedType: const FullType(JsonObject),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthToken object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthTokenBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accessToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'expiresIn':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expiresIn = valueDes;
          break;
        case r'userInfo':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(JsonObject),
          ) as JsonObject;
          result.userInfo = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthToken deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthTokenBuilder();
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

