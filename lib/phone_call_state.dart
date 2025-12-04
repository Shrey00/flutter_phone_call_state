import 'package:flutter_phone_call_state/src/model/call_log_data.dart';
import 'package:flutter_phone_call_state/src/model/call_result.dart';

import 'flutter_phone_call_state_platform_interface.dart';

class PhoneCallState {
  PhoneCallState._internal();
  static final _instance = PhoneCallState._internal();
  static PhoneCallState get instance => _instance;

  /// platform api
  final _phoneCallState = FlutterPhoneCallStatePlatform.instance;

  /// get phone call state change
  /// [phoneStateChange]
  Stream<CallResult> get phoneStateChange => _phoneCallState.phoneStateChange();

  /// phoneStateChange
  void onStateChange({required void Function(CallResult result) callback}) =>
      _phoneCallState.onStateChange(callback: callback);

  /// get last call log
  Future<CallLogData> getLastCallLog({bool isAfterLastCall = false}) =>
      _phoneCallState.getLastCall(isAfterLastCall: isAfterLastCall);

  ///working only android
  ///ios auto start
  ///[startMonitorService]
  Future<void> startMonitorService() => _phoneCallState.startMonitorService();

  ///working only android
  ///ios auto start
  ///[stopMonitorServiceBro]
  Future<void> stopMonitorServiceBro() => _phoneCallState.stopMonitorServiceBro();

  Future<bool?> isServiceRunning() => _phoneCallState.isServiceRunning();
}
