import 'package:flutter/material.dart';
import 'package:nibjobs/widget/nav/menu.dart';

class SendCreditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Menu.getAppBar(context, "Send credit page"),
      drawer: Menu.getSideDrawer(context),
      body: Container(
        child: Center(
          child: Text("Send credit page"),
        ),
      ),
    );
  }
}
