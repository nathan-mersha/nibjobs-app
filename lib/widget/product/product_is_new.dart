import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nibjobs/bloc/notification/notification_bloc.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';

class ProductIsNew extends StatefulWidget {
  final Job? _job;
  String fav;

  ProductIsNew(this._job, {this.fav = "", Key? key}) : super(key: key);

  @override
  _ProductIsNewState createState() => _ProductIsNewState();
}

class _ProductIsNewState extends State<ProductIsNew> {
  HSharedPreference hSharedPreference = HSharedPreference();
  bool isNew = false;
  Future<void> setterAllData() async {
    String dateFile = await hSharedPreference.get(
          HSharedPreference.KEY_USER_LAST_SEEN,
        ) ??
        "";
    if (dateFile == "") {
      // print("dateFile $dateFile");
      // BlocProvider.of<NotificationBloc>(context)
      //     .add(NotificationEventAdder(counter: widget.counter + 1));
      setState(() {
        isNew = true;
      });
    } else {
      DateTime dateLast = DateTime.parse(dateFile);
      if (dateLast.isBefore(widget._job!.lastModified!)) {
        // BlocProvider.of<NotificationBloc>(context)
        //     .add(NotificationEventAdder(counter: widget.counter + 1));
        setState(() {
          isNew = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setterAllData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        return Visibility(
          visible: isNew,
          child: Container(
            padding:
                const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
            decoration: BoxDecoration(
                color: CustomColor.PRIM_GREEN,
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              StringRsr.get(LanguageKey.NEW, firstCap: true)!,
              maxLines: 1,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.left,
              softWrap: false,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}
