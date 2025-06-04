import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';

class ScanResultTile extends StatefulWidget {
  const ScanResultTile({super.key, required this.result, this.onTap});

  final ScanResult result;
  final VoidCallback? onTap;

  @override
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
  BluetoothConnectionState _connectionState = BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState> _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription = widget.result.device.connectionState.listen((state) {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  String getNiceHexArray(List<int> bytes) {
    return '[${bytes.map((i) => i.toRadixString(16).padLeft(2, '0')).join(', ')}]';
  }

  String getNiceManufacturerData(List<List<int>> data) {
    return data.map((val) => getNiceHexArray(val)).join(', ').toUpperCase();
  }

  String getNiceServiceData(Map<Guid, List<int>> data) {
    return data.entries.map((v) => '${v.key}: ${getNiceHexArray(v.value)}').join(', ').toUpperCase();
  }

  String getNiceServiceUuids(List<Guid> serviceUuids) {
    return serviceUuids.join(', ').toUpperCase();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Widget _buildTitle(BuildContext context) {
    if (widget.result.device.platformName.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.result.device.platformName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: darkBg, fontFamily: baseFont, fontWeight: FontWeight.w500, fontSize: 18),
          ),
          Text(widget.result.device.remoteId.str,
              style: TextStyle(
                  color: darkBg.withOpacity(0.8),
                  fontFamily: baseFont,
                  fontWeight: FontWeight.w300,
                  fontSize: 16))
        ],
      );
    } else {
      return Text(
        widget.result.device.remoteId.str,
        style: TextStyle(color: darkBg, fontFamily: baseFont, fontWeight: FontWeight.w500, fontSize: 18),
      );
    }
  }

  Widget _buildConnectButton(BuildContext context) {
    return TextButton(
      onPressed: widget.result.advertisementData.connectable ? widget.onTap : null,
      child: isConnected
          ? Text(
              'Open',
              style: TextStyle(
                  color: widget.result.advertisementData.connectable ? darkBg : Colors.grey,
                  fontFamily: baseFont,
                  fontSize: 18,
                  shadows: widget.result.advertisementData.connectable
                      ? [Shadow(color: Colors.black, blurRadius: 0.2)]
                      : []),
            )
          : Text('Connect',
              style: TextStyle(
                  color: widget.result.advertisementData.connectable ? darkBg : Colors.black.withOpacity(0.3),
                  fontFamily: baseFont,
                  fontSize: 18,
                  shadows: widget.result.advertisementData.connectable
                      ? [Shadow(color: Colors.black, blurRadius: 0.2, offset: Offset(0.4, 0.4))]
                      : [])),
    );
  }

  Widget _buildAdvRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              style:
                  TextStyle(color: darkBg, fontFamily: baseFont, fontWeight: FontWeight.w500, fontSize: 16)),
          const SizedBox(
            width: 6.0,
          ),
          Text(
            ":",
            style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, fontSize: 16, fontFamily: baseFont),
          ),
          const SizedBox(
            width: 6.0,
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  color: darkBg.withOpacity(0.8),
                  fontFamily: baseFont,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var adv = widget.result.advertisementData;
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: darkBg, width: 0.5), borderRadius: BorderRadius.circular(15)),
        title: _buildTitle(context),
        leading: Text(
          widget.result.rssi.toString(),
          style: TextStyle(color: darkBg, fontFamily: baseFont, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        trailing: _buildConnectButton(context),
        children: <Widget>[
          if (adv.advName.isNotEmpty) _buildAdvRow(context, 'Name', adv.advName),
          if (adv.txPowerLevel != null) _buildAdvRow(context, 'Tx Power Level', '${adv.txPowerLevel}'),
          if ((adv.appearance ?? 0) > 0)
            _buildAdvRow(context, 'Appearance', '0x${adv.appearance!.toRadixString(16)}'),
          if (adv.msd.isNotEmpty)
            _buildAdvRow(context, 'Manufacturer Data', getNiceManufacturerData(adv.msd)),
          if (adv.serviceUuids.isNotEmpty)
            _buildAdvRow(context, 'Service UUIDs', getNiceServiceUuids(adv.serviceUuids)),
          if (adv.serviceData.isNotEmpty)
            _buildAdvRow(context, 'Service Data', getNiceServiceData(adv.serviceData)),
        ],
      ),
    );
  }
}
