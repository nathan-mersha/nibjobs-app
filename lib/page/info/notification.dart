import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/dal/notification_dal.dart';
import 'package:nibjobs/model/notification_model.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/nib_custom_icons_icons.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NotificationsPageState();
  }
}

class _NotificationsPageState extends State<NotificationsPage> {
  double? spacingBetweenComponents;
  double? textFont;
  double? buttonFont;
  int notificationCount = 0;

  setDeviceSpecificValues(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    if (height < 500) {
      spacingBetweenComponents = 30;
      textFont = 12;
      buttonFont = 14;
    } else if (height >= 500 && height <= 600) {
      // Nexus S & HVGA 3.2
      spacingBetweenComponents = 30;
      textFont = 12;
      buttonFont = 14;
    } else if (height > 600 && height <= 700) {
      // Nexus 5x
      spacingBetweenComponents = 60;
      textFont = 14;
      buttonFont = 16;
    } else {
      // Pixel 3 xL
      spacingBetweenComponents = 60;
      textFont = 14;
      buttonFont = 16;
    }
  }

  TextStyle getValueStyle() {
    return const TextStyle(fontSize: 14, color: CustomColor.TEXT_DARK);
  }

  TextStyle getSubTitleStyle() {
    return const TextStyle(fontSize: 16, color: CustomColor.GRAY_LIGHT);
  }

  String formatTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    return "${dateTime.day.toString()} - ${dateTime.month.toString()} - ${dateTime.year.toString()}";
  }

  List<Row> getInvoiceDetail(String rawServiceDetail) {
    Map<String, dynamic> serviceDetail = json.decode(rawServiceDetail);
    List<Row> rows = [];
    serviceDetail.forEach((String key, dynamic value) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            key,
            style: getSubTitleStyle(),
          ),
          Text(
            value.toString(),
            style: getValueStyle(),
          )
        ],
      ));
    });

    return rows;
  }

  Widget recentNotificationsTile(NotificationModel notification, int index) {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: LightColor.iconColor, style: BorderStyle.none),
        // color:
        // isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
      ),
      child: GestureDetector(
        onTap: () {
          if (notification.notificationServiceName!
              .toLowerCase()
              .contains("welcome to kelem (we have sent you a gift)")) {
            String numberCode = notification.notificationServiceMessage!
                .toLowerCase()
                .split("airtime")[1]
                .replaceAll("-", "")
                .replaceAll("\n", "");
            makeWebCall("tel:${Uri.encodeComponent("*805*$numberCode#")}");
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  notification.notificationServiceName!,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          notification.notificationServiceMessage!,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          //textAlign: TextAlign.justify,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: (notification.notificationServiceName!
                          .toLowerCase()
                          .contains(
                              "welcome to kelem (we have sent you a gift)")),
                      child: Text(
                        StringRsr.get(LanguageKey.CLICK_HERE_TO_DIAL,
                            firstCap: true)!,
                        style: const TextStyle(color: CustomColor.PRIM_DARK),
                      ),
                    ),
                    Text(
                      timeago.format(DateTime.parse(
                          notification.notificationServiceDate!)),
                      style: const TextStyle(color: CustomColor.PRIM_DARK),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getAppBar2(BuildContext context, String job,
      {bool showCategory = false}) {
    return AppBar(
      backgroundColor: LightColor.background,

      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        color: CustomColor.GRAY_DARK,
        icon: const Icon(Icons.arrow_back_outlined),
      ),
      title: Text(
        StringRsr.get(LanguageKey.NOTIFICATION, firstCap: true)!,
        style: const TextStyle(color: CustomColor.GRAY_LIGHT),
      ),
      actions: <Widget>[],
      //showCategory ? CategoryMenu() : Container()
      //backgroundColor: LightColor.lightGrey,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    setDeviceSpecificValues(context);
    // if(notificationList!){
    //   return Center(child: Text("something is here"),);
    // }

    return Scaffold(
      backgroundColor: LightColor.lightGrey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: getAppBar2(context, "NOTIFICATION")),
      body: FutureBuilder(
        future: getRecentNotifications(),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return noNotifications();
          } else {
            List<NotificationModel>? transactionLists =
                projectSnap.data as List<NotificationModel>? ?? [];
            if (transactionLists != null) {
              if (transactionLists.isEmpty) {
                return noNotifications();
              } else {
                notificationCount = transactionLists.length;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                            itemCount: transactionLists.length,
                            itemBuilder: (BuildContext context, int index) {
                              return recentNotificationsTile(
                                  transactionLists[index], index);
                            }),
                      )
                    ],
                  ),
                );
              }
            } else {
              return noNotifications();
            }
          }
        },
      ),
    );
  }

  Future<List<NotificationModel>> getRecentNotifications() {
    return NotificationDAL.find();
  }

  Widget noNotifications() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            NibCustomIcons.notification,
            size: 40,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: spacingBetweenComponents,
          ),
          Text(
            StringRsr.get(LanguageKey.NO_NOTIFICATIONS_FOUND)!,
            style: Theme.of(context)
                .textTheme
                .subtitle2!
                .copyWith(color: CustomColor.TEXT_DARK),
          ),
          Container(
            child: TextButton(
              child: Text(
                StringRsr.get(LanguageKey.REFRESH)!,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: buttonFont),
              ),
              onPressed: () {
                // todo : refresh here.
              },
            ),
          )
        ],
      ),
    );
  }
}
