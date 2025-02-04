import 'package:audiocall/bloc/call/call_bloc.dart';
import 'package:audiocall/bloc/call/call_event.dart';
import 'package:audiocall/bloc/call/call_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';


class CallScreen extends StatefulWidget {
  final String chatId;
  final String callerId;
  final String receiverId;

  const CallScreen({
    super.key,
    required this.chatId,
    required this.callerId,
    required this.receiverId,
  });

  @override
  CallScreenState createState() => CallScreenState();
}

class CallScreenState extends State<CallScreen> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  @override
  void initState() {
    super.initState();
    _initializeWebRTC();
    _listenForIncomingCalls();
  }

  Future<void> _initializeWebRTC() async {
    _localStream = await navigator.mediaDevices.getUserMedia({'audio': true, 'video': false});
    _peerConnection = await createPeerConnection({'iceServers': [{'url': 'stun:stun.l.google.com:19302'}]});
    _peerConnection?.addStream(_localStream!);
  }

  void _listenForIncomingCalls() {
    FirebaseFirestore.instance
        .collection('calls')
        .doc(widget.receiverId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists && snapshot.data()?['status'] == 'incoming') {
        _showIncomingCallDialog(snapshot.data()?['callerId']);
      }
    });
  }

  void _showIncomingCallDialog(String callerId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Incoming Call"),
          content: Text("$callerId is calling..."),
          actions: [
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('calls')
                    .doc(widget.receiverId)
                    .update({'status': 'accepted'});
                Navigator.pop(context);
                context.read<CallBloc>().add(StartCall(
                      chatId: widget.chatId,
                      callerId: callerId,
                      receiverId: widget.receiverId,
                    ));
              },
              child: const Text("Accept"),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('calls')
                    .doc(widget.receiverId)
                    .update({'status': 'rejected'});
                Navigator.pop(context);
              },
              child: const Text("Reject"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Call"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('calls')
                  .doc(widget.receiverId)
                  .set({
                'callerId': widget.callerId,
                'receiverId': widget.receiverId,
                'status': 'incoming',
              });
            },
            icon: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.phone),
            ),
            color: Colors.white,
            iconSize: 30,
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => CallBloc(),
        child: BlocBuilder<CallBloc, CallState>(
          builder: (context, state) {
            if (state is CallInProgress) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Call in Progress..."),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('calls')
                            .doc(widget.receiverId)
                            .delete();
                        context.read<CallBloc>().add(EndCall());
                      },
                      child: const Text("End Call"),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: Text("Waiting for a call..."),
            );
          },
        ),
      ),
    );
  }
}
