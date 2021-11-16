import 'package:flutter/material.dart';
import 'package:nibjobs/widget/nav/menu.dart';

class SetupPasswordWalletSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Menu.getAppBar(context, "Setup password"),
      drawer: Menu.getSideDrawer(context),
      body: Container(
        child: Center(
          child: Text("Setup password Settings"),
        ),
      ),
    );
  }
}
