// Mocks generated by Mockito 5.4.4 from annotations
// in your_choice/test/services/hive/message_card_cache_services_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:convert' as _i6;
import 'dart:io' as _i2;
import 'dart:typed_data' as _i7;

import 'package:hive/hive.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFile_0 extends _i1.SmartFake implements _i2.File {
  _FakeFile_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeUri_1 extends _i1.SmartFake implements Uri {
  _FakeUri_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDirectory_2 extends _i1.SmartFake implements _i2.Directory {
  _FakeDirectory_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFileSystemEntity_3 extends _i1.SmartFake
    implements _i2.FileSystemEntity {
  _FakeFileSystemEntity_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDateTime_4 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeRandomAccessFile_5 extends _i1.SmartFake
    implements _i2.RandomAccessFile {
  _FakeRandomAccessFile_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeIOSink_6 extends _i1.SmartFake implements _i2.IOSink {
  _FakeIOSink_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFileStat_7 extends _i1.SmartFake implements _i2.FileStat {
  _FakeFileStat_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Box].
///
/// See the documentation for Mockito's code generation for more information.
class MockBox<E> extends _i1.Mock implements _i3.Box<E> {
  MockBox() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Iterable<E> get values => (super.noSuchMethod(
        Invocation.getter(#values),
        returnValue: <E>[],
      ) as Iterable<E>);

  @override
  String get name => (super.noSuchMethod(
        Invocation.getter(#name),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#name),
        ),
      ) as String);

  @override
  bool get isOpen => (super.noSuchMethod(
        Invocation.getter(#isOpen),
        returnValue: false,
      ) as bool);

  @override
  bool get lazy => (super.noSuchMethod(
        Invocation.getter(#lazy),
        returnValue: false,
      ) as bool);

  @override
  Iterable<dynamic> get keys => (super.noSuchMethod(
        Invocation.getter(#keys),
        returnValue: <dynamic>[],
      ) as Iterable<dynamic>);

  @override
  int get length => (super.noSuchMethod(
        Invocation.getter(#length),
        returnValue: 0,
      ) as int);

  @override
  bool get isEmpty => (super.noSuchMethod(
        Invocation.getter(#isEmpty),
        returnValue: false,
      ) as bool);

  @override
  bool get isNotEmpty => (super.noSuchMethod(
        Invocation.getter(#isNotEmpty),
        returnValue: false,
      ) as bool);

  @override
  Iterable<E> valuesBetween({
    dynamic startKey,
    dynamic endKey,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #valuesBetween,
          [],
          {
            #startKey: startKey,
            #endKey: endKey,
          },
        ),
        returnValue: <E>[],
      ) as Iterable<E>);

  @override
  E? getAt(int? index) => (super.noSuchMethod(Invocation.method(
        #getAt,
        [index],
      )) as E?);

  @override
  Map<dynamic, E> toMap() => (super.noSuchMethod(
        Invocation.method(
          #toMap,
          [],
        ),
        returnValue: <dynamic, E>{},
      ) as Map<dynamic, E>);

  @override
  dynamic keyAt(int? index) => super.noSuchMethod(Invocation.method(
        #keyAt,
        [index],
      ));

  @override
  _i5.Stream<_i3.BoxEvent> watch({dynamic key}) => (super.noSuchMethod(
        Invocation.method(
          #watch,
          [],
          {#key: key},
        ),
        returnValue: _i5.Stream<_i3.BoxEvent>.empty(),
      ) as _i5.Stream<_i3.BoxEvent>);

  @override
  bool containsKey(dynamic key) => (super.noSuchMethod(
        Invocation.method(
          #containsKey,
          [key],
        ),
        returnValue: false,
      ) as bool);

  @override
  _i5.Future<void> put(
    dynamic key,
    E? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #put,
          [
            key,
            value,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> putAt(
    int? index,
    E? value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #putAt,
          [
            index,
            value,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> putAll(Map<dynamic, E>? entries) => (super.noSuchMethod(
        Invocation.method(
          #putAll,
          [entries],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<int> add(E? value) => (super.noSuchMethod(
        Invocation.method(
          #add,
          [value],
        ),
        returnValue: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);

  @override
  _i5.Future<Iterable<int>> addAll(Iterable<E>? values) => (super.noSuchMethod(
        Invocation.method(
          #addAll,
          [values],
        ),
        returnValue: _i5.Future<Iterable<int>>.value(<int>[]),
      ) as _i5.Future<Iterable<int>>);

  @override
  _i5.Future<void> delete(dynamic key) => (super.noSuchMethod(
        Invocation.method(
          #delete,
          [key],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> deleteAt(int? index) => (super.noSuchMethod(
        Invocation.method(
          #deleteAt,
          [index],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> deleteAll(Iterable<dynamic>? keys) => (super.noSuchMethod(
        Invocation.method(
          #deleteAll,
          [keys],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> compact() => (super.noSuchMethod(
        Invocation.method(
          #compact,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<int> clear() => (super.noSuchMethod(
        Invocation.method(
          #clear,
          [],
        ),
        returnValue: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);

  @override
  _i5.Future<void> close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> deleteFromDisk() => (super.noSuchMethod(
        Invocation.method(
          #deleteFromDisk,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> flush() => (super.noSuchMethod(
        Invocation.method(
          #flush,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}

/// A class which mocks [File].
///
/// See the documentation for Mockito's code generation for more information.
class MockFile extends _i1.Mock implements _i2.File {
  MockFile() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.File get absolute => (super.noSuchMethod(
        Invocation.getter(#absolute),
        returnValue: _FakeFile_0(
          this,
          Invocation.getter(#absolute),
        ),
      ) as _i2.File);

  @override
  String get path => (super.noSuchMethod(
        Invocation.getter(#path),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#path),
        ),
      ) as String);

  @override
  Uri get uri => (super.noSuchMethod(
        Invocation.getter(#uri),
        returnValue: _FakeUri_1(
          this,
          Invocation.getter(#uri),
        ),
      ) as Uri);

  @override
  bool get isAbsolute => (super.noSuchMethod(
        Invocation.getter(#isAbsolute),
        returnValue: false,
      ) as bool);

  @override
  _i2.Directory get parent => (super.noSuchMethod(
        Invocation.getter(#parent),
        returnValue: _FakeDirectory_2(
          this,
          Invocation.getter(#parent),
        ),
      ) as _i2.Directory);

  @override
  _i5.Future<_i2.File> create({
    bool? recursive = false,
    bool? exclusive = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #create,
          [],
          {
            #recursive: recursive,
            #exclusive: exclusive,
          },
        ),
        returnValue: _i5.Future<_i2.File>.value(_FakeFile_0(
          this,
          Invocation.method(
            #create,
            [],
            {
              #recursive: recursive,
              #exclusive: exclusive,
            },
          ),
        )),
      ) as _i5.Future<_i2.File>);

  @override
  void createSync({
    bool? recursive = false,
    bool? exclusive = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #createSync,
          [],
          {
            #recursive: recursive,
            #exclusive: exclusive,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<_i2.File> rename(String? newPath) => (super.noSuchMethod(
        Invocation.method(
          #rename,
          [newPath],
        ),
        returnValue: _i5.Future<_i2.File>.value(_FakeFile_0(
          this,
          Invocation.method(
            #rename,
            [newPath],
          ),
        )),
      ) as _i5.Future<_i2.File>);

  @override
  _i2.File renameSync(String? newPath) => (super.noSuchMethod(
        Invocation.method(
          #renameSync,
          [newPath],
        ),
        returnValue: _FakeFile_0(
          this,
          Invocation.method(
            #renameSync,
            [newPath],
          ),
        ),
      ) as _i2.File);

  @override
  _i5.Future<_i2.FileSystemEntity> delete({bool? recursive = false}) =>
      (super.noSuchMethod(
        Invocation.method(
          #delete,
          [],
          {#recursive: recursive},
        ),
        returnValue:
            _i5.Future<_i2.FileSystemEntity>.value(_FakeFileSystemEntity_3(
          this,
          Invocation.method(
            #delete,
            [],
            {#recursive: recursive},
          ),
        )),
      ) as _i5.Future<_i2.FileSystemEntity>);

  @override
  void deleteSync({bool? recursive = false}) => super.noSuchMethod(
        Invocation.method(
          #deleteSync,
          [],
          {#recursive: recursive},
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<_i2.File> copy(String? newPath) => (super.noSuchMethod(
        Invocation.method(
          #copy,
          [newPath],
        ),
        returnValue: _i5.Future<_i2.File>.value(_FakeFile_0(
          this,
          Invocation.method(
            #copy,
            [newPath],
          ),
        )),
      ) as _i5.Future<_i2.File>);

  @override
  _i2.File copySync(String? newPath) => (super.noSuchMethod(
        Invocation.method(
          #copySync,
          [newPath],
        ),
        returnValue: _FakeFile_0(
          this,
          Invocation.method(
            #copySync,
            [newPath],
          ),
        ),
      ) as _i2.File);

  @override
  _i5.Future<int> length() => (super.noSuchMethod(
        Invocation.method(
          #length,
          [],
        ),
        returnValue: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);

  @override
  int lengthSync() => (super.noSuchMethod(
        Invocation.method(
          #lengthSync,
          [],
        ),
        returnValue: 0,
      ) as int);

  @override
  _i5.Future<DateTime> lastAccessed() => (super.noSuchMethod(
        Invocation.method(
          #lastAccessed,
          [],
        ),
        returnValue: _i5.Future<DateTime>.value(_FakeDateTime_4(
          this,
          Invocation.method(
            #lastAccessed,
            [],
          ),
        )),
      ) as _i5.Future<DateTime>);

  @override
  DateTime lastAccessedSync() => (super.noSuchMethod(
        Invocation.method(
          #lastAccessedSync,
          [],
        ),
        returnValue: _FakeDateTime_4(
          this,
          Invocation.method(
            #lastAccessedSync,
            [],
          ),
        ),
      ) as DateTime);

  @override
  _i5.Future<dynamic> setLastAccessed(DateTime? time) => (super.noSuchMethod(
        Invocation.method(
          #setLastAccessed,
          [time],
        ),
        returnValue: _i5.Future<dynamic>.value(),
      ) as _i5.Future<dynamic>);

  @override
  void setLastAccessedSync(DateTime? time) => super.noSuchMethod(
        Invocation.method(
          #setLastAccessedSync,
          [time],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<DateTime> lastModified() => (super.noSuchMethod(
        Invocation.method(
          #lastModified,
          [],
        ),
        returnValue: _i5.Future<DateTime>.value(_FakeDateTime_4(
          this,
          Invocation.method(
            #lastModified,
            [],
          ),
        )),
      ) as _i5.Future<DateTime>);

  @override
  DateTime lastModifiedSync() => (super.noSuchMethod(
        Invocation.method(
          #lastModifiedSync,
          [],
        ),
        returnValue: _FakeDateTime_4(
          this,
          Invocation.method(
            #lastModifiedSync,
            [],
          ),
        ),
      ) as DateTime);

  @override
  _i5.Future<dynamic> setLastModified(DateTime? time) => (super.noSuchMethod(
        Invocation.method(
          #setLastModified,
          [time],
        ),
        returnValue: _i5.Future<dynamic>.value(),
      ) as _i5.Future<dynamic>);

  @override
  void setLastModifiedSync(DateTime? time) => super.noSuchMethod(
        Invocation.method(
          #setLastModifiedSync,
          [time],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<_i2.RandomAccessFile> open(
          {_i2.FileMode? mode = _i2.FileMode.read}) =>
      (super.noSuchMethod(
        Invocation.method(
          #open,
          [],
          {#mode: mode},
        ),
        returnValue:
            _i5.Future<_i2.RandomAccessFile>.value(_FakeRandomAccessFile_5(
          this,
          Invocation.method(
            #open,
            [],
            {#mode: mode},
          ),
        )),
      ) as _i5.Future<_i2.RandomAccessFile>);

  @override
  _i2.RandomAccessFile openSync({_i2.FileMode? mode = _i2.FileMode.read}) =>
      (super.noSuchMethod(
        Invocation.method(
          #openSync,
          [],
          {#mode: mode},
        ),
        returnValue: _FakeRandomAccessFile_5(
          this,
          Invocation.method(
            #openSync,
            [],
            {#mode: mode},
          ),
        ),
      ) as _i2.RandomAccessFile);

  @override
  _i5.Stream<List<int>> openRead([
    int? start,
    int? end,
  ]) =>
      (super.noSuchMethod(
        Invocation.method(
          #openRead,
          [
            start,
            end,
          ],
        ),
        returnValue: _i5.Stream<List<int>>.empty(),
      ) as _i5.Stream<List<int>>);

  @override
  _i2.IOSink openWrite({
    _i2.FileMode? mode = _i2.FileMode.write,
    _i6.Encoding? encoding = const _i6.Utf8Codec(),
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #openWrite,
          [],
          {
            #mode: mode,
            #encoding: encoding,
          },
        ),
        returnValue: _FakeIOSink_6(
          this,
          Invocation.method(
            #openWrite,
            [],
            {
              #mode: mode,
              #encoding: encoding,
            },
          ),
        ),
      ) as _i2.IOSink);

  @override
  _i5.Future<_i7.Uint8List> readAsBytes() => (super.noSuchMethod(
        Invocation.method(
          #readAsBytes,
          [],
        ),
        returnValue: _i5.Future<_i7.Uint8List>.value(_i7.Uint8List(0)),
      ) as _i5.Future<_i7.Uint8List>);

  @override
  _i7.Uint8List readAsBytesSync() => (super.noSuchMethod(
        Invocation.method(
          #readAsBytesSync,
          [],
        ),
        returnValue: _i7.Uint8List(0),
      ) as _i7.Uint8List);

  @override
  _i5.Future<String> readAsString(
          {_i6.Encoding? encoding = const _i6.Utf8Codec()}) =>
      (super.noSuchMethod(
        Invocation.method(
          #readAsString,
          [],
          {#encoding: encoding},
        ),
        returnValue: _i5.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #readAsString,
            [],
            {#encoding: encoding},
          ),
        )),
      ) as _i5.Future<String>);

  @override
  String readAsStringSync({_i6.Encoding? encoding = const _i6.Utf8Codec()}) =>
      (super.noSuchMethod(
        Invocation.method(
          #readAsStringSync,
          [],
          {#encoding: encoding},
        ),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.method(
            #readAsStringSync,
            [],
            {#encoding: encoding},
          ),
        ),
      ) as String);

  @override
  _i5.Future<List<String>> readAsLines(
          {_i6.Encoding? encoding = const _i6.Utf8Codec()}) =>
      (super.noSuchMethod(
        Invocation.method(
          #readAsLines,
          [],
          {#encoding: encoding},
        ),
        returnValue: _i5.Future<List<String>>.value(<String>[]),
      ) as _i5.Future<List<String>>);

  @override
  List<String> readAsLinesSync(
          {_i6.Encoding? encoding = const _i6.Utf8Codec()}) =>
      (super.noSuchMethod(
        Invocation.method(
          #readAsLinesSync,
          [],
          {#encoding: encoding},
        ),
        returnValue: <String>[],
      ) as List<String>);

  @override
  _i5.Future<_i2.File> writeAsBytes(
    List<int>? bytes, {
    _i2.FileMode? mode = _i2.FileMode.write,
    bool? flush = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #writeAsBytes,
          [bytes],
          {
            #mode: mode,
            #flush: flush,
          },
        ),
        returnValue: _i5.Future<_i2.File>.value(_FakeFile_0(
          this,
          Invocation.method(
            #writeAsBytes,
            [bytes],
            {
              #mode: mode,
              #flush: flush,
            },
          ),
        )),
      ) as _i5.Future<_i2.File>);

  @override
  void writeAsBytesSync(
    List<int>? bytes, {
    _i2.FileMode? mode = _i2.FileMode.write,
    bool? flush = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeAsBytesSync,
          [bytes],
          {
            #mode: mode,
            #flush: flush,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<_i2.File> writeAsString(
    String? contents, {
    _i2.FileMode? mode = _i2.FileMode.write,
    _i6.Encoding? encoding = const _i6.Utf8Codec(),
    bool? flush = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #writeAsString,
          [contents],
          {
            #mode: mode,
            #encoding: encoding,
            #flush: flush,
          },
        ),
        returnValue: _i5.Future<_i2.File>.value(_FakeFile_0(
          this,
          Invocation.method(
            #writeAsString,
            [contents],
            {
              #mode: mode,
              #encoding: encoding,
              #flush: flush,
            },
          ),
        )),
      ) as _i5.Future<_i2.File>);

  @override
  void writeAsStringSync(
    String? contents, {
    _i2.FileMode? mode = _i2.FileMode.write,
    _i6.Encoding? encoding = const _i6.Utf8Codec(),
    bool? flush = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #writeAsStringSync,
          [contents],
          {
            #mode: mode,
            #encoding: encoding,
            #flush: flush,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<bool> exists() => (super.noSuchMethod(
        Invocation.method(
          #exists,
          [],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  bool existsSync() => (super.noSuchMethod(
        Invocation.method(
          #existsSync,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  _i5.Future<String> resolveSymbolicLinks() => (super.noSuchMethod(
        Invocation.method(
          #resolveSymbolicLinks,
          [],
        ),
        returnValue: _i5.Future<String>.value(_i4.dummyValue<String>(
          this,
          Invocation.method(
            #resolveSymbolicLinks,
            [],
          ),
        )),
      ) as _i5.Future<String>);

  @override
  String resolveSymbolicLinksSync() => (super.noSuchMethod(
        Invocation.method(
          #resolveSymbolicLinksSync,
          [],
        ),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.method(
            #resolveSymbolicLinksSync,
            [],
          ),
        ),
      ) as String);

  @override
  _i5.Future<_i2.FileStat> stat() => (super.noSuchMethod(
        Invocation.method(
          #stat,
          [],
        ),
        returnValue: _i5.Future<_i2.FileStat>.value(_FakeFileStat_7(
          this,
          Invocation.method(
            #stat,
            [],
          ),
        )),
      ) as _i5.Future<_i2.FileStat>);

  @override
  _i2.FileStat statSync() => (super.noSuchMethod(
        Invocation.method(
          #statSync,
          [],
        ),
        returnValue: _FakeFileStat_7(
          this,
          Invocation.method(
            #statSync,
            [],
          ),
        ),
      ) as _i2.FileStat);

  @override
  _i5.Stream<_i2.FileSystemEvent> watch({
    int? events = 15,
    bool? recursive = false,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #watch,
          [],
          {
            #events: events,
            #recursive: recursive,
          },
        ),
        returnValue: _i5.Stream<_i2.FileSystemEvent>.empty(),
      ) as _i5.Stream<_i2.FileSystemEvent>);
}
