import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/dataBase/table_curl.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/factoryUser/api/saveLog.dart';
bool isSync = true;

class InternetStatus {
  static ValueNotifier<bool> isOnline = ValueNotifier(true);
}

class InternetStatusWatcher extends StatefulWidget {
  final Widget child;
  final Function(bool)? onStatusChange;

  const InternetStatusWatcher({Key? key, required this.child,this.onStatusChange})
      : super(key: key);

  @override
  State<InternetStatusWatcher> createState() => _InternetStatusWatcherState();
}

class _InternetStatusWatcherState extends State<InternetStatusWatcher> {
  bool _isConnected = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _subscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    final hasConnection = result != ConnectivityResult.none;
    if (hasConnection != _isConnected) {
      if(hasConnection)isSync=true;

      InternetStatus.isOnline.value = hasConnection;


      if (!mounted) return;
      widget.onStatusChange?.call(hasConnection);
      //notifier Updates

      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger != null) {
        printFunc("DEVICE OFFLINE : ${InternetStatus.isOnline.value}");
        messenger.showSnackBar(
          SnackBar(
            content: Text(hasConnection
                ? 'Internet Connected'
                : 'No Internet Connection'),
            backgroundColor: hasConnection ? Colors.green : Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      if (hasConnection &&isSync) {
        setState(() {
          _isConnected = hasConnection;
        });
        if(await hasLogs()){
          syncLog(context);
        }

      }else{
        setState(() {
          _isConnected = hasConnection;
        });
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (false&&!_isConnected )
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                color: Colors.red,
                padding: const EdgeInsets.all(8),
                child: const Center(
                  child: Text(
                    'No Internet Connection',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
