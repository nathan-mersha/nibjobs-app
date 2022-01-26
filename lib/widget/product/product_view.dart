import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:nibjobs/api/flutterfire.dart';
import 'package:nibjobs/bloc/notification/notification_bloc.dart';
import 'package:nibjobs/bloc/user/user_bloc.dart';
import 'package:nibjobs/db/k_shared_preference.dart';
import 'package:nibjobs/model/commerce/job.dart';
import 'package:nibjobs/route/route.dart';
import 'package:nibjobs/rsr/locale/lang/language_key.dart';
import 'package:nibjobs/rsr/locale/string_rsr.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/light_color.dart';
import 'package:nibjobs/themes/theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class JobView extends StatefulWidget {
  final Job? _job;
  int counter;
  final String size;
  bool pageAdmin;
  String fav;
  RewardedAd? rewardedAd;
  Function? onADs;
  final Function? onComplete;
  static const String SIZE_SMALL = "SIZE_SMALL";
  static const String SIZE_MEDIUM = "SIZE_MEDIUM";
  static const String SIZE_LARGE = "SIZE_LARGE";
  static final currencyFormat = new NumberFormat("#,##0.00", "en_US");

  JobView(this._job,
      {this.rewardedAd,
      this.onADs,
      this.size = SIZE_MEDIUM,
      this.counter = 0,
      this.pageAdmin = false,
      this.fav = "",
      this.onComplete});

  static Widget getThumbnailView(Job job,
      {bool expand = true,
      String size = SIZE_MEDIUM,
      bool detailPage = false}) {
    return job.company!.logo == null || job.company!.logo!.isEmpty
        ? Container()
        : CachedNetworkImage(
            imageUrl: detailPage ? job.jobChannel!.logo! : job.company!.logo!,
            useOldImageOnUrlChange: true,
            imageBuilder: (context, imagePath) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image(
                  image: imagePath,
                  fit: BoxFit.cover,
                ),
              );
            },
            placeholderFadeInDuration: const Duration(seconds: 1),
            placeholder: (BuildContext context, String imageURL) {
              return Center(
                child: Text(
                  detailPage
                      ? "${job.jobChannel!.name![0].toUpperCase()}${job.jobChannel!.name![1].toUpperCase()}"
                      : "${job.company!.name![0].toUpperCase()}${job.company!.name![1].toUpperCase()}",
                  // style: const TextStyle(
                  //   fontSize: 12,
                  //   color: CustomColor.PRIM_DARK,
                  // ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 12, color: CustomColor.PRIM_DARK),
                ),
              );
            },
            errorWidget: (BuildContext context, String imageURL, dynamic) {
              return Center(
                child: Text(
                  detailPage
                      ? "${job.jobChannel!.name![0].toUpperCase()}${job.jobChannel!.name![1].toUpperCase()}"
                      : "${job.company!.name![0].replaceAll(" ", "").toUpperCase()}${job.company!.name![1].replaceAll(" ", "").toUpperCase()}",
                  // style: const TextStyle(
                  //   fontSize: 12,
                  //   fontWeight: FontWeight.bold,
                  //   color: CustomColor.PRIM_DARK,
                  // ),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 12, color: CustomColor.PRIM_DARK),
                ),
              );
            },
          );
  }

  @override
  _JobViewState createState() => _JobViewState();
}

