import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';

class NativeBridge {
  static const MethodChannel _channel = MethodChannel('native_bridge');

  Future<String> getNativeString() async {
    final String result = await _channel.invokeMethod('getNativeString');
    return result;
  }
}

// FFI를 사용하여 C 함수에 접근하기 위한 클래스를 정의합니다.
class NativeLib {
  late final DynamicLibrary _lib;

  NativeLib() {
    // lib.so 파일을 로드합니다.
    if (Platform.isAndroid) {
      _lib = DynamicLibrary.open('libLaunchpad_Connector_Library.so');
    }
    else if (Platform.isWindows) {
      _lib = DynamicLibrary.open('Launchpad_Connector_Library.dll');
    }

    // 함수 시그니처를 매핑합니다.
    _test1 = _lib.lookupFunction<_Test1C, _Test1Dart>('test1');
    _test = _lib.lookupFunction<_TestC, _TestDart>('test');
    _log_get = _lib.lookupFunction<_LogGetC, _LogGetDart>('log_get');
  }

  // C 함수 시그니처를 정의합니다.
  late final _Test1Dart _test1;
  late final _TestDart _test;
  late final _LogGetDart _log_get;

  // Dart용 함수 시그니처를 정의합니다.
  int test1(int a, int b) => _test1(a, b);
  void test() => _test();
  String getLog() => _log_get().toDartString();
}

// C 함수의 시그니처를 Dart에서 사용할 수 있는 형식으로 정의합니다.
typedef _Test1C = Int32 Function(Int32 a, Int32 b);
typedef _Test1Dart = int Function(int a, int b);
typedef _TestC = Void Function();
typedef _TestDart = void Function();
typedef _LogGetC = Pointer<Utf8> Function();
typedef _LogGetDart = Pointer<Utf8> Function();

// 사용 예제
void main() {
  var lib = NativeLib();
  var result = lib.test1(3, 4);
  print(result); // 출력: 7
}
