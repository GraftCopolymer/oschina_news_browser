// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_token.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthToken extends AuthToken {
  @override
  final String? accessToken;
  @override
  final int? expiresIn;
  @override
  final JsonObject? userInfo;

  factory _$AuthToken([void Function(AuthTokenBuilder)? updates]) =>
      (AuthTokenBuilder()..update(updates))._build();

  _$AuthToken._({this.accessToken, this.expiresIn, this.userInfo}) : super._();
  @override
  AuthToken rebuild(void Function(AuthTokenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthTokenBuilder toBuilder() => AuthTokenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthToken &&
        accessToken == other.accessToken &&
        expiresIn == other.expiresIn &&
        userInfo == other.userInfo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accessToken.hashCode);
    _$hash = $jc(_$hash, expiresIn.hashCode);
    _$hash = $jc(_$hash, userInfo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AuthToken')
          ..add('accessToken', accessToken)
          ..add('expiresIn', expiresIn)
          ..add('userInfo', userInfo))
        .toString();
  }
}

class AuthTokenBuilder implements Builder<AuthToken, AuthTokenBuilder> {
  _$AuthToken? _$v;

  String? _accessToken;
  String? get accessToken => _$this._accessToken;
  set accessToken(String? accessToken) => _$this._accessToken = accessToken;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  JsonObject? _userInfo;
  JsonObject? get userInfo => _$this._userInfo;
  set userInfo(JsonObject? userInfo) => _$this._userInfo = userInfo;

  AuthTokenBuilder() {
    AuthToken._defaults(this);
  }

  AuthTokenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accessToken = $v.accessToken;
      _expiresIn = $v.expiresIn;
      _userInfo = $v.userInfo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AuthToken other) {
    _$v = other as _$AuthToken;
  }

  @override
  void update(void Function(AuthTokenBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthToken build() => _build();

  _$AuthToken _build() {
    final _$result = _$v ??
        _$AuthToken._(
          accessToken: accessToken,
          expiresIn: expiresIn,
          userInfo: userInfo,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
