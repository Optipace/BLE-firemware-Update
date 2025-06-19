import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetStatusWatcher extends StatefulWidget {
  final Widget child;

  const InternetStatusWatcher({Key? key, required this.child}) : super(key: key);

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
    _subscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final hasConnection = result != ConnectivityResult.none;
    if (hasConnection != _isConnected) {
      if (!mounted) return;

      setState(() {
        _isConnected = hasConnection;
      });

      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger != null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(hasConnection ? 'Internet Connected' : 'No Internet Connection'),
            backgroundColor: hasConnection ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
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
        if (!_isConnected)
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
