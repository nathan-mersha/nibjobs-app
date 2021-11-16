import 'package:flutter/material.dart';
import 'package:nibjobs/widget/nav/menu.dart';

class WalletSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Menu.getAppBar(context, "Wallet Settings"),
      drawer: Menu.getSideDrawer(context),
      body: Container(
        child: Center(
          child: Text("Wallet Settings"),
        ),
      ),
    );
  }
}
