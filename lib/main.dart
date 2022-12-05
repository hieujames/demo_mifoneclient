import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mifone_client_flutter/mifone_client_flutter.dart';
import 'package:mifone_client_flutter/callkit/utils/mifone_client_event.dart';
import 'package:mifone_client_flutter/callkit/utils/transport_type.dart';
import 'package:mifone_client_flutter/callkit/model/mifone_configuration.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  void callKitEvent() {
    MifoneClient.callModule.eventStreamController.stream.listen((event) {
      switch (event['event']) {
        case MifoneClientEvent.AccountRegistrationStateChanged:
          {
            var body = event['body'];
            print("AccountRegistrationStateChanged");
            print(body);
          }
          break;
        case MifoneClientEvent.Ring:
          {
            var body = event['body'];
            print("Ring");
            print(body);
          }
          break;
        case MifoneClientEvent.Up:
          {
            var body = event['body'];
            print("Status up when accept calling");
            print(body);
          }
          break;
        case MifoneClientEvent.Hangup:
          {
            var body = event['body'];
            print("Hangup");
            print(body);
          }
          break;
        case MifoneClientEvent.Paused: // Hold
          {
            print("Paused");
          }
          break;
        case MifoneClientEvent.Resuming: // Unhold
          {
            print("Resuming");
          }
          break;
        case MifoneClientEvent.Missed:
          {
            var body = event['body'];
            print("Missed");
            print(body);
          }
          break;
        case MifoneClientEvent.Error:
          {
            var body = event['body'];
            print("Error");
            print(body);
          }
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
    initPlatformState();
    
    String TOKEN =
        "V1RCa1MwNUZOVlZaTTFacFZqSjRNMWRYTlc1a1YxSjBUa1F4YVU1dFJteGFSR3hvV1dwa2FscEhXVFJPVkZGNlRXMU5lazFxUlROT1ZHUnBUa2RSTUU5RVJURk5NRFZWVmxSS1QyUjZNRGxaYWxwb1dsZFJOVmxYU1ROWk1sSnRUMFJWTUUxNlNtcE5la2w0VG5wVk0xbHFVbXRPUkdkNFRsUk9hazF0ZUROWk1HaExaRzFXU1dFelpFNVZla0kxVkZWU1NtUXdlSFJOV0VKcVVqQnZNRlJITldGa1Ywa3lXVmRXYTA5WFJtbE9NazVyV21wbk1VNUVUWGxaZWsxNVRWUmpNVTR5U1RCYVJGRTBUVlJWZWxRd1VtNU9SVFZ1VUZReGFVNXRSbXhhUkd4b1dXcGthbHBIV1RST1ZGRjZUVzFOZWsxcVJUTk9WR1JwVGtkUk1FOUVSVEZOTURWMFZWUktVRlpIVGpOWFdIQktUVEZ3VlZwNlRrOWxiVkp4VkRCU1RrMXNjRmhWYld4T1ZqRndjMWRYY0VKbFJURjBWMjFzVDJGc1JUbFphbHBvV2xkUk5WbFhTVE5aTWxKdFQwUlZNRTE2U21wTmVrbDRUbnBWTTFscVVtdE9SR2Q0VGxST2ExSXphRFk9";
    MifoneClient.graphModule.connectServer(accessToken: TOKEN);
    callKitEvent();
  }

  Future<void> requestPermission() async {
    await Permission.microphone.request();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await MifoneClient.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void call(String phoneNumber) {
    MifoneClient.callModule
        .call(phoneNumber)
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void hangup() {
    MifoneClient.callModule
        .hangup()
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void answer() {
    MifoneClient.callModule.answer().then((value) => {print(value.toString())},
        onError: (error) => {print(error)});
  }

  void reject() {
    MifoneClient.callModule
        .reject()
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void pause() {
    MifoneClient.callModule
        .pause()
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void resume() {
    MifoneClient.callModule.resume().then((value) => {print(value.toString())},
        onError: (error) => {print(error)});
  }

  void transfer(String extension) {
    MifoneClient.callModule.transfer(extension).then(
        (value) => {print(value.toString())},
        onError: (error) => {print(error)});
  }

  void toggleMic() {
    MifoneClient.callModule
        .toggleMic()
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void toggleSpeaker() {
    MifoneClient.callModule
        .toggleSpeaker()
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void getMissedCalls() {
    MifoneClient.callModule
        .getMissedCalls()
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void getRegistrationState() {
    MifoneClient.callModule
        .getSipRegistrationState()
        .then((value) => {print(value)}, onError: (error) {
      print(error);
    });
  }

  void isMicEnabled() {
    MifoneClient.callModule.isMicEnabled().then((value) => print(value));
  }

  void isSpeakerEnabled() {
    MifoneClient.callModule.isSpeakerEnabled().then((value) => print(value));
  }

  void getCallId() {
    MifoneClient.callModule
        .getCallId()
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void sendDTMF(String dtmf) {
    MifoneClient.callModule
        .sendDTMF(dtmf)
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void refreshSipAccount() {
    MifoneClient.callModule
        .refreshSipAccount()
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void unregisterSipAccount() {
    MifoneClient.callModule
        .unregisterSipAccount()
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  void isSetStunServer() {
    MifoneClient.callModule
        .isStunServerEnable()
        .then((value) => {print(value)}, onError: (error) => {print(error)});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Running on: $_platformVersion\n')),
                OutlinedButton(
                  child: const Text('Call'),
                  onPressed: () {
                    call("9998");
                  },
                ),
                OutlinedButton(
                  child: const Text('Hangup'),
                  onPressed: () {
                    hangup();
                  },
                ),
                OutlinedButton(
                  child: const Text('Answer'),
                  onPressed: () {
                    answer();
                  },
                ),
                OutlinedButton(
                  child: const Text('Reject'),
                  onPressed: () {
                    reject();
                  },
                ),
                OutlinedButton(
                  child: const Text('Pause'),
                  onPressed: () {
                    pause();
                  },
                ),
                OutlinedButton(
                  child: const Text('Resume'),
                  onPressed: () {
                    resume();
                  },
                ),
                OutlinedButton(
                  child: const Text('Transfer'),
                  onPressed: () {
                    transfer("extension");
                  },
                ),
                OutlinedButton(
                  child: const Text('Toggle mic'),
                  onPressed: () {
                    toggleMic();
                  },
                ),
                OutlinedButton(
                  child: const Text('Toggle speaker'),
                  onPressed: () {
                    toggleSpeaker();
                  },
                ),
                OutlinedButton(
                  child: const Text('Send DTMF'),
                  onPressed: () {
                    sendDTMF("2#");
                  },
                ),
                OutlinedButton(
                  child: const Text('Get call id'),
                  onPressed: () {
                    getCallId();
                  },
                ),
                OutlinedButton(
                  child: const Text('Get missed calls'),
                  onPressed: () {
                    getMissedCalls();
                  },
                ),
                OutlinedButton(
                  child: const Text('Is mic enabled'),
                  onPressed: () {
                    isMicEnabled();
                  },
                ),
                OutlinedButton(
                  child: const Text('Is speaker enabled'),
                  onPressed: () {
                    isSpeakerEnabled();
                  },
                ),
                OutlinedButton(
                  child: const Text('Stun Server'),
                  onPressed: () {
                    isSetStunServer();
                  },
                ),
                OutlinedButton(
                  child: const Text('Turn Server'),
                  onPressed: () {},
                ),
                OutlinedButton(
                  child: const Text('Get registration state'),
                  onPressed: () {
                    getRegistrationState();
                  },
                ),
                OutlinedButton(
                  child: const Text('Refresh sip account'),
                  onPressed: () {
                    refreshSipAccount();
                  },
                ),
                OutlinedButton(
                  child: const Text('Unregister sip account'),
                  onPressed: () {
                    unregisterSipAccount();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    MifoneClient.callModule.eventStreamController.close();
    super.dispose();
  }
}
