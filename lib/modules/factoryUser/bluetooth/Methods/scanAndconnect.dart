import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<BluetoothDevice?> scanDeviceByMACId(String macID) async {
  print("Old MACId: $macID");

  await FlutterBluePlus.startScan(timeout: const Duration(seconds: 45));

  await for (final results in FlutterBluePlus.scanResults) {
    for (var r in results) {
      print("Device MACId's : ${r.device.remoteId}");

      if (r.device.remoteId.toString() == macID) {
        await FlutterBluePlus.stopScan();

        ////////// Printing Advertisement Data ///////////
        AdvertisementData advData = r.advertisementData;
        print("Connected: ${r.device.isConnected}");
        print("Connected: ${r.device.bondState.first}");
        print("Connected: ${r.device.bondState.first}");
        print("adv Data: ${advData}");
        print("Manufacturer Data: ${advData.manufacturerData}");
        print("Service UUIDs: ${advData.serviceUuids}");
        print("Tx Power: ${advData.txPowerLevel}");
        print("Connectable: ${advData.connectable}");
        print("Local Name: ${advData.localName}");
        //////////////////////////////////////////////////////

        print("Device returning from the Scan Method: ${r.device.remoteId}");
        return r.device;
      }
    }
  }
  print("$macID this Device is not found");
  return null;
}

Future<bool> connectToDevice(BluetoothDevice device) async {
  print(" Trying to connect to : ${device.remoteId}");

  try {
    await device.connect(autoConnect: false);
    if (device.isConnected) {
      print(" Connected to device: ${device.remoteId}");
      return true;
    }
  } catch (e) {
    print("Expection while connecting: $e");
  }

  return false;
}