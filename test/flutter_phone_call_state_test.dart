import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_phone_call_state/flutter_phone_call_state.dart';
import 'package:flutter_phone_call_state/flutter_phone_call_state_platform_interface.dart';
import 'package:flutter_phone_call_state/flutter_phone_call_state_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPhoneCallStatePlatform
    with MockPlatformInterfaceMixin
    implements FlutterPhoneCallStatePlatform {
  @override
  Stream<CallResult> phoneStateChange() {
    return Stream.value(
        CallResult(state: CallState.call, number: "0857200286"));
  }

  @override
  void onStateChange({required void Function(CallResult result) callback}) {
    callback(CallResult(state: CallState.call));
  }

  @override
  Future<CallLogData> getLastCall({bool isAfterLastCall = false}) async {
    return CallLogData.fromJson({});
  }

  @override
  Future<void> startMonitorService() async {}

  @override
  Future<void> stopMonitorServiceBro() async {}


  @override
  Future<bool?> isServiceRunning() async {}
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterPhoneCallStatePlatform initialPlatform =
      FlutterPhoneCallStatePlatform.instance;

  test('$MethodChannelFlutterPhoneCallState is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPhoneCallState>());
  });

  group('CallState Enum Tests', () {
    test('should return correct description for each CallState', () {
      expect(CallState.end.description, 'End call');
      expect(CallState.outgoing.description, 'Dialing outgoing call');
      expect(CallState.outgoingAccept.description, 'Outgoing call accepted');
      expect(CallState.incoming.description, 'Incoming call');
      expect(CallState.call.description, 'Call accepted');
      expect(CallState.none.description, 'Unknown call state');
    });

    test('should return correct values for all CallState enums', () {
      expect(CallState.end, CallState.end);
      expect(CallState.outgoing, CallState.outgoing);
      expect(CallState.outgoingAccept, CallState.outgoingAccept);
      expect(CallState.incoming, CallState.incoming);
      expect(CallState.call, CallState.call);
      expect(CallState.none, CallState.none);
    });

    test('should have 6 states', () {
      expect(CallState.values.length, 8);
    });

    test('should return the correct index for each CallState', () {
      expect(CallState.end.index, 0);
      expect(CallState.outgoing.index, 1);
      expect(CallState.outgoingAccept.index, 2);
      expect(CallState.incoming.index, 3);
      expect(CallState.call.index, 4);
      expect(CallState.none.index, 7);
    });

    test('should check if CallState is "outgoing" correctly', () {
      expect(CallState.outgoing == CallState.outgoing, isTrue);
      expect(CallState.outgoing == CallState.incoming, isFalse);
    });
  });

  group(
    'test call result ',
    () {
      test('should create CallResult from status and phone number', () {
        final data = {
          'status': 2,
          'phoneNumber': '+1234567890',
        };

        final result = CallResult.fromFlag(data);

        expect(result.state, CallState.incoming);
        expect(result.number, '+1234567890');
      });

      test(
          'should return default CallState.none when invalid status is provided',
          () {
        final data = {
          'status': -1,
          'phoneNumber': '+0987654321',
        };

        final result = CallResult.fromFlag(data);

        expect(result.state, CallState.none);
        expect(result.number, '+0987654321');
      });

      test('should return empty string if no phone number is provided', () {
        final data = {
          'status': 3,
        };

        final result = CallResult.fromFlag(data);

        expect(result.state, CallState.call);
        expect(result.number, '');
      });

      test(
        'test call state enum and Result State',
        () {
          final result = CallResult(state: CallState.call, number: '01');
          expect(result, isA<CallResult>());
          expect(result.state, CallState.call);
          expect(result.number.isNotEmpty, true);
        },
      );

      test(
        'test call result from',
        () {
          final result = CallResult.from(0);
          expect(result, isA<CallState>());
          expect(result, CallState.end);
        },
      );

      test(
        'test call result from flag',
        () {
          final result =
              CallResult.fromFlag({"status": 0, 'phoneNumber': '01'});
          expect(result, isA<CallResult>());
          expect(result.state, CallState.end);
          expect(result.number.isNotEmpty, true);
        },
      );
    },
  );

  group(
    'test platform interface',
    () {
      test('test phone state change', () async {
        final flutterPhoneCallStatePlugin = PhoneCallState.instance;
        MockFlutterPhoneCallStatePlatform fakePlatform =
            MockFlutterPhoneCallStatePlatform();
        FlutterPhoneCallStatePlatform.instance = fakePlatform;
        final result = CallResult(state: CallState.call, number: "0857200286");

        flutterPhoneCallStatePlugin.phoneStateChange.listen(
          (event) {
            expect(event.number, result.number);
            expect(event.state, result.state);
          },
        );
      });

      test('test phone state callback', () {
        final flutterPhoneCallStatePlugin = PhoneCallState.instance;
        final fakePlatform = MockFlutterPhoneCallStatePlatform();
        FlutterPhoneCallStatePlatform.instance = fakePlatform;

        flutterPhoneCallStatePlugin.onStateChange(callback: (result) {
          expect(result.state, CallState.call);
        });
      });

      // test('test phone call log working only android', () async {
      //   final flutterPhoneCallStatePlugin = PhoneCallState.instance;
      //   final fakePlatform =
      //   MockFlutterPhoneCallStatePlatform();
      //   FlutterPhoneCallStatePlatform.instance = fakePlatform;
      //
      //   final log = await flutterPhoneCallStatePlugin.getLastCallLog();
      //
      //   expect(log, isA<CallLogData>());
      // });

      test('should allow setting a valid instance', () {
        // Arrange: Create a mock instance of FlutterPhoneCallStatePlatform
        final mockPlatform = MockFlutterPhoneCallStatePlatform();

        // Act: Set the instance using the setter
        FlutterPhoneCallStatePlatform.instance = mockPlatform;

        // Assert: Verify that the setter has correctly set the instance
        expect(FlutterPhoneCallStatePlatform.instance, mockPlatform);
      });
    },
  );
}
