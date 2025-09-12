import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

// Future<BluetoothDevice?> scanDeviceByMACId(String macID) async {
//   BluetoothDevice? selectedDevice;
//   printFunc("Old MACId: $macID");
//
//   await FlutterBluePlus.startScan(timeout: const Duration(seconds: 45));
//
//   await for (final results in FlutterBluePlus.scanResults) {
//     for (var r in results) {
//       printFunc("Device MACId's : ${r.device.remoteId}");
//
//       if (r.device.remoteId.toString() == macID) {
//         await FlutterBluePlus.stopScan();
//
//         ////////// printFuncing Advertisement Data ///////////
//         AdvertisementData advData = r.advertisementData;
//         printFunc("Connected: ${r.device.isConnected}");
//         printFunc("Connected: ${r.device.bondState.first}");
//         printFunc("Connected: ${r.device.bondState.first}");
//         printFunc("adv Data: ${advData}");
//         printFunc("Manufacturer Data: ${advData.manufacturerData}");
//         printFunc("Service UUIDs: ${advData.serviceUuids}");
//         printFunc("Tx Power: ${advData.txPowerLevel}");
//         printFunc("Connectable: ${advData.connectable}");
//         printFunc("Local Name: ${advData.localName}");
//         //////////////////////////////////////////////////////
//
//         printFunc("Device returning from the Scan Method: ${r.device.remoteId}");
//         return r.device;
//       }
//     }
//     printFunc("THis Device is null");
//   }
//
//   printFunc("$macID this Device is not found");
//
//   return null;
// }

Future<BluetoothDevice?> scanDeviceByMACId(String macID) async {
  BluetoothDevice? selectedDevice;
  printFunc("Old MACId: $macID");

  await FlutterBluePlus.startScan(timeout: const Duration(seconds: 45));

//delay after scanning that helps if the device not found
  await Future.delayed(Duration(seconds: 1));

  while (FlutterBluePlus.isScanningNow) {
    final results = await FlutterBluePlus.scanResults.first;

    for (var r in results) {
      printFunc("Device MACId's : ${r.device.remoteId}");

      if (r.device.remoteId.toString() == macID) {
        await FlutterBluePlus.stopScan();

        ////////// Printing Advertisement Data ///////////
        AdvertisementData advData = r.advertisementData;
        printFunc("Connected: ${r.device.isConnected}");
        printFunc("adv Data: ${advData}");
        printFunc("Manufacturer Data: ${advData.manufacturerData}");
        printFunc("Service UUIDs: ${advData.serviceUuids}");
        printFunc("Tx Power: ${advData.txPowerLevel}");
        printFunc("Connectable: ${advData.connectable}");
        printFunc("Local Name: ${advData.localName}");
        printFunc("scanned config device : ${r}");
        //////////////////////////////////////////////////////

        printFunc(
            "Device returning from the Scan Method: ${r.device.remoteId}");
        return r.device;
      }
    }

    // Small delay to avoid busy waiting
    await Future.delayed(Duration(milliseconds: 100));
  }

  await FlutterBluePlus.stopScan();
  printFunc("$macID this Device is not found");
  return selectedDevice;
}

Future<bool> connectToDevice(BluetoothDevice device) async {
  printFunc(" Trying to connect to : ${device.remoteId}");

  try {
    await device.connect(autoConnect: false);
    if (device.isConnected) {
      printFunc(" Connected to device: ${device.remoteId}");
      return true;
    }
  } catch (e) {
    printFunc("Expection while connecting: $e");
  }

  return false;
}
