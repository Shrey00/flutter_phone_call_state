import 'package:flutter_phone_call_state/src/model/call_log_data.dart';
import 'package:flutter_phone_call_state/src/model/call_result.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'flutter_phone_call_state_method_channel.dart';

abstract class FlutterPhoneCallStatePlatform extends PlatformInterface {
  /// Constructs a FlutterPhoneCallStatePlatform.
  FlutterPhoneCallStatePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPhoneCallStatePlatform _instance =
      MethodChannelFlutterPhoneCallState();

  /// The default instance of [FlutterPhoneCallStatePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPhoneCallState].
  static FlutterPhoneCallStatePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPhoneCallStatePlatform] when
  /// they register themselves.
  static set instance(FlutterPhoneCallStatePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// start monitor service for andro
  Future<void> startMonitorService();

  /// stop monitor service for andro
  Future<void> stopMonitorServiceBro();

  /// check monitor service status for andro
  Future<bool?> isServiceRunning();


  void onStateChange({required void Function(CallResult result) callback});

  Future<CallLogData> getLastCall({bool isAfterLastCall = false});

  Stream<CallResult> phoneStateChange() {
    throw UnimplementedError('has not been implemented.');
  }
}
