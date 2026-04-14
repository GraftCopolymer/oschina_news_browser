//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:openapi/src/date_serializer.dart';
import 'package:openapi/src/model/date.dart';

import 'package:openapi/src/model/api_response.dart';
import 'package:openapi/src/model/auth_token.dart';
import 'package:openapi/src/model/blog_detail.dart';
import 'package:openapi/src/model/collect_request.dart';
import 'package:openapi/src/model/info_item.dart';
import 'package:openapi/src/model/news_detail.dart';
import 'package:openapi/src/model/page_result.dart';
import 'package:openapi/src/model/related_item.dart';
import 'package:openapi/src/model/search_item.dart';

part 'serializers.g.dart';

@SerializersFor([
  ApiResponse,
  AuthToken,
  BlogDetail,
  CollectRequest,
  InfoItem,
  NewsDetail,
  PageResult,
  RelatedItem,
  SearchItem,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
