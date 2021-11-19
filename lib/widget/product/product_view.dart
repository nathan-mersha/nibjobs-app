import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/model/profile/user.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class JobView extends StatefulWidget {
  final Job? _job;

  final String size;
  bool pageAdmin;
  String fav;
  final Function? onComplete;
  static const String SIZE_SMALL = "SIZE_SMALL";
  static const String SIZE_MEDIUM = "SIZE_MEDIUM";
  static const String SIZE_LARGE = "SIZE_LARGE";
  static final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  JobView(this._job,
      {this.size = SIZE_MEDIUM,
      this.pageAdmin = false,
      this.fav = "",
      this.onComplete});

  // static Widget getThumbnailView(Job job,
  //     {bool expand = true, String size = SIZE_MEDIUM}) {
  //   return job.image == null || job.image!.isEmpty
  //       ? JobPlaceholder(
  //           job: job,
  //           size: size,
  //         )
  //       : CachedNetworkImage(
  //           imageUrl: job.image![0],
  //           useOldImageOnUrlChange: true,
  //           imageBuilder: (context, imagePath) {
  //             return ClipRRect(
  //               borderRadius: BorderRadius.all(Radius.circular(20)),
  //               child: Image(
  //                 image: imagePath,
  //                 fit: BoxFit.cover,
  //               ),
  //             );
  //           },
  //           placeholderFadeInDuration: Duration(seconds: 1),
  //           placeholder: (BuildContext context, String imageURL) {
  //             return JobPlaceholder(job: job);
  //           },
  //           errorWidget: (BuildContext context, String imageURL, dynamic) {
  //             return JobPlaceholder(job: job);
  //           },
  //         );
  // }

  static Widget getPricingView(BuildContext context, Job job,
      {double priceFontSize = 15,
      double regularPriceFontSize = 10,
      size = JobView.SIZE_SMALL}) {
    return FittedBox(
      fit: BoxFit.fill,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: size == JobView.SIZE_LARGE
            ? MainAxisAlignment.start
            : MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            //"${currencyFormat.format(job.price).toString()}",
            "as",
            maxLines: 1,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.left,
            softWrap: false,
            style: TextStyle(
                color: CustomColor.TEXT_DARK,
                fontWeight: FontWeight.w800,
                fontSize: priceFontSize),
          ),
          // const SizedBox(
          //   width: size == JobView.SIZE_LARGE ? 10 : 0,
          // ),
          Text(
            StringRsr.get(LanguageKey.BR)!,
            maxLines: 1,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.left,
            softWrap: false,
            style: TextStyle(
                color: CustomColor.TEXT_DARK, fontSize: regularPriceFontSize),
          ),
        ],
      ),
    );
  }

  @override
  _JobViewState createState() => _JobViewState();
}

