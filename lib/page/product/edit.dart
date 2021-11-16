import 'package:flutter/material.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/widget/nav/menu.dart';

class JobEditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Menu.getAppBar(context, "Item edit"),
      drawer: Menu.getSideDrawer(context),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 40, 40, 10),
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  children: [
                    Text(
                      "Issue Coupon",
                      textScaleFactor: 1.2,
                      style: const TextStyle(
                          color: CustomColor.GRAY_DARK, fontSize: 20),
                    ),
                    Text(
                      "Issue Coupon to attract more loyality",
                      textScaleFactor: 1.2,
                      style: const TextStyle(
                        color: CustomColor.GRAY_LIGHT,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      child: ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: [
                          TextFormField(
                            decoration: InputDecoration(labelText: "name"),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: "how much would you like to issue"),
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: "expiration date"),
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: "description"),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Text("discount"),
                            ],
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: "discount type"),
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: "value"),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            child: Text("issue coupon"),
                            onPressed: () {},
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Expanded(
                              child: Text(
                                  "Once have issued a coupon you are obligeted to hold on your promise, in both physical and virtual transaction")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
