// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ApiResponse extends ApiResponse {
  @override
  final int? code;
  @override
  final String? msg;
  @override
  final JsonObject? data;

  factory _$ApiResponse([void Function(ApiResponseBuilder)? updates]) =>
      (ApiResponseBuilder()..update(updates))._build();

  _$ApiResponse._({this.code, this.msg, this.data}) : super._();
  @override
  ApiResponse rebuild(void Function(ApiResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ApiResponseBuilder toBuilder() => ApiResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ApiResponse &&
        code == other.code &&
        msg == other.msg &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, msg.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ApiResponse')
          ..add('code', code)
          ..add('msg', msg)
          ..add('data', data))
        .toString();
  }
}

class ApiResponseBuilder implements Builder<ApiResponse, ApiResponseBuilder> {
  _$ApiResponse? _$v;

  int? _code;
  int? get code => _$this._code;
  set code(int? code) => _$this._code = code;

  String? _msg;
  String? get msg => _$this._msg;
  set msg(String? msg) => _$this._msg = msg;

  JsonObject? _data;
  JsonObject? get data => _$this._data;
  set data(JsonObject? data) => _$this._data = data;

  ApiResponseBuilder() {
    ApiResponse._defaults(this);
  }

  ApiResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _msg = $v.msg;
      _data = $v.data;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ApiResponse other) {
    _$v = other as _$ApiResponse;
  }

  @override
  void update(void Function(ApiResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ApiResponse build() => _build();

  _$ApiResponse _build() {
    final _$result = _$v ??
        _$ApiResponse._(
          code: code,
          msg: msg,
          data: data,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
