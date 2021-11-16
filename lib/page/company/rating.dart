import 'package:flutter/material.dart';
import 'package:nibjobs/widget/nav/menu.dart';

class CompanyRatingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Menu.getAppBar(context, "Company Rating"),
      drawer: Menu.getSideDrawer(context),
      body: Container(
        child: Center(
          child: Text("Company rating page"),
        ),
      ),
    );
  }
}
