import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  final Function? onRetry;
  final Widget? icon;
  final String? message;

  Message({this.icon, @required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon ?? Container(),
          const SizedBox(
            height: 14,
          ),
          message == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: AutoSizeText(
                    message!,
                    //style: const TextStyle(color: CustomColor.GRAY),
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 3,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.justify,
                  ),
                ),
          const SizedBox(
            height: 25,
          ),
          onRetry == null
              ? Container()
              : ElevatedButton(
                  child: const Text(
                    "retry",
                  ),
                  onPressed: () {
                    onRetry!();
                  },
                )
        ],
      ),
    );
  }
}
