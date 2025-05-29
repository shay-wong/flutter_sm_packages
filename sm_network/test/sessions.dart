import 'dart:math';

import 'package:sm_network/sm_network.dart';

import 'mock_interceptor.dart';
import 'models.dart';
import 'pageable/pageable_session.dart';

class ContentTypeSession extends Session with HttpMockAdapter {
  ContentTypeSession({
    this.contentType = ContentType.raw,
    this.data = const {'name': 'Shay', 'age': 18},
  });

  @override
  ContentType? contentType;

  @override
  Object? data;

  @override
  String? get path => '/contentType';

  @override
  Object? get responseData => data;
}

class GetErrorSession extends Session<String> with HttpMockAdapter {
  GetErrorSession({
    this.retryCount = 3,
  });

  @override
  String get path => '/getError';

  @override
  int? retryCount;

  @override
  RetryFunction<void>? get onRetry => (e, i) {
        // ignore: avoid_print
        print('第$i次重试: $e');
        _retryCount = i;
      };

  var _retryCount = 0;

  @override
  Map<String, Object> get response => _retryCount == retryCount
      ? {
          'code': 1,
          'message': 'success',
        }
      : {
          'code': -1,
          'message': 'error',
        };

  @override
  bool get status => _retryCount == retryCount;

  @override
  int? get statusCode => _retryCount == retryCount ? 200 : 400;
}

class GetNumSession extends Session<num> with HttpMockAdapter {
  GetNumSession();

  @override
  String get path => '/getNum';

  @override
  num? get responseData => 1234567890;

  @override
  ResponseType? get responseType => ResponseType.plain;
}

class GetObjSession extends Session<Person> with HttpMockAdapter {
  GetObjSession();

  @override
  FromJsonT<Person>? get fromJsonT => Person.fromJson;

  @override
  String get path => '/getObj';

  @override
  Parameters? get responseData => {'name': 'Shay', 'age': 18};
}

class GetObjsSession extends Session<Person> with HttpMockAdapter {
  GetObjsSession();

  @override
  FromJsonT<Person>? get fromJsonT => Person.fromJson;

  @override
  String get path => '/getObjs';

  @override
  List<Parameters> get responseData => [
        {'name': 'Shay', 'age': 18},
        {'name': 'Bob', 'age': 20},
      ];
}

class GetPageableSession extends PageableSession<Person> with HttpMockAdapter {
  GetPageableSession({super.pageNumber, super.pageSize});
  final firstNames = [
    'John',
    'Emma',
    'Michael',
    'Sophia',
    'James',
    'Olivia',
    'William',
    'Ava',
    'Alexander',
    'Isabella',
    'Liam',
    'Mia',
  ];
  final lastNames = [
    'Smith',
    'Johnson',
    'Brown',
    'Taylor',
    'Anderson',
    'Thomas',
    'Jackson',
    'White',
    'Harris',
    'Martin',
  ];

  @override
  FromJsonT<Person>? get fromJsonT => Person.fromJson;

  @override
  String? get path => '/getPageable';

  @override
  Map<String, dynamic> get responseData => {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'pages': 2,
        'total': 20,
        'list': List.generate(
          pageSize,
          (index) => {
            'name': getRandomEnglishName(),
            'age': Random().nextInt(100),
          },
        ),
      };

  String getRandomEnglishName() {
    final first = firstNames[Random().nextInt(firstNames.length)];
    final last = lastNames[Random().nextInt(lastNames.length)];
    return '$first $last';
  }
}

class GetStringSession extends Session<String> with HttpMockAdapter {
  GetStringSession();

  @override
  String get path => '/getString';

  @override
  String? get responseData => 'Hello World!';
}

/// 模拟請求
mixin HttpMockAdapter<R extends BaseResp<T>, T> on RawSession<R, T> {
  @override
  Parameters? get extra => Extra(
        responseData: responseData,
        response: response,
        status: status,
        statusCode: statusCode,
      ).toJson();

  dynamic get response => null;
  dynamic get responseData => null;
  bool get status => true;
  int? get statusCode => null;
}

class TimeoutSession extends Session with HttpMockAdapter {
  TimeoutSession();
  @override
  Dio get dio => super.dio..interceptors.insert(0, TimeoutInterceptor());

  @override
  Parameters? get extra => null;

  @override
  String get path => '/timeout';
}
