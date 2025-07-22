import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';


class EionicAllInOnePage extends StatefulWidget {
  @override
  State<EionicAllInOnePage> createState() => _EionicAllInOnePageState();
}

class _EionicAllInOnePageState extends State<EionicAllInOnePage> {
  final flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? device;
  BluetoothCharacteristic? configChar;
  BluetoothCharacteristic? thresholdChar;
  BluetoothCharacteristic? calibrationChar;

  final serviceUUID = Guid("f043176a-5168-11ee-be56-0242ac120012");
  final configCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120014");
  final thresholdCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120016");
  final calibrationCharUUID = Guid("f043176a-5168-11ee-be56-0242ac120017");

  String status = "Disconnected";
  String deviceName = "-";

  // Controllers
  final batteryTypeCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final serialCtrl = TextEditingController();
  final custIdCtrl = TextEditingController();
  final productIdCtrl = TextEditingController();
  final chemistryTypeCtrl = TextEditingController();
  final maxVoltageCtrl = TextEditingController();
  final maxThresholdCtrl = TextEditingController();
  final minThresholdCtrl = TextEditingController();
  final minVoltageCtrl = TextEditingController();
  final nominalVoltageCtrl = TextEditingController();
  final minTempCtrl = TextEditingController();
  final maxTempCtrl = TextEditingController();
  final tempCalibCtrl = TextEditingController();

  int batteryFactor = 1;

