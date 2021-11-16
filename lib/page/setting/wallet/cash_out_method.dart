import 'package:flutter/material.dart';
import 'package:nibjobs/widget/nav/menu.dart';

class CashOutMethodWalletSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Menu.getAppBar(context, "Cash-out Methods"),
      drawer: Menu.getSideDrawer(context),
      body: Container(
        child: Center(
          child: Text("Cash-out methods"),
        ),
      ),
    );
  }
}
