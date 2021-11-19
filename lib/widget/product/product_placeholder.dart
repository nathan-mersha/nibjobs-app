import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/widget/product/product_view.dart';

class JobPlaceholder extends StatelessWidget {
  final Job? job;
  final String? size;

  JobPlaceholder({this.job, this.size});

  static final List<dynamic> colorList = [
    0xff220055,
    0xff0b0b28,
    0xff22002b,
    0xff1c241f,
    0xff0b2822,
    0xff00222b,
    0xff280b17,
    0xff241c1f,
    0xff222b00,
    0xff280b0b,
    0xff2b2200,
  ];

  final random = Random().nextInt(colorList.length);

  @override
  Widget build(BuildContext context) {
    return job!.category == "book" ? bookView(job!) : iotView(job!);
  }

  Widget bookView(Job job) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: Card(
        color: Color(colorList[random]),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (size == JobView.SIZE_SMALL)
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        job.title!,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.6,
                        maxLines: 3,
                      ),
                    ),
                  )
                else
                  Text(
                    job.title!,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.6,
                    maxLines: 3,
                  ),
                const Text("by",
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                    textScaleFactor: 0.7,
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  flex: 1,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      job.contractType!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      textScaleFactor: 0.7,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
                Text(
                  job.contractType!,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  textScaleFactor: 0.8,
                  overflow: TextOverflow.fade,
                )
              ],
            )),
      ),
    );
  }

  Widget iotView(Job job) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        color: Color(colorList[random]),
        child: Center(
            child: Icon(
          Icons.developer_board,
          color: Colors.white.withOpacity(0.2),
          size: 50,
        )),
      ),
    );
  }
}
