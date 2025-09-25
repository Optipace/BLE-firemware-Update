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
          style: TextStyle(
              fontFamily: baseFont,
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: lightBg),
        ),
        toolbarHeight: screenSize.height / 11.5,
        backgroundColor: darkBg,
        elevation: 5,
        shadowColor: darkBg,
      ),
      backgroundColor: UpdatedBG,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 11,),
            for (int i = 0; i < batchList.length; i++)
              GestureDetector(
                onTap: () async {
                  printFunc("Inside getLogsByBatchId ${batchList[i]["id"]} ");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => BatchLogs(item: batchList[i])));
                },
                child: Container(
                    width: screenSize.width,
                    padding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    margin:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: darkBg, width: 1),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(color: darkBg, blurRadius: 0.8)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
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
                                  width: 4,
                                ),
                                Container(
                                  width: screenSize.width/2.7,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        batchList[i]["name"] ?? "",
                                        style: TextStyle(
                                            color: darkBg,
                                            fontFamily: baseFont,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
