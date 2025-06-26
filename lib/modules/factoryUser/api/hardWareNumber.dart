import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tracker_firmware/Const_TermAndFunction/api/serviceUtils.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/entity/getNumberModel.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';

// HardWare number

Future<void> loadHardWareNumber(BuildContext context) async {
  final box = Hive.box<GetNumberModel>('$getNumberHiveBox');

  if (box.isEmpty) {
    await getHardwareNumber(context);
  }

  printFunc("LENGTH OF BOX : ${box.length}");
}

Future<void> getHardwareNumber(BuildContext context) async {
  final box = Hive.box<GetNumberModel>('$getNumberHiveBox');

  await ApiService.callApi(
      context: context,
      method: 'GET',
      endpoint: ApiEndpoints.getHardwareNumber,
      headerAuth: true,
      onSuccess: (data) async {
        printFunc("HardWare number DAta : $data");
        await box.clear();

        for (var item in data) {
          final hardwareNumber = GetNumberModel.fromJson(item);
          box.add(hardwareNumber);
        }
        printFunc("BOX HIVE : ${box.length}");
      });
}

//ALL Clients
Future<List<Map<String, dynamic>>> getAllClients(BuildContext context) async {
  List<Map<String, dynamic>> allClients = [{}];

  await ApiService.callApi(
      context: context,
      method: 'GET',
      endpoint: ApiEndpoints.getAllClients,
      headerAuth: true,
      onSuccess: (data) async {
        allClients.clear();
        for (Map<String, dynamic> client in data) {
          allClients.add(client);
        }
        printFunc("DEOMDEMEODE : $allClients");
      });

  return allClients;
}
