import 'package:flutter/material.dart';
import 'package:nibjobs/widget/nav/menu.dart';

class LoginWalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Menu.getAppBar(context, "Login"),
      drawer: Menu.getSideDrawer(context),
      body: Container(
        child: Center(
          child: Text("Login wallet"),
        ),
      ),
    );
  }
}
