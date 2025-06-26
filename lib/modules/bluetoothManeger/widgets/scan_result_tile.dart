import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/modules/bluetoothManeger/screens/device_screen.dart';
import 'package:tracker_firmware/modules/bluetoothManeger/screens/methods.dart';

class ScanResultTile extends StatefulWidget {
  final ScanResult result;
  final VoidCallback? onTap;
  final payload_class_data? bleData;

  const ScanResultTile({
    super.key,
    required this.result,
    this.onTap,
    this.bleData,
  });

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

  bool get isConnected => _connectionState == BluetoothConnectionState.connected;

  Widget _buildTitle(BuildContext context) {
    if (widget.result.device.platformName.isNotEmpty) {
      return Column(
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
          ? Text('Open',
          style: TextStyle(
              color: darkBg,
              fontFamily: baseFont,
              fontSize: 18,
              shadows: [Shadow(color: Colors.black, blurRadius: 0.2)]))
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
              style: TextStyle(color: darkBg, fontFamily: baseFont, fontWeight: FontWeight.w500, fontSize: 16)),
          const SizedBox(width: 6.0),
          Text(":",
              style: TextStyle(color: darkBg, fontWeight: FontWeight.w500, fontSize: 16, fontFamily: baseFont)),
          const SizedBox(width: 6.0),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    color: darkBg.withOpacity(0.8),
                    fontFamily: baseFont,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
                softWrap: true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final adv = widget.result.advertisementData;
    final data = widget.bleData;

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
          if (data != null) ...[
            _buildAdvRow(context, 'MAC ID', data.mac_id),
            _buildAdvRow(context, 'Battery SN', '${data.batterySerialNumber}'),
            _buildAdvRow(context, 'Live Battery', '${data.liveBattery} V'),
            _buildAdvRow(context, 'Serial No.', data.serialNumber),
            _buildAdvRow(context, 'Protocol ID', data.protocolId),
            _buildAdvRow(context, 'Payload ID', data.payloadId),
            _buildAdvRow(context, 'Max Battery', '${data.maximumBattery} V'),
            _buildAdvRow(context, 'Master Timer', '${data.masterTimer}'),
            _buildAdvRow(context, 'Last Charge Time', '${data.lastChargeTime}'),
            _buildAdvRow(context, 'Last Discharge Time', '${data.lastDischargeTime}'),
            _buildAdvRow(context, 'Cycle Count', '${data.batteryLifeCycles}'),
          ] else ...[
            _buildAdvRow(context, 'BLE Status', 'Parsing...\n$data'),
          ],
        ],
      ),
    );
  }
}