class _JobViewState extends State<JobView> {
  bool isSelected = false;
  HSharedPreference hSharedPreference = HSharedPreference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seeInList();
  }

  Future<void> seeInList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV) ?? [];

    if (!(widget.fav == "Fav")) {
      if (proFavList.contains(widget._job!.id)) {
        setState(() {
          isSelected = true;
        });
      } else {
        setState(() {
          isSelected = false;
        });
      }
    } else {
      setState(() {
        isSelected = true;
      });
      if (!proFavList.contains(widget._job!.id)) {
        await addToList();
      }
    }
  }

  Future<void> addToList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV) ?? [];
    proFavList.add(widget._job!.id.toString());

    await hSharedPreference.set(HSharedPreference.LIST_OF_FAV, proFavList);
  }

  Future<void> removeInList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV) ?? [];
    proFavList.remove(widget._job!.id.toString());
    await hSharedPreference.set(HSharedPreference.LIST_OF_FAV, proFavList);
  }

  Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// Navigating to item detail page
        if (!widget.pageAdmin) {
          // BlocProvider.of<DownBloc>(context).add(
          //     DownSelectedEvent(job: widget._job, context: context));
          Navigator.pushNamed(context, RouteTo.JOB_DETAIL,
              arguments: widget._job);
        } else {
          Navigator.pop(context);
          Navigator.pushNamed(context, RouteTo.SHOP_ADD_ITEM,
              arguments: widget._job);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border:
              Border.all(color: LightColor.iconColor, style: BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          // color:
          // isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Image thumbnail or image place holder
                // Expanded(
                //   flex: 1,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Stack(
                //       fit: StackFit.expand,
                //       children: [
                //         // JobView.getThumbnailView(widget._job!,
                //         //     size: JobView.SIZE_MEDIUM),
                //         Align(
                //           alignment: Alignment.topRight,
                //           child: Padding(
                //             padding: const EdgeInsets.only(right: 10.0, top: 5),
                //             child: Builder(builder: (context) {
                //               if (widget.pageAdmin) {
                //                 return Container(
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(24),
                //                     color: Colors.white,
                //                   ),
                //                   child: Padding(
                //                     padding: const EdgeInsets.all(4.0),
                //                     child: Icon(
                //                       Icons.verified_user,
                //                       color: widget._job!.approved!
                //                           ? Colors.lightGreen
                //                           : LightColor.lightGrey,
                //                       size: 20,
                //                     ),
                //                   ),
                //                 );
                //               }
                //               return BlocBuilder<UserBloc, UserState>(
                //                 builder: (context, state) {
                //                   if (state is UserSignedInState) {
                //                     return GestureDetector(
                //                       onTap: () async {
                //                         isSelected = !isSelected;
                //                         if (isSelected) {
                //                           final result =
                //                               await addFavJob(widget._job!);
                //                           if (result) {
                //                             addToList();
                //                             Fluttertoast.showToast(
                //                                 msg:
                //                                     "${widget._job!.title} ${StringRsr.get(LanguageKey.JOB_ADDED_TO_FAVORITE_LIST)}",
                //                                 toastLength: Toast.LENGTH_SHORT,
                //                                 gravity: ToastGravity.CENTER,
                //                                 timeInSecForIosWeb: 1,
                //                                 backgroundColor: Colors.green,
                //                                 textColor: Colors.white,
                //                                 fontSize: 16.0);
                //                           } else {}
                //                         } else {
                //                           final result =
                //                               await deleteFavJob(widget._job!);
                //                           if (result) {
                //                             removeInList();
                //                             Fluttertoast.showToast(
                //                                 msg:
                //                                     "${widget._job!.title} ${StringRsr.get(LanguageKey.JOB_REMOVED_FROM_FAVORITE_LIST)}",
                //                                 toastLength: Toast.LENGTH_SHORT,
                //                                 gravity: ToastGravity.CENTER,
                //                                 timeInSecForIosWeb: 1,
                //                                 backgroundColor: Colors.red,
                //                                 textColor: Colors.white,
                //                                 fontSize: 16.0);
                //                           } else {}
                //                         }
                //                         setState(() {});
                //                       },
                //                       child: Container(
                //                         decoration: BoxDecoration(
                //                           borderRadius: BorderRadius.circular(24),
                //                           color: Colors.white,
                //                         ),
                //                         child: Padding(
                //                           padding: const EdgeInsets.all(4.0),
                //                           child: Icon(
                //                             Icons.favorite,
                //                             color: isSelected
                //                                 ? Colors.red
                //                                 : LightColor.lightGrey,
                //                             size: 15,
                //                           ),
                //                         ),
                //                       ),
                //                     );
                //                   }
                //                   return GestureDetector(
                //                     onTap: () async {
                //                       Navigator.pushNamed(
                //                           context, RouteTo.PROFILE_SIGN_IN);
                //                     },
                //                     child: Container(
                //                       decoration: BoxDecoration(
                //                         borderRadius: BorderRadius.circular(24),
                //                         color: Colors.white,
                //                       ),
                //                       child: Padding(
                //                         padding: const EdgeInsets.all(4.0),
                //                         child: Icon(
                //                           Icons.favorite,
                //                           color: isSelected
                //                               ? Colors.red
                //                               : LightColor.lightGrey,
                //                           size: 15,
                //                         ),
                //                       ),
                //                     ),
                //                   );
                //                 },
                //               );
                //             }),
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),

                Expanded(
                  flex: 1,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        // Job name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget._job!.title![0].toUpperCase()}${widget._job!.title!.substring(1).toLowerCase()}",
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.left,
                              softWrap: false,
                              style: const TextStyle(
                                color: CustomColor.TEXT_DARK,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // Job Author / Manufacturer
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "by ${widget._job!.company!.name}",
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.left,
                                  softWrap: false,
                                  style: const TextStyle(
                                    color: CustomColor.TEXT_DARK,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    timeago.format(widget._job!.lastModified!),
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.right,
                                    softWrap: false,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: CustomColor.RAD_DARK,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 1,
                        ),
                        Text(
                          widget._job!.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          softWrap: false,
                          style: const TextStyle(
                            fontSize: 12,
                            color: CustomColor.TEXT_DARK,
                          ),
                        ),

                        // Price and regular price
                        const SizedBox(
                          height: 2,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child:
                                  JobView.getPricingView(context, widget._job!),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: GestureDetector(
                                onTap: () async {
                                  var uid = await hSharedPreference
                                      .get(HSharedPreference.KEY_USER_ID);
                                  var email = await hSharedPreference
                                      .get(HSharedPreference.KEY_USER_EMAIL);
                                  var phone = await hSharedPreference
                                      .get(HSharedPreference.KEY_USER_PHONE);
                                  var userName = await hSharedPreference
                                      .get(HSharedPreference.KEY_USER_NAME);
                                  var userImage = await hSharedPreference.get(
                                      HSharedPreference.KEY_USER_IMAGE_URL);
                                  List<String> list = await hSharedPreference
                                          .get(HSharedPreference
                                              .LIST_OF_FAV_CATEGORY) ??
                                      [];
                                  UserModel user = UserModel(
                                    userId: uid ??
                                        FirebaseAuth.instance.currentUser!.uid,
                                    email: email,
                                    profilePicture: userImage,
                                    phoneNumber: phone,
                                    userName: userName,
                                    categoryList: list,
                                  );
                                  CalledJob calledJob = CalledJob(
                                    job: widget._job,
                                    user: user,
                                    lastModified: DateTime.now(),
                                  );
                                  await addCallJob(calledJob);
                                  makePhoneCall(
                                      "tel:${widget._job!.company!.primaryPhone!.replaceAll("+", "").replaceAll(" ", "")}");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xff404040)),
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 5,
                                    bottom: 5,
                                    right: 12,
                                  ),
                                  child: Text(
                                    StringRsr.get(LanguageKey.CALL)!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )

                        // Job price and regular price
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
