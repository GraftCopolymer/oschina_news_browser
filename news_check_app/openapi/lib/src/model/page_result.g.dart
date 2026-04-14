// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_result.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PageResult extends PageResult {
  @override
  final int? total;
  @override
  final int? page;
  @override
  final int? pageSize;
  @override
  final BuiltList<JsonObject>? list;

  factory _$PageResult([void Function(PageResultBuilder)? updates]) =>
      (PageResultBuilder()..update(updates))._build();

  _$PageResult._({this.total, this.page, this.pageSize, this.list}) : super._();
  @override
  PageResult rebuild(void Function(PageResultBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PageResultBuilder toBuilder() => PageResultBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PageResult &&
        total == other.total &&
        page == other.page &&
        pageSize == other.pageSize &&
        list == other.list;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, page.hashCode);
    _$hash = $jc(_$hash, pageSize.hashCode);
    _$hash = $jc(_$hash, list.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PageResult')
          ..add('total', total)
          ..add('page', page)
          ..add('pageSize', pageSize)
          ..add('list', list))
        .toString();
  }
}

class PageResultBuilder implements Builder<PageResult, PageResultBuilder> {
  _$PageResult? _$v;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  int? _page;
  int? get page => _$this._page;
  set page(int? page) => _$this._page = page;

  int? _pageSize;
  int? get pageSize => _$this._pageSize;
  set pageSize(int? pageSize) => _$this._pageSize = pageSize;

  ListBuilder<JsonObject>? _list;
  ListBuilder<JsonObject> get list =>
      _$this._list ??= ListBuilder<JsonObject>();
  set list(ListBuilder<JsonObject>? list) => _$this._list = list;

  PageResultBuilder() {
    PageResult._defaults(this);
  }

  PageResultBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _total = $v.total;
      _page = $v.page;
      _pageSize = $v.pageSize;
      _list = $v.list?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PageResult other) {
    _$v = other as _$PageResult;
  }

  @override
  void update(void Function(PageResultBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PageResult build() => _build();

  _$PageResult _build() {
    _$PageResult _$result;
    try {
      _$result = _$v ??
          _$PageResult._(
            total: total,
            page: page,
            pageSize: pageSize,
            list: _list?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'list';
        _list?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PageResult', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