class _JobViewState extends State<JobView> {
  bool isSelected = false;
  bool isNew = false;
  HSharedPreference hSharedPreference = HSharedPreference();
  Widget getPricingView(BuildContext context, Job job,
      {double priceFontSize = 15,
      double regularPriceFontSize = 10,
      size = JobView.SIZE_SMALL}) {
    return FittedBox(
      fit: BoxFit.fill,
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          if (job.contractType! != "unAvailable")
            Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
              decoration: BoxDecoration(
                  color: CustomColor.PRIM_DARK,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                //"${currencyFormat.format(job.price).toString()}",
                job.contractType!,
                maxLines: 1,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.left,
                softWrap: false,
                style:
                    const TextStyle(color: CustomColor.TEXT_DARK, fontSize: 12),
              ),
            ),
          const SizedBox(
            width: 5,
          ),
          // Container(
          //   padding:
          //       const EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 3),
          //   decoration: BoxDecoration(
          //       color: CustomColor.PRIM_GREEN,
          //       borderRadius: BorderRadius.circular(10)),
          //   child: Text(
          //     job.status!,
          //     maxLines: 1,
          //     overflow: TextOverflow.fade,
          //     textAlign: TextAlign.left,
          //     softWrap: false,
          //     style: const TextStyle(color: Colors.white, fontSize: 12),
          //   ),
          // ),
          // const SizedBox(
          //   width: 5,
          // ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 5),
              child: Builder(builder: (context) {
                if (widget.pageAdmin) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.verified_user,
                        color: widget._job!.approved!
                            ? Colors.lightGreen
                            : LightColor.lightGrey,
                        size: 20,
                      ),
                    ),
                  );
                }
                return BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserSignedInState) {
                      return isSelected
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.visibility,
                                  // color:
                                  //     isSelected ? Colors.red : LightColor.lightGrey,
                                  color: Color(0xff9900ff),
                                  size: 15,
                                ),
                              ),
                            )
                          : Container();
                    }
                    return isSelected
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.visibility,
                                // color:
                                //     isSelected ? Colors.red : LightColor.lightGrey,
                                color: Color(0xff9900),
                                size: 15,
                              ),
                            ),
                          )
                        : Container();
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _showRewardedAd() {
    if (widget.rewardedAd == null) {
      Navigator.pushNamed(context, RouteTo.JOB_DETAIL, arguments: widget._job);
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    try {
      widget.rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) =>
            print('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          print('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
          widget.onADs!();
          // Navigator.pushNamed(context, RouteTo.JOB_DETAIL,
          //     arguments: widget._job);
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          widget.onADs!();
          Navigator.pushNamed(context, RouteTo.JOB_DETAIL,
              arguments: widget._job);
        },
      );

      widget.rewardedAd!.setImmersiveMode(true);
      widget.rewardedAd!.show(
          onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
        print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
        Navigator.pushNamed(context, RouteTo.JOB_DETAIL,
            arguments: widget._job);
      });
      widget.rewardedAd = null;
    } on Exception catch (e) {
      // TODO
      Navigator.pushNamed(context, RouteTo.JOB_DETAIL, arguments: widget._job);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seeInList();
    //setterAllData();
  }

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

  Future<void> seeInList() async {
    List<String> proFavList =
        await hSharedPreference.get(HSharedPreference.LIST_OF_FAV) ?? [];

    if (!(widget.fav == "Fav")) {
      if (proFavList.contains(widget._job!.id)) {
        setState(() {
          isSelected = true;
        });
        print("isSelected $isSelected");
      } else {
        setState(() {
          isSelected = false;
        });
        print("isSelected $isSelected");
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
    // setterAllData();
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is NotificationInitial) {
          widget.counter = state.counter;
        }
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () async {
                /// Navigating to item detail page
                if (!widget.pageAdmin) {
                  // BlocProvider.of<DownBloc>(context).add(
                  //     DownSelectedEvent(job: widget._job, context: context));
                  _showRewardedAd();

                  if (state is UserSignedInState) {
                    if (!isSelected) {
                      setState(() {
                        isSelected = true;
                      });
                      final result = await addFavJob(widget._job!);
                      if (result) {
                        addToList();
                        // Fluttertoast.showToast(
                        //     msg:
                        //     "${widget._product.name} ${StringRsr.get(LanguageKey.PRODUCT_ADDED_TO_FAVORITE_LIST)}",
                        //     toastLength: Toast.LENGTH_SHORT,
                        //     gravity: ToastGravity.CENTER,
                        //     timeInSecForIosWeb: 1,
                        //     backgroundColor: Colors.green,
                        //     textColor: Colors.white,
                        //     fontSize: 16.0);
                      } else {}
                    }
                  } else {
                    _showRewardedAd();
                  }
                } else {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, RouteTo.SHOP_ADD_ITEM,
                      arguments: widget._job);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: LightColor.iconColor, style: BorderStyle.none),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // Job name
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:
                                              AppTheme.fullWidth(context) < 361
                                                  ? 140
                                                  : 240,
                                          child: Text(
                                            "${widget._job!.title![0].toUpperCase()}${widget._job!.title!.substring(1).toLowerCase()}",
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.left,
                                            softWrap: false,
                                            // style: const TextStyle(
                                            //   color: CustomColor.TEXT_DARK,
                                            //   fontSize: 16,
                                            //   fontWeight: FontWeight.bold,
                                            // ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 3,
                                          ),
                                          height:
                                              AppTheme.fullWidth(context) < 330
                                                  ? 30
                                                  : 31,
                                          width:
                                              AppTheme.fullWidth(context) < 330
                                                  ? 30
                                                  : 31,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: JobView.getThumbnailView(
                                                widget._job!,
                                                size: JobView.SIZE_MEDIUM),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Job Author / Manufacturer
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:
                                              AppTheme.fullWidth(context) < 361
                                                  ? 100
                                                  : 200,
                                          child: Text(
                                            "by ${widget._job!.company!.name}",
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.left,
                                            softWrap: false,
                                            // style: const TextStyle(
                                            //   color: CustomColor.TEXT_DARK,
                                            // ),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                          ),
                                        ),
                                        Text(
                                          timeago.format(
                                              widget._job!.lastModified!),
                                          maxLines: 1,
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.right,
                                          softWrap: false,
                                          // style: const TextStyle(
                                          //   fontSize: 10,
                                          //   fontWeight: FontWeight.bold,
                                          //   color: CustomColor.RAD_DARK,
                                          // ),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
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
                                  // style: const TextStyle(
                                  //   fontSize: 12,
                                  //   color: CustomColor.TEXT_DARK,
                                  // ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: 12,
                                      ),
                                ),
                                const SizedBox(
                                  height: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    getPricingView(context, widget._job!),
                                    BlocBuilder<NotificationBloc,
                                        NotificationState>(
                                      builder: (context, state) {
                                        return Visibility(
                                          visible: isNew,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 3,
                                                bottom: 3),
                                            decoration: BoxDecoration(
                                                color: CustomColor.PRIM_GREEN,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(
                                              StringRsr.get(LanguageKey.NEW,
                                                  firstCap: true)!,
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              textAlign: TextAlign.left,
                                              softWrap: false,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        );
                                      },
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
          },
        );
      },
    );
  }
}
