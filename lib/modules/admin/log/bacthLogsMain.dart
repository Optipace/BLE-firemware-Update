import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tracker_firmware/Const_TermAndFunction/constants.dart';
import 'package:tracker_firmware/Const_TermAndFunction/generalMethods.dart';
import 'package:tracker_firmware/modules/admin/log/batchLogs.dart';
import 'package:tracker_firmware/modules/admin/log/sortByStatus.dart';

class BatchLogsMain extends StatelessWidget {
  List<Map<String, dynamic>> batchList = [{}];
  var allLogs;

  BatchLogsMain({required this.batchList, required this.allLogs});

  //Counting of batches Logs
  int countLogs(Map<String, dynamic> item) {
    int count = 0;
    for (int index = 0; index < allLogs.length; index++) {
      if (item["name"] == allLogs[index]["Batch"]) {
        count++;
      }
    }
    return count;
  }

  var sortedBatchLogs;

  @override
  Widget build(BuildContext context) {
    sortedBatchLogs = sortByStatus(batchList);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: lightBg),
        title: Text(
          "Batches",
          style: TextStyle(fontFamily: baseFont, fontWeight: FontWeight.w800, fontSize: 24, color: lightBg),
        ),
        toolbarHeight: screenSize.height / 11.5,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
      ),
      backgroundColor: lightBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < batchList.length; i++)
              GestureDetector(
                onTap: () {
                  printFunc("Inside ${batchList[i]["batchName"]} ");
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => BatchLogs(batchList[i])));
                },
                child: Container(
                    width: screenSize.width,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: second_lightBg,
                        border: Border.all(color: darkBg, width: 1),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(color: darkBg, blurRadius: 0.8)]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Text(
                                "Batch Name : ",
                                style: TextStyle(
                                    color: darkBg,
                                    fontFamily: baseFont,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                batchList[i]["name"] ?? "",
                                style: TextStyle(
                                    color: darkBg,
                                    fontFamily: baseFont,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          CupertinoIcons.chevron_right_2,
                          color: darkBg,
                          weight: 40,
                          size: 28,
                        )
                      ],
                    )),
              )
          ],
        ),
      ),
    );
  }
}