  Future<void> requestPermissions() async {
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothAdvertise.request();
  }
  void scanAndConnect() async {
    await requestPermissions();
    setState(() => status = "Scanning...");

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 45));

    FlutterBluePlus.scanResults.listen((results) async {
      for (var r in results) {
        print("Found device: ${r.device.name}");

        if (r.device.name.startsWith("EIONIC")) {
          // ✅ Read Advertisement Data BEFORE connecting
          AdvertisementData advData = r.advertisementData;
          print("Connected: ${r.device.name}");

          print("adv Data: ${advData}");
          print("Manufacturer Data: ${advData.manufacturerData}");
          print("Service UUIDs: ${advData.serviceUuids}");
          print("Tx Power: ${advData.txPowerLevel}");
          print("Connectable: ${advData.connectable}");
          print("Local Name: ${advData.localName}");

          await Future.delayed(Duration(seconds: 2));

          try {
            await r.device.connect(autoConnect: false);
          } catch (_) {}

          device = r.device;

          setState(() {
            status = "Connected";
            deviceName = device!.name;
          });

          print("Connected to: ${device}");
          print("Connected to: ${device?.services.toString()}");
          print("Connected to: ${device?.services.length}");

          List<BluetoothService> services = await device!.discoverServices();
          print("Total Services Found: ${services.length}");
          print("Total Services Found1: ${services}");

          for (var service in services) {
            print("Service UUID: ${service.uuid}");
            for (var characteristic in service.characteristics) {
              print("  Characteristic UUID: ${characteristic.uuid}");
              print("    Properties: ${characteristic.properties}");
            }
          }  print("Services Found: $services");

          for (var s in services) {
            if (s.uuid == serviceUUID) {
              for (var c in s.characteristics) {
                if (c.uuid == configCharUUID) configChar = c;
                if (c.uuid == thresholdCharUUID) thresholdChar = c;
                if (c.uuid == calibrationCharUUID) calibrationChar = c;
              }
            }
          }
          break;
        }
      }
    });
  }


  void disconnect() async {
    if (device != null) {
      await device!.disconnect();
      setState(() {
        status = "Disconnected";
        deviceName = "-";
      });
    }
  }

  void sendConfig() async {
    print("null");
    if (configChar == null) return;
    print("null2");
    try {
      int batteryType = int.parse(batteryTypeCtrl.text);
      batteryFactor = batteryType;
      List<String> parts = dateCtrl.text.split("-");
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[2]);
      int serial = int.parse(serialCtrl.text);
      int cust = int.parse(custIdCtrl.text);
      int product = int.parse(productIdCtrl.text);
      int chem = int.parse(chemistryTypeCtrl.text);

      var data = List<int>.filled(13, 0);
      data[0] = '['.codeUnitAt(0);
      data[1] = batteryType;
      data[2] = day;
      data[3] = month;
      data[4] = year & 0xFF;
      data[5] = (year >> 8) & 0xFF;
      data[6] = serial & 0xFF;
      data[7] = (serial >> 8) & 0xFF;
      data[8] = cust;
      data[9] = product & 0xFF;
      data[10] = (product >> 8) & 0xFF;
      data[11] = chem;
      data[12] = ']'.codeUnitAt(0);

      await configChar!.write(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Configuration sent")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid input: $e")));
    }
  }

  void sendVoltageThresholdsold() async {
    if (thresholdChar == null) return;
    try {
      print("hello voltage");
      double maxV = double.parse(maxVoltageCtrl.text);
      double maxT = double.parse(maxThresholdCtrl.text);
      double minT = double.parse(minThresholdCtrl.text);
      double minV = double.parse(minVoltageCtrl.text);
      double nomV = double.parse(nominalVoltageCtrl.text);
      print("voltage value--------------------------->${maxV}\n${maxT}\n${minT}\n${minV}\n${nomV}");
      var data = List<int>.filled(12, 0);
      data[0] = 91;
      ByteData.view(Uint8List.fromList(data).buffer).setUint16(1, (maxV * batteryFactor * 100).round(), Endian.little);
      ByteData.view(Uint8List.fromList(data).buffer).setUint16(3, (maxT * batteryFactor * 100).round(), Endian.little);
      ByteData.view(Uint8List.fromList(data).buffer).setUint16(5, (minT * batteryFactor * 100).round(), Endian.little);
      ByteData.view(Uint8List.fromList(data).buffer).setUint16(7, (minV * batteryFactor * 100).round(), Endian.little);
      ByteData.view(Uint8List.fromList(data).buffer).setUint16(9, (nomV * batteryFactor * 100).round(), Endian.little);
      data[11] = 93;

      await thresholdChar!.write(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Voltage thresholds sent")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid voltage input: $e")));
    }
  }
  void sendVoltageThresholds() async {
    if (thresholdChar == null) return;

    try {
      double maxVoltage = double.parse(maxVoltageCtrl.text);
      double maxThreshold = double.parse(maxThresholdCtrl.text);
      double minThreshold = double.parse(minThresholdCtrl.text);
      double minVoltage = double.parse(minVoltageCtrl.text);
      double nominalVoltage = double.parse(nominalVoltageCtrl.text);

      int batteryType = int.parse(batteryTypeCtrl.text);
      batteryFactor = batteryType;
      print("bfactor------------>$batteryFactor");
      int factor = batteryFactor == 0 ? 1 : batteryFactor;

      double maxV = maxVoltage * factor;
      double maxT = maxThreshold * factor;
      double minT = minThreshold * factor;
      double minV = minVoltage * factor;
      double nomV = nominalVoltage * factor;

      print("Raw Inputs:");
      print("Max Voltage: $maxVoltage");
      print("Max Threshold: $maxThreshold");
      print("Min Threshold: $minThreshold");
      print("Min Voltage: $minVoltage");
      print("Nominal Voltage: $nominalVoltage");

      print("After applying battery factor ($factor):");
      print("maxV = $maxV");
      print("maxT = $maxT");
      print("minT = $minT");
      print("minV = $minV");
      print("nomV = $nomV");

      final data = Uint8List(12);
      final view = ByteData.view(data.buffer);

      data[0] = 91; // '['
      view.setUint16(1, (maxV * 100).round(), Endian.little);
      view.setUint16(3, (maxT * 100).round(), Endian.little);
      view.setUint16(5, (minT * 100).round(), Endian.little);
      view.setUint16(7, (minV * 100).round(), Endian.little);
      view.setUint16(9, (nomV * 100).round(), Endian.little);
      data[11] = 93; // ']'

      print("Final Bytes to Send: ${data.join(', ')}");

      await thresholdChar!.write(data);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Voltage thresholds sent successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid voltage input: $e")),
      );
      print("Error: $e");
    }
  }


  void sendTemperatureThresholds() async {
    if (thresholdChar == null) return;
    try {
      int minTemp = int.parse(minTempCtrl.text);
      int maxTemp = int.parse(maxTempCtrl.text);

      var data = List<int>.filled(6, 0);
      data[0] = 123;
      ByteData.view(Uint8List.fromList(data).buffer).setInt16(1, minTemp, Endian.little);
      ByteData.view(Uint8List.fromList(data).buffer).setInt16(3, maxTemp, Endian.little);
      data[5] = 125;

      await thresholdChar!.write(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Temperature thresholds sent")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid temperature input: $e")));
    }
  }

  void sendTempCalibration() async {
    if (calibrationChar == null) return;
    try {
      int temp = int.parse(tempCalibCtrl.text);
      var data = [91, 'T'.codeUnitAt(0), temp & 0xFF, (temp >> 8) & 0xFF, 93];
      await calibrationChar!.write(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Temperature calibration sent")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid calibration input: $e")));
    }
  }

  Widget buildInput(String label, TextEditingController ctrl, {TextInputType type = TextInputType.number}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: ctrl,
        keyboardType: type,
        decoration: InputDecoration(border: OutlineInputBorder(), labelText: label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("EIONIC Device Manager")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Status: $status", style: TextStyle(fontSize: 18)),
            Text("Device: $deviceName"),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: scanAndConnect, icon: Icon(Icons.bluetooth_searching), label: Text("Connect")),
                ElevatedButton.icon(
                    onPressed: disconnect, icon: Icon(Icons.bluetooth_disabled), label: Text("Disconnect")),
              ],
            ),
            Divider(),
            Text("Configure Device", style: TextStyle(fontWeight: FontWeight.bold)),

            DropdownButtonFormField<String>(
              value: null,
              decoration: InputDecoration(labelText: "Battery Type", border: OutlineInputBorder()),
              items: ["4", "6", "8", "12", "14", "16"]
                  .map((val) => DropdownMenuItem(value: val, child: Text("$val s")))
                  .toList(),
              onChanged: (val) => batteryTypeCtrl.text = val ?? "",
            ),

            SizedBox(height: 8),
            TextFormField(
              controller: dateCtrl,
              decoration: InputDecoration(
                labelText: "Manufacture Date",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  dateCtrl.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                }
              },
            ),

            SizedBox(height: 8),
            buildInput("Serial Number", serialCtrl),

            buildInput("Customer ID (0-99)", custIdCtrl),

            DropdownButtonFormField<String>(
              value: null,
              decoration: InputDecoration(labelText: "Product ID", border: OutlineInputBorder()),
              items: ["4637"].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
              onChanged: (val) => productIdCtrl.text = val ?? "",
            ),

            DropdownButtonFormField<String>(
              value: null,
              decoration: InputDecoration(labelText: "Chemistry Type", border: OutlineInputBorder()),
              items: [{"label": "Li-ion", "value": "03"}]
                  .map((item) => DropdownMenuItem(value: item["value"], child: Text(item["label"]!)))
                  .toList(),
              onChanged: (val) => chemistryTypeCtrl.text = val ?? "",
            ),

            SizedBox(height: 12),
            ElevatedButton(onPressed: sendConfig, child: Text("Send Configuration")),
            Divider(),
            Text("Voltage Thresholds", style: TextStyle(fontWeight: FontWeight.bold)),
            buildInput("Max Voltage", maxVoltageCtrl),
            buildInput("Max Threshold", maxThresholdCtrl),
            buildInput("Min Threshold", minThresholdCtrl),
            buildInput("Min Voltage", minVoltageCtrl),
            buildInput("Nominal Voltage", nominalVoltageCtrl),
            ElevatedButton(onPressed: sendVoltageThresholds, child: Text("Send Voltage Thresholds")),
            Divider(),
            Text("Temperature Thresholds", style: TextStyle(fontWeight: FontWeight.bold)),
            buildInput("Min Temperature", minTempCtrl),
            buildInput("Max Temperature", maxTempCtrl),
            ElevatedButton(onPressed: sendTemperatureThresholds, child: Text("Send Temperature Thresholds")),
            Divider(),
            Text("Calibration", style: TextStyle(fontWeight: FontWeight.bold)),
            buildInput("Reference Temperature", tempCalibCtrl),
            ElevatedButton(onPressed: sendTempCalibration, child: Text("Send Temp Calibration")),
          ],
        ),
      ),
    );
  }
}
