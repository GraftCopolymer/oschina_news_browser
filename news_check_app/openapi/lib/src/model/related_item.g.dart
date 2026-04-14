// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'related_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RelatedItem extends RelatedItem {
  @override
  final String? title;
  @override
  final String? url;

  factory _$RelatedItem([void Function(RelatedItemBuilder)? updates]) =>
      (RelatedItemBuilder()..update(updates))._build();

  _$RelatedItem._({this.title, this.url}) : super._();
  @override
  RelatedItem rebuild(void Function(RelatedItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RelatedItemBuilder toBuilder() => RelatedItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RelatedItem && title == other.title && url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RelatedItem')
          ..add('title', title)
          ..add('url', url))
        .toString();
  }
}

class RelatedItemBuilder implements Builder<RelatedItem, RelatedItemBuilder> {
  _$RelatedItem? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  RelatedItemBuilder() {
    RelatedItem._defaults(this);
  }

  RelatedItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RelatedItem other) {
    _$v = other as _$RelatedItem;
  }

  @override
  void update(void Function(RelatedItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RelatedItem build() => _build();

  _$RelatedItem _build() {
    final _$result = _$v ??
        _$RelatedItem._(
          title: title,
          url: url,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
